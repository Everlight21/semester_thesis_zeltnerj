#include "MT9V032.h"
#include "IO.h"
#include "i2c.h"
//#include "math.h"
/* Ask the camera to take a photo
 * 
 * 
 * 
 * */
void MT9V032_startFoto(int* xpCamera,int* xpImageAddress, int options)
{
    IOWR(xpCamera,MTV_STARTADDRESS1_REG,(int)xpImageAddress);//indicate address
    IOWR(xpCamera,MTV_CONTROL_REG,MTV_INTERRUPT | MTV_START | MTV_MODE_SNAPSHOT | options);//start

}
/*
 * 
 * 
 */
 void MT9V032_startVideo(int* xpCamera,int* xpImageAddress1,int* xpImageAddress2,int options)
 {
    //indicates both buffers
    IOWR(xpCamera,MTV_STARTADDRESS1_REG,(int)xpImageAddress1);
    IOWR(xpCamera,MTV_STARTADDRESS2_REG,(int)xpImageAddress2);

    IOWR(xpCamera,MTV_CONTROL_REG,MTV_INTERRUPT | MTV_START | MTV_MODE_VIDEO| options);
 }


void MT9V032_configure_LVD(int* i2c)
{
    int value;
      
   
    //wants 8 bits data, 1 bit FV and 1 bit LV
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_LVDS_PAYLOAD_CTRL_REG,0x00);//0->8 bits
    //enable lvds driver
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_LVDS_DATA_CTRL_REG,0x00);//0xB3[4]=0
    //de-assert lvds power-down
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_LVDS_MASTER_CTRL_REG,0x00);//0xB1[1]=0

    //soft reset
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_SOFT_RESET_REG,0x01);//0x0C[0]=0
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_SOFT_RESET_REG,0x00);//0x0C[0]=0

    //enable sync pattern during 100ms, to help the deserializer
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_LVDS_INTERNAL_SYNC_REG,0x01);//0xB1[1]=0
    usleep(100000);
    i2c_double_write(i2c ,MT9V022_I2C_ADDR,MTV_LVDS_INTERNAL_SYNC_REG,0x00);//0xB1[1]=0


}

void MT9V032_configWhiteBalance(int* xpCamera,int temperature)
{
    
    float XYZws[3];
    float XYZwd[3];
    
    float coeffS[3];
    float coeffD[3];
    
    float factor1,factor2,factor3;
    
    float ma[9];
    ma[0]=0.8951;
    ma[1]=-0.7502;
    ma[2]=0.0389;
    ma[3]=0.2664;
    ma[4]=1.7135;
    ma[5]=-0.0685;
    ma[6]=-0.1614;
    ma[7]=0.0367;
    ma[8]=1.0296;

    
    MT9V032_temperatureToXYZ(temperature,XYZws);
    MT9V032_temperatureToXYZ(6504,XYZwd);//D65=6504K, D50=5003K
    
    MT9V032_multVectorMatrix(XYZws,ma,coeffS);
    MT9V032_multVectorMatrix(XYZwd,ma,coeffD);
      
    //compute coeffs
    factor1=coeffD[0]/coeffS[0];
    factor2=coeffD[1]/coeffS[1];
    factor3=coeffD[2]/coeffS[2];
    

    //in the camera, the factors are 
    int factorCAM1=(int)(factor1*64);
    int factorCAM2=(int)(factor2*64);
    int factorCAM3=(int)(factor3*64);
    

    IOWR(xpCamera,MTV_CORRECTION_REG,factorCAM3<<16|factorCAM2<<8|factorCAM1);

  
    
}

void MT9V032_multVectorMatrix(float *v,float *a,float *r)
{
    int col;
    int line;
    
    for(col=0;col<3;col++)
    {
        r[col]=0;
        for(line=0;line<3;line++)
        {       
            r[col]+=a[line*3+col]*v[line];
        }
    }
}

void MT9V032_temperatureToXYZ(int temperature, float  *XYZ)
{
    float x,y;
        
    if(temperature>=4000&& temperature<=7000)//temperature>=4000 &&
    {
        x=(-4.6070*pow(10, 9)/pow(temperature,3))+(2.9678*pow(10, 6)/pow(temperature,2))+(0.09911*pow(10, 3)/pow(temperature,1))+0.244063;
    }
    else
    {
        x=(-2.0064*pow(10, 9)/pow(temperature,3))+(1.9018*pow(10, 6)/pow(temperature,2))+(0.24748*pow(10, 3)/pow(temperature,1))+0.237040;
    }
    
    y=-3*pow(x,2)+2.87*x-0.275;
    
    
    XYZ[1]=1.0;//Y=100
    XYZ[0]=(x*XYZ[1])/y;
    XYZ[2]=((1-x-y)*XYZ[1])/y;  
}
