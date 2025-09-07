#include "stm8s_i2c.h"
#include "stm8s_clk.h"
#include "stm8s_gpio.h"
//#include "font8x8_basic.h"
//#include "string.h"

#define I2C_DIRECTION_TX 0
#define I2C_DIRECTION_RX 1

uint8_t addr = 0x6b;
int i2cspeed = 100000;

void i2c_setup(void);
uint8_t readRegisterByte(uint8_t slave_addr,uint8_t register_addr);
void writeRegisterByte(uint8_t slave_addr, uint8_t register_addr, uint8_t data);
void writeRegisterWord(uint8_t slave_addr, uint8_t register_addr, uint16_t data);
main() {
	//uint8_t reg_val;
	//uint8_t newval;
	//uint16_t spanning = 0x03e8;
	//uint8_t spanning_lsb = 0xe8;
	//uint8_t spanning_msb = 0x03;
	//i2c_setup();
	
	//reg_val = readRegisterByte(addr, 0x19);
	//newval = reg_val | 1;
	//writeRegisterByte(addr, 0x19, newval);
	
	//writeRegisterByte(addr, 0x0c, spanning_lsb);
	//writeRegisterByte(addr, 0x0d, spanning_msb);
	while (1){
	//i2c_display_image(5, 0,"t",8);
	//delay();
	}
}

void i2c_setup(void) {
	u8 Input_Clock = 0;
	Input_Clock = CLK_GetClockFreq()/1000000;
  I2C_Init(i2cspeed, 0xa0, I2C_DUTYCYCLE_2, I2C_ACK_CURR, I2C_ADDMODE_7BIT, Input_Clock);
}

uint8_t readRegisterByte(uint8_t slave_addr, uint8_t ReadAddr) {
	u16 pBuffer;
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
	I2C_GenerateSTART(ENABLE);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
	I2C_SendData((u8)(ReadAddr));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_GenerateSTART(ENABLE);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_RX);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED));
	pBuffer = I2C_ReceiveData();
	I2C_AcknowledgeConfig(I2C_ACK_NONE);
	I2C_GenerateSTOP(ENABLE);
	return pBuffer;
}

void writeRegisterByte(uint8_t slave_addr, uint8_t register_addr, uint8_t data){
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
	I2C_GenerateSTART(ENABLE);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
	I2C_SendData((u8)(register_addr));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_SendData((u8)(data));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_GenerateSTOP(ENABLE);
}
void writeRegisterWord(uint8_t slave_addr, uint8_t register_addr, uint16_t data){
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
	I2C_GenerateSTART(ENABLE);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
	I2C_SendData((u8)(register_addr));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_SendData((u8)(data));
	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
	I2C_GenerateSTOP(ENABLE);
}

