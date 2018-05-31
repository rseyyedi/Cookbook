/*
 * The following codes implement polled Master send and receive.
 * It is running on MicroBlaze connected to a AXI IIC IP.
 * Borrowed from xiic_low_level_eeprom_example.c
 */

typedef u8 AddressType;

unsigned I2CMaster(u16 DeviceId, u8 *SendBuffer, u8 *ReadBuffer, u16 ByteCount, AddressType SlaveAddr)
{
	volatile unsigned SentByteCount;
	do {
		SentByteCount = XIic_Send(IIC_BASE_ADDRESS, MOTOR1_ADDRESS,
						  SendBuffer, ByteCount,
						  XIIC_STOP);
		if (SentByteCount != ByteCount) {
			/* Send is aborted so reset Tx FIFO */
			XIic_WriteReg(IIC_BASE_ADDRESS,  XIIC_CR_REG_OFFSET,
					XIIC_CR_TX_FIFO_RESET_MASK);
			XIic_WriteReg(IIC_BASE_ADDRESS, XIIC_CR_REG_OFFSET,
					XIIC_CR_ENABLE_DEVICE_MASK);
		}

	} while (SentByteCount != ByteCount);

	return SentByteCount - ByteCount;
}
