/*-----------------------------------------------------------------
 * i2c.c - I2C interface library
 *-----------------------------------------------------------------
 * $Id: i2c.c,v 1.2 2002/12/10 16:25:56 cgaudin Exp $
 *-----------------------------------------------------------------
 * Author   : $Author: cgaudin $
 * Revision : $Revision: 1.2 $
 * Date     : $Date: 2002/12/10 16:25:56 $
 *-----------------------------------------------------------------*/
#include "i2c.h"
#include "system.h"
#include "IO.h"

/* wait a milisecond */
#define N_DELAY { int i; for (i=0; i<ALT_CPU_FREQ/1000;) i++; }

/* wait some microseconds */
#define WAIT { int i; for (i=0; i<100;) i++; }

/* wait for end of transfer */
#define WAIT_FOR_EOT(i2c_base,t) { while ((t=IORD(i2c_base,I2C_STATUS_REG)) & I2C_TIP) WAIT; }

/*
 * Set Serial Clock Speed in hz 
 */
void i2c_set_speed(int *i2c_base, int speed_in_hz)
{
  int div = ALT_CPU_FREQ / (4000 * speed_in_hz);
  
  if (ALT_CPU_FREQ % (4000 * speed_in_hz))
    div++;

  IOWR(i2c_base,I2C_CLKDIV_REG ,(unsigned char)div);
  
  /* wait a milisecond */
  N_DELAY;
} 

/* 
 * Set FAST mode (400 kHz)
 */
void i2c_fastmode(int *i2c_base)
{
  i2c_set_speed(i2c_base, 400);
}

/*
 * Set NORMAL mode (100 kHz)
 */
void i2c_normal_mode(int *i2c_base)
{
  i2c_set_speed(i2c_base, 100);
}

/*
 * Set register index (no data write)  
 */
int i2c_write_index( int *i2c_base, 
                      unsigned char index , unsigned char deviceAddress)
{
  unsigned char t;

  /* Attend la fin du transfert precedent */
  WAIT_FOR_EOT(i2c_base, t);

  /* ecriture de l'adresse du peripherique + R/W bit = 0 ( ecriture ) */

  IOWR(i2c_base,I2C_DATA_REG, deviceAddress& 0xFE );
  IOWR(i2c_base,I2C_CTRL_REG, ( I2C_START | I2C_WRITE ));

  /* Attend la fin du transfert */
  WAIT_FOR_EOT(i2c_base, t);

  /* le périphérique repond ? */
  if ( t & I2C_LRA )
    return -1;
  
  /* Ecriture de l'adresse du registre */
  
  IOWR(i2c_base,I2C_DATA_REG, index);
  IOWR(i2c_base,I2C_CTRL_REG, I2C_WRITE);
  
  /* Attend la fin du transfert */
  WAIT_FOR_EOT(i2c_base, t);

  /* Mauvaise quittance */
  if ( t & I2C_LRA )
    return -1;

  /* Quittance du fanion d'interruption 
   * du controleur I2C */
  //io->np_i2c_data = 0;

  IOWR(i2c_base,I2C_DATA_REG, 0);

  return 0;
}



int i2c_double_write( int *i2c_base,unsigned char deviceAddress ,unsigned char index ,unsigned int value )
{
      int rc;
      unsigned char t;
    
      if ((rc=i2c_write_index(i2c_base, index,deviceAddress)) < 0)
        return rc;
      
      char value1=(value&0xFF00)>>8;
      char value2=value&0x00FF;
      
      /* Ecriture de la donnee */
      IOWR(i2c_base,I2C_DATA_REG,value1);
      IOWR(i2c_base,I2C_CTRL_REG,I2C_WRITE);
      
      /* Attend la fin du transfert */
      WAIT_FOR_EOT(i2c_base, t);
      
      /* Mauvaise quittance ? */
      if (t & I2C_LRA)
        return -1;
      
       /* Ecriture de la donnee */
      IOWR(i2c_base,I2C_DATA_REG,value2);
      IOWR(i2c_base,I2C_CTRL_REG,I2C_WRITE | I2C_STOP );
      
      /* Attend la fin du transfert */
      WAIT_FOR_EOT(i2c_base, t);
      
      /* Mauvaise quittance ? */
      if (t & I2C_LRA)
        return -1;
      
      /* Quittancement du fanion d'interruption */    
      IOWR(i2c_base,I2C_DATA_REG,0);
    
    
      return 0; 
  
}

/*
 * Lecture d'une valeur d'un registre 16 bits 
 */
int i2c_double_read( int *i2c_base ,
                      unsigned char deviceAddress,
                      unsigned char index ,
                      unsigned int *value )
{

    int rc;
  unsigned char t;
  unsigned char byte1,byte2;
  /* set index */
  if ((rc=i2c_write_index( i2c_base , index,deviceAddress )) < 0)//read addresses have a 1 at the end
    return rc;

  /* Repete la sequence I2C Start (RepStart) pour 
   * effectuer la lecture
   * Ecriture de l'adresse + bit R/W = 1 (lecture) */


    IOWR(i2c_base,I2C_DATA_REG, deviceAddress|0x01);//read addresses have a 1 at the end
    IOWR(i2c_base,I2C_CTRL_REG, I2C_WRITE | I2C_START);

  /* Attend la fin du transfert */
  WAIT_FOR_EOT(i2c_base, t);

  /* le peripherique repond ? */
  if ( t & I2C_LRA )
    return -1;

  //t = io->np_i2c_data;
  t=IORD(i2c_base,I2C_DATA_REG);
  
  IOWR(i2c_base,I2C_CTRL_REG,( I2C_READ | I2C_ACK));
  
  
  /* Attend la fin du transfert */
  WAIT_FOR_EOT(i2c_base, t);
  //byte1=io->np_i2c_data;
  byte1=IORD(i2c_base,I2C_DATA_REG);
    
  //t = io->np_i2c_data;
  t=IORD(i2c_base,I2C_DATA_REG);
  
  //io->np_i2c_ctrl = ( I2C_READ | I2C_STOP | I2C_NO_ACK);
  IOWR(i2c_base,I2C_CTRL_REG,( I2C_READ | I2C_STOP | I2C_NO_ACK));
  
  
  /* Attend la fin du transfert */
  WAIT_FOR_EOT(i2c_base, t);
  
  //byte2=io->np_i2c_data;
  byte2=IORD(i2c_base,I2C_DATA_REG);
  
  /* Lecture de la donnee recue */
  (*value)=0;//to be sure that no bit left to one
  (*value) = (byte1<<8) |  byte2;

  return 0;
}
