#ifndef MT9V032_H_
#define MT9V032_H_


#define BIT0            1<<0
#define BIT1            1<<1
#define BIT2            1<<2
#define BIT3            1<<3
#define BIT4            1<<4
#define BIT5            1<<5
#define BIT6            1<<6
#define BIT7            1<<7
#define BIT8            1<<8
#define BIT9            1<<9
#define BIT10           1<<10


//addresses
/*#define MT9V032_STATUS_REG      0
#define MT9V032_CONTROL_REG     1
#define MT9V032_ADDRESS_REG     2
#define MT9V032_NBPIXELS_REG    3*/

//status register
#define MTV_FRAME_FINISHED  BIT2
#define MTV_RUNNING         BIT3


//status register bits
#define MTV_FEEDBACK_BIT    BIT10

//control register
#define MTV_MODE_BW         BIT0
#define MTV_MODE_SNAPSHOT   0
#define MTV_MODE_VIDEO      BIT1
#define MTV_STOP            BIT2
#define MTV_START           BIT3
#define MTV_INTERRUPT       BIT4
#define MTV_MODE8Bits       BIT5
#define MTV_MODEBGRBits     BIT6
#define MTV_ICMODEPARRALLEL 0
#define MTV_ICMODESERIAL1   BIT8

//MT9V032_interface registers
#define MTV_STATUS_REG          0   //status of the interface
#define MTV_CONTROL_REG         1   //to control the interface
#define MTV_STARTADDRESS1_REG   2   //address1 of the image
#define MTV_STARTADDRESS2_REG   3   //address2 of the image
#define MTV_LASTBUFFERUSED_REG  4   //last buffer used
#define MTV_PIXELCNT_REG        5   //nb of pixels captured
#define MTV_CORRECTION_REG      6   //register to correct the color

//
// CAMERA I2C registers
//
#define MTV_CHIP_VERSION_REG    0x00
#define MTV_COLUMN_START_REG    0x01
#define MTV_ROW_START_REG       0x02
#define MTV_WINDOW_HEIGHT_REG   0x03
#define MTV_WINDOW_WIDTH_REG    0x04
#define MTV_CHIP_CONTROL_REG    0x07
#define MTV_SHUTTER_WIDTH_REG   0x0B
#define MTV_SOFT_RESET_REG      0x0C
#define MTV_READ_MODE           0x0D

#define MTV_ANALOG_GAIN_REG     0x35
    
#define MTV_AGC_AEC_ENABLE_REG      0xAF
#define MTV_AGC_AEC_PIXEL_CNT_REG   0xB0

#define MTV_LVDS_MASTER_CTRL_REG    0xB1
#define MTV_LVDS_SHIFT_CLK_CTRL_REG 0xB2
#define MTV_LVDS_DATA_CTRL_REG      0xB3
#define MTV_LVDS_INTERNAL_SYNC_REG  0xB5
#define MTV_LVDS_PAYLOAD_CTRL_REG   0xB6

#define MTV_THERMAL_INFOS_REG      0xC1

// MT9V022 I2C Device Address
#define MT9V022_I2C_ADDR           0x90
//#define MT9V022_I2C_ADDR_READ       0x91



//MT9V032 functions
void MT9V032_startFoto(int* xpCamera,int* xpImageAddress,int options);
void MT9V032_startVideo(int* xpCamera,int* xpImageAddress1,int* xpImageAddress2,int options);
void MT9V032_configure_LVD(int* i2c);


void MT9V032_configWhiteBalance(int* xpCamera,int temperature);

void MT9V032_temperatureToXYZ(int temperature, float  *XYZ);
void MT9V032_multVectorMatrix(float *v,float *a,float *r);

#endif /*MT9V032_H_*/
