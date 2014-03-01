/***************************************************************************
 *   Copyright (C) 2005, 2006, 2007, 2008, 2009 by Hilscher GmbH           *
 *                                                                         *
 *   Author: Christoph Thelen (cthelen@hilscher.com)                       *
 *                                                                         *
 *   Redistribution or unauthorized use without expressed written          *
 *   agreement from the Hilscher GmbH is forbidden.                        *
 ***************************************************************************/


#include <stddef.h>

#include "crc.h"
#include "netx_io_areas.h"


void crc_init_crc32(void)
{
	HOSTDEF(ptCrcArea);
	unsigned long ulValue;
	
	
	/* TODO: is this really necessary? */
	//ptCrcArea->ulCrc_crc = 0xffffffff;
	//ptCrcArea->ulCrc_polynomial = 0xffffffff;
	
	ulValue  = 31 << HOSTSRT(crc_config_crc_len);
	ulValue |= HOSTMSK(crc_config_crc_shift_right);
	ulValue |= 3 << HOSTSRT(crc_config_crc_nof_bits);
	ulValue |= HOSTMSK(crc_config_crc_in_msb_low);
	ptCrcArea->ulCrc_config = ulValue;
	
	ptCrcArea->ulCrc_crc = 0xffffffff;
	ptCrcArea->ulCrc_polynomial = 0x04c11db7;
}



void crc_init_crc16(void)
{
	HOSTDEF(ptCrcArea);
	unsigned long ulValue;
	
	
	/* TODO: is this really necessary? */
	//	ptCrcArea->ulCrc_crc = 0xffffffff;
	//ptCrcArea->ulCrc_polynomial = 0xffffffff;
	
	ulValue  = 15 << HOSTSRT(crc_config_crc_len);
	//	ulValue |= HOSTMSK(crc_config_crc_shift_right);
	ulValue |= 3 << HOSTSRT(crc_config_crc_nof_bits);
	//ulValue |= HOSTMSK(crc_config_crc_in_msb_low);
	ptCrcArea->ulCrc_config = ulValue;
	
	ptCrcArea->ulCrc_crc = 0x0000ffff;
	ptCrcArea->ulCrc_polynomial = 0x00001021;
}



unsigned long crc_get_crc32(void)
{
	HOSTDEF(ptCrcArea);
	unsigned long ulValue;
	
	
	ulValue  = ptCrcArea->ulCrc_crc;
	ulValue ^= 0xffffffff;
	return ulValue;
}



unsigned short crc_get_crc16(void)
{
	HOSTDEF(ptCrcArea);
	unsigned long ulValue;
	unsigned short usValue;
	
	
	ulValue = ptCrcArea->ulCrc_crc;
	usValue = (unsigned short)(ulValue & 0x0000ffff);
	return usValue;
}

