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

void crc_update(unsigned char ucData);
void crc_update_dw(unsigned long ulData);

unsigned long crc_get_crc32(void);


#endif  /* __CRC_H__ */

