#include <stdio.h>
#include <io.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "terasic_includes.h"
#include "altera_avalon_spi.h"
#include "camera.h"

int main() {
	printf("Hello from semester thesis Nios II!\n");
	printf("DDR2_1  Size: %d MBytes\n", MEM_IF_DDR2_EMIF_SPAN/1024/1024);

	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x00);
	camera_init(SPI_1_BASE);
	camera_init(SPI_2_BASE);

	while(1) {
		IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x40); //sets pio[7] which is connected to cmv frameRequest
	}

	return 0;
}
