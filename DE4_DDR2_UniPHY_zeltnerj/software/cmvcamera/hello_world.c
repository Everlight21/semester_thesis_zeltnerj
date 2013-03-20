/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <io.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "terasic_includes.h"
#include "mem_test.h"
#include "altera_avalon_spi.h"
#include "camera.h"


#define SHOW_PROGRESS
#define xTEST_I2C

  int dir = 0;
  int i = 0;

int main()
{
  printf("Hello from cmvcamera Nios II!\n");

  bool bPass, bLoop = FALSE;
    int MemSize_1 = MEM_IF_DDR2_EMIF_SPAN;
//  int MemSize_2 = MEM_IF_DDR2_EMIF_0_SPAN;
  int TimeStart, TimeElapsed, TestIndex = 0;
 void *ddr2_base_1 = (void *)MEM_IF_DDR2_EMIF_BASE;
//  void *ddr2_base_2 = (void *)MEM_IF_DDR2_EMIF_0_BASE;
  alt_u32 InitValue;
//  alt_u8 ButtonMask;
  alt_u8 received1 = 0;
  alt_u8 received2 = 0;
  alt_u8 sent = 125;
  alt_u8 sentwrite[2];




//  printf("===== DE4 DDR2 Test Program (UniPHY) =====\n");
//  printf("DDR2 Clock: 400 MHZ\n");
    printf("DDR2_1  Size: %d MBytes\n", MEM_IF_DDR2_EMIF_SPAN/1024/1024);
//    printf("test: %d\n",*test);
//  printf("DDR2_2  Size: %d MBytes\n", MEM_IF_DDR2_EMIF_0_SPAN/1024/1024);

  //  alt_u32 *test = 0x40000000;
    alt_u32 *test = 0x40000000;
 //   *test = 0;


	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0xFF);


	camera_init(SPI_1_BASE);
	camera_init(SPI_2_BASE);




  while (1)
   {

	  if (dir>=60)
	      {
		  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80 | 0x40);

		  /*alt_avalon_spi_command(SPI_1_BASE,0,1,&sent,1,&received1,0);
		  alt_avalon_spi_command(SPI_2_BASE,0,1,&sent,1,&received2,0);
//		  sent ++;
//		  if (sent>=120)
//		  {
//			  sent = 0x0;
//		  }
		  printf("value1: %d value2: %d\n",received1,received2);
		  //received = 64;
		  //IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80|0x40);

		  dir = 0;
	      }
	      else
	      {
	    	  dir ++;
		  	//  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x80);*/
	      }



  i = 0;
  while (i<80000)
    i++;
}


  return 0;
}
