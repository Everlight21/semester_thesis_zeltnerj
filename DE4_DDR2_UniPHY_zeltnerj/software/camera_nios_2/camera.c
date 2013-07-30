/*
 * camera.c
 *
 *  Created on: 18.12.2012
 *      Author: dominiho
 */

#include "system.h"
#include "altera_avalon_spi.h"

void camera_init(alt_u32 SPI_BASE) {

	alt_u8 sentwrite[2];
	alt_u8 received = 0;

	sentwrite[1] = 44;
	sentwrite[0] = 103 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 4;
	sentwrite[0] = 84 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 1;
	sentwrite[0] = 85 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 64;
	sentwrite[0] = 88 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 64;
	sentwrite[0] = 91 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 101;
	sentwrite[0] = 94 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 109;
	sentwrite[0] = 98 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 109;
	sentwrite[0] = 99 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 106;
	sentwrite[0] = 95 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 1;
	sentwrite[0] = 117 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 1;
	sentwrite[0] = 115 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 7;
	sentwrite[0] = 82 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	//adjusting registers for optimal performance
	sentwrite[1] = 44; //req:44, valid:40-55
	sentwrite[0] = 103 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 109; //req:109, valid:102-115
	sentwrite[0] = 98 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	sentwrite[1] = 109; //req:109, valid:102-115
	sentwrite[0] = 99 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	//channel mode 0=16 channels; 1=8 channels; 2=4 channels; 3=2 channels
	sentwrite[1] = 2;
	sentwrite[0] = 72 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	//	request amount of frames
	sentwrite[1] = 1;
	sentwrite[0] = 70 | 0x80;

	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
	//	training pattern 1
	sentwrite[1] = 0x00; //0b01010101
	sentwrite[0] = 78 | 0x80;

	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

	//	training pattern 2
	sentwrite[1] = 0x02;
	sentwrite[0] = 79 | 0x80;

	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	//number of lines 1 255
//	sentwrite[1] = 0x30; //0x40
//	sentwrite[0] = 1 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	//number of lines 2 1
//	sentwrite[1] = 0x04; //0x04
//	sentwrite[0] = 2 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
////
//	//start row window 1
//	sentwrite[1] = 0x00; //0x00
//	sentwrite[0] = 3 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	//start row window 2
//	sentwrite[1] = 0x00; //0x00
//	sentwrite[0] = 4 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	// row skip 1
//	sentwrite[1] = 0x00; //0x00
//	sentwrite[0] = 35 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	// row skip 2
//	sentwrite[1] = 0x00; //0x00
//	sentwrite[0] = 37 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);


	//bit mode
	sentwrite[1] = 0x01;
	sentwrite[0] = 111 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);


	//	image flipping x/y
	sentwrite[1] = 0x01; //0x01: image flipping x
	sentwrite[0] = 40 | 0x80;
	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

//	//	exposure time 1
//	sentwrite[1] = 0x00; //0x40
//	sentwrite[0] = 42 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	//	exposure time 2
//	sentwrite[1] = 0x04; //0x04
//	sentwrite[0] = 43 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);
//
//	//	exposure time 3
//	sentwrite[1] = 0x00; //0x00
//	sentwrite[0] = 44 | 0x80;
//	alt_avalon_spi_command(SPI_BASE, 0, 2, sentwrite, 0, &received, 0);

}
