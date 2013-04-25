/*-----------------------------------------------------------------
 * i2c.h - I2C interface library
 *-----------------------------------------------------------------
 * $Id: i2c.h,v 1.4 2002/04/14 21:50:56 cgaudin Exp $
 *-----------------------------------------------------------------
 * Author   : $Author: cgaudin $
 * Revision : $Revision: 1.4 $
 * Date     : $Date: 2002/04/14 21:50:56 $
 *-----------------------------------------------------------------*/
 
#ifndef _i2c_h_
#define _i2c_h_

 
/* I2C status register bits
 * ------------------------ */
#define I2C_TIP        (1<<3) // transfer in progress 
#define I2C_INTR       (1<<2) // interrupt pending    
#define I2C_BUSY       (1<<1) // I2C busy             
#define I2C_LRA        (1<<0) // last received ack    

/* I2C control register bits
 * ------------------------- */
#define I2C_IRQ_ENABLE (1<<5) // interrupt enable    
#define I2C_WRITE      (1<<4) // write               
#define I2C_READ       (1<<3) // read                
#define I2C_START      (1<<2) // start               
#define I2C_STOP       (1<<1) // stop                
#define I2C_NO_ACK     (1<<0) // no ack to send         
#define I2C_ACK        (0<<0) // ack to send

/* I2C error codes
 * --------------- */
#define I2C_ENODEV     1      // no device
#define I2C_EBADACK    2      // bad acknowledge received


/* I2C Clock Divisor Standard Values
 * --------------------------------- */

/* 50 kHz */
#define I2C_SLOW   0xA3

/* 100 kHz */
#define I2C_NORMAL 0x54

/* 400 kHz */ 
#define I2C_FAST   0x15


#define I2C_DATA_REG    0
#define I2C_CTRL_REG    1
#define I2C_STATUS_REG  2
#define I2C_CLKDIV_REG  3

/* I2C registers
 * ------------- */
typedef volatile struct
{
  int np_i2c_data;   // Read/Write, 8-bit
  int np_i2c_ctrl;   // Write-only, 8-bit
  int np_i2c_status; // Read-only,  8-bit
  int np_i2c_clkdiv; // Read/Write, 8-bit
} np_i2c;


/* function declarations
 * --------------------- */
 
/* Fast mode (400 kHz) */
extern void i2c_fastmode(int *i2c_base);

/* Normal mode (100 kHz) */
extern void i2c_normal_mode(int *i2c_base);



//i2c functions
int i2c_write_index( int *i2c_base , unsigned char index , unsigned char deviceAddress);

int i2c_double_write(int *i2c_base, unsigned char deviceAddress,unsigned char index ,unsigned int value );
int i2c_double_read( int *i2c_base, unsigned char deviceAddress,unsigned char index ,unsigned int *value );



#endif /* _i2c_h_ */
