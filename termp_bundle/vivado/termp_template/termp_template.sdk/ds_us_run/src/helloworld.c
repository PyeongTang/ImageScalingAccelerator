
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_cache.h"
#include "xil_types.h"

//#define DDR_BASE	XPAR_PS7_DDR_0_S_AXI_BASEADDR //00100000
#define DDR_BASE	0x10000000

#define INTC_DEVICE_ID		XPAR_SCUGIC_0_DEVICE_ID
#define INTC_DEVICE_INT_ID	61

int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr);
void DeviceDriverHandler(void *CallbackRef);
void CheckData(void);
void SendData(void);

XScuGic InterruptController;
static XScuGic_Config *GicConfig;

volatile static int InterruptProcessed = FALSE;

static void AssertPrint(const char8 *FilenamePtr, s32 LineNumber){
	xil_printf("ASSERT: File Name: %s ", FilenamePtr);
	xil_printf("Line Number: %d\r\n",LineNumber);
}


int main()
{
    init_platform();

	int Status;
	Xil_AssertSetCallback(AssertPrint);

//	xil_printf("Test\r\n");

	GicConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(&InterruptController, GicConfig,
					GicConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	/*
	 * Perform a self-test to ensure that the hardware was built
	 * correctly
	 */
	Status = XScuGic_SelfTest(&InterruptController);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	/*
	 * Setup the Interrupt System
	 */
	Status = SetUpInterruptSystem(&InterruptController);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XScuGic_Connect(&InterruptController, INTC_DEVICE_INT_ID,
				   (Xil_ExceptionHandler)DeviceDriverHandler,
				   (void *)&InterruptController);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Enable the interrupt for the device and then cause (simulate) an
	 * interrupt so the handlers will be called
	 */
	XScuGic_SetPriorityTriggerType(&InterruptController, INTC_DEVICE_INT_ID,0x00, 0x3);
	XScuGic_Enable(&InterruptController, INTC_DEVICE_INT_ID);


	while (1) {
		if (InterruptProcessed) {
			InterruptProcessed = FALSE;
//			 xil_printf("done\n\r");

//			 check data
//			CheckData();

			// send data
			SendData();

			sleep(1);
			XScuGic_Enable(&InterruptController, INTC_DEVICE_INT_ID);
		}
	}

    cleanup_platform();
    return 0;
}


int SetUpInterruptSystem(XScuGic *XScuGicInstancePtr) {
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			XScuGicInstancePtr);
	Xil_ExceptionEnable();
	return XST_SUCCESS;
}

void DeviceDriverHandler(void *CallbackRef) {
	XScuGic_Disable(&InterruptController, INTC_DEVICE_INT_ID);
	InterruptProcessed = TRUE;
}


void CheckData(void) {
	u32 tmp_data;

	for (int i = 0; i < 4; i++) {
		tmp_data = Xil_In32(XPAR_BRAM_0_BASEADDR + 4 * i);
		xil_printf("BRAM[%x]: %x\r\n", i, tmp_data);
	}

	for (int i = 240; i < 270; i++) {
		tmp_data = Xil_In32(XPAR_BRAM_0_BASEADDR + 4 * i);
		xil_printf("BRAM[%x]: %x\r\n", i, tmp_data);
	}

	for (int i = (256 * 256 - 4); i < (256 * 256); i++) {
		tmp_data = Xil_In32(XPAR_BRAM_0_BASEADDR + 4 * i);
		xil_printf("BRAM[%x]: %x\r\n", i, tmp_data);
	}
}

void SendData(void){
	u32 tmp_data;
	for (int i = 0; i < 256 * 256; i++) {
		tmp_data = Xil_In32(XPAR_BRAM_0_BASEADDR + 4 * i);
		Xil_Out32(DDR_BASE + 4 * i, tmp_data);
	}
	for (int i = 0; i < 256 * 256; i++) {
		tmp_data = Xil_In8(DDR_BASE + (4 * i) + 2);
		xil_printf("%c", tmp_data);
		tmp_data = Xil_In8(DDR_BASE + (4 * i) + 1);
		xil_printf("%c", tmp_data);
		tmp_data = Xil_In8(DDR_BASE + 4 * i);
		xil_printf("%c", tmp_data);
	}
}
