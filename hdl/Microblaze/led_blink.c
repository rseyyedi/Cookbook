#include "xgpio.h"
#include "xparameters.h"
#include "microblaze_sleep.h"

XGpio GpioOutput;

int main (void) {

	XGpio_Initialize(&GpioOutput, XPAR_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&GpioOutput, 1, 0x0);

	while (1) {
		// Turn on LEDs
		XGpio_DiscreteWrite(&GpioOutput, 1, 0xF);
		sleep(1);
		// Turn off LEDs
		XGpio_DiscreteWrite(&GpioOutput, 1, 0x0);
		sleep(1);
	}
}
