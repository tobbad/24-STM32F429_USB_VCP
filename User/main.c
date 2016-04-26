/**
 *	USB VCP for STM32F4xx example.
 *    
 *	@author		Tilen Majerle
 *	@email		tilen@majerle.eu
 *	@website	http://stm32f4-discovery.com
 *	@ide		Keil uVision
 *	@packs		STM32F4xx Keil packs version 2.2.0 or greater required
 *	@stdperiph	STM32F4xx Standard peripheral drivers version 1.4.0 or greater required
 *
 * Add line below to use this example with F429 Discovery board (in defines.h file)
 *
 * #define USE_USB_OTG_HS
 *
 * Before compile in Keil, select your target, I made some settings for different targets
 */
#include "tm_stm32f4_usb_vcp.h"
#include "tm_stm32f4_disco.h"
#include "defines.h"
#include <string.h>
 

char* bin2hex(char c)
{
	static char outb[2];
	for (uint8_t i=0;i<2;i++)
	{
		char out = (c>>(1-i)*4) & 0x0f;
		if (out < 10)
		{
			out+='0';
		} else {
			out= (out-10)+'A';
		}
		outb[i] =out;
	}
	return outb;
}

typedef struct _at_cmd_tbl
{
	char * question;
	char * response;
} at_cmd_t;

static const at_cmd_t at_cmd[]={
	{"AT\r",		"\r\nCONNECT\r\n"},
	{"AT+CGMI\r", 	"\r\nBAEROSPACE\r\nOK\r\n"},
	{"AT+CGMM\r", 	"\r\nCeasars Crypter\r\nOK\r\n"},
};
static uint16_t at_cmd_size = sizeof(at_cmd)/sizeof(at_cmd[0]);

char * check_for_at_cmd(char* buf, uint16_t buf_size, uint16_t *buf_idx)
{
	char *pRet = NULL;
	char at[] = "AT";
	char final[]="\r";
	char def_ans[]="\r\nOK\r\n";
	char * buf_end = &buf[buf_size-1];
	uint16_t scan_idx = *buf_idx;
	/*
	 * Check for known commands
	 */
	for (uint16_t i=0;i<at_cmd_size;i++)
	{
		if ( strcmp(&buf[scan_idx], at_cmd[i].question) == 0 ){
			pRet =  at_cmd[i].response;
			scan_idx += strlen(at_cmd[i].question);
			break;
		}
	}
	/*
	 * No known command
	 */
	if (pRet==0){
		/* Check if it starts with AT .. */
		if ( strncmp(&buf[scan_idx], at, strlen(at)) == 0 ){
			char * pStart = &buf[scan_idx];
			/* ... and ends with \r */
			char * pEnd = strstr(pStart, final);
			if (pEnd != NULL){
				scan_idx += (uint16_t)(pEnd-pStart+1);
				pRet = def_ans;
			}
		}
	}
	*buf_idx = scan_idx;
	return pRet;
}


int main(void) {
    uint8_t c;
    uint8_t cmd_mode = 0;
    char * CR = "\r\n";
    static const uint16_t BUF_SIZE=2048;
    uint16_t buf_wr_idx=0;
    uint16_t buf_scan_idx = 0;
    char buf[BUF_SIZE];
    /* System Init */
    SystemInit();
    
    /* Initialize LED's. Make sure to check settings for your board in tm_stm32f4_disco.h file */
    TM_DISCO_LedInit();
    
    /* Initialize USB VCP */    
    TM_USB_VCP_Init();
    
    while (1) {
        /* USB configured OK, drivers OK */
        if (TM_USB_VCP_GetStatus() == TM_USB_VCP_CONNECTED) {
            /* Turn on GREEN led */
            TM_DISCO_LedOn(LED_GREEN);
            /* If something arrived at VCP */
            if (TM_USB_VCP_Getc(&c) == TM_USB_VCP_DATA_OK) {
            	buf[buf_wr_idx]=c;
            	buf_wr_idx =(buf_wr_idx+1)%(BUF_SIZE-1);
            	if (buf_wr_idx == 0){
            		buf[BUF_SIZE-1] = '\0';
            	} else{
            	   	buf[buf_wr_idx] = '\0';
            	}
            	if ( ((c>='0') && (c<='9')) ||
            	     ((c>='A') && (c<='Z')) ||
					 ((c>='a') && (c<='z')) )
            	{
            		c+=1;
            	}
            	if (c == '\r')
            	{
            		char *pRet = check_for_at_cmd(buf, BUF_SIZE, &buf_scan_idx);
            		if (pRet)
            		{
            			TM_USB_VCP_Puts(pRet);
            		} else {
            			TM_USB_VCP_Puts(CR);
            		}
            	} else if ( c == '@'){
            		char *pBuf = buf;
            		char start[]="0x";
            		char gap[]=", ";
            		TM_USB_VCP_Puts(CR);
            		while ( *pBuf != '\0')
            		{
            			TM_USB_VCP_Puts(start);
            			TM_USB_VCP_Puts(bin2hex(*pBuf));
            			pBuf++;
            			TM_USB_VCP_Puts(gap);
            		}
            		TM_USB_VCP_Puts(CR);

            	}
            	else {
            		/* Return data back */
            		//TM_USB_VCP_Putc(c);
            	}
            }
        } else {
            /* USB not OK */
            TM_DISCO_LedOff(LED_GREEN);
        }
    }
}
