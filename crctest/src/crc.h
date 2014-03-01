/***************************************************************************
 *   Copyright (C) 2005, 2006, 2007, 2008, 2009 by Hilscher GmbH           *
 *                                                                         *
 *   Author: Christoph Thelen (cthelen@hilscher.com)                       *
 *                                                                         *
 *   Redistribution or unauthorized use without expressed written          *
 *   agreement from the Hilscher GmbH is forbidden.                        *
 ***************************************************************************/


#ifndef __CRC_H__
#define __CRC_H__


void crc_init_crc32(void);
void crc_init_crc16(void);

#define crc_update(ucData) ptCrcArea->ulCrc_data_in = ((unsigned long)(ucData))
#define crc_update_dw(ulData) ptCrcArea->ulCrc_data_in = (ulData); ptCrcArea->ulCrc_data_in = ((ulData)>>8); ptCrcArea->ulCrc_data_in = ((ulData)>>16); ptCrcArea->ulCrc_data_in = ((ulData)>>24)

unsigned long crc_get_crc32(void);
unsigned short crc_get_crc16(void);


#endif  /* __CRC_H__ */

