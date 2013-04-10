#include <stdio.h>
#include <io.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "terasic_includes.h"
#include "altera_avalon_spi.h"
#include "camera.h"
#include "unistd.h"

int main() {

	alt_u8 received1 = 0;
	alt_u8 received2 = 0;
	alt_u8 sent = 103;
	alt_u8 sentwrite[2];
	alt_u8 sentread = 78;

	int counter = 0;


	printf("Hello from semester thesis Nios II!\n");
	//printf("DDR2_1  Size: %d MBytes\n", MEM_IF_DDR2_EMIF_SPAN/1024/1024);

	/*
	 * pio[7] is cmv_reset_n, active low
	 * pio[6] is frame_req, active high
	 */

	usleep(10);
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x00); //cmv_reset_n, low
	usleep(10);
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80); //cmv_reset_n, high

	usleep(1000);
	//camera_init(SPI_1_BASE);
	camera_init(SPI_2_BASE);
	usleep(1000);
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x40); //sets pio[6] which is connected to cmv frameRequest
	usleep(1000);
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x00); //resets pio[6] which is connected to cmv frameRequest
	usleep(1000);


	while(1) {
		IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x40); //sets pio[6] which is connected to cmv frameRequest
//		IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x00); //frame req pulse


			/*
			 *  sends 8 bits (at address &sent) to spi interface of cmv4000 and stores read bits (at address &received1)
		     *  Bit[7] = 0 -> read operation
		     *  Bit[6..0] -> address
			 */
//			alt_avalon_spi_command(SPI_2_BASE,0,1,&sentread,1,&received2,0);
//			printf("value1: %d value2: %d\n",received1,received2);

		usleep(1000000);


	}

	return 0;
}
