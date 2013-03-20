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
	alt_u8 sent = 78;
	alt_u8 sentwrite[2];
	alt_u8 sentread;

	int counter = 0;


	printf("Hello from semester thesis Nios II!\n");
	printf("DDR2_1  Size: %d MBytes\n", MEM_IF_DDR2_EMIF_SPAN/1024/1024);

	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x00);
	usleep(1);
	camera_init(SPI_1_BASE);
	//camera_init(SPI_2_BASE);
	usleep(1);

	while(1) {
		IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x40); //sets pio[7] which is connected to cmv frameRequest

		if (counter == 16000000) {
			counter = 0;

			/*
			 *  sends 8 bits (at address &sent) to spi interface of cmv4000 and stores read bits (at address &received1)
		     *  Bit[7] = 0 -> read operation
		     *  Bit[6..0] -> address
			 */
			sentread = 78 & 0x8f;
			alt_avalon_spi_command(SPI_1_BASE,0,1,&sent,1,&received1,0);
			printf("value1: %d value2: %d\n",received1,received2);

		} else {
			counter += 1;
		}


	}

	return 0;
}
