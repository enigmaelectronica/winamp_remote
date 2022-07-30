/* Infrared Transmitter for Winamp IR Remote Control */

#include <pic.h>
#include <stdio.h>
#include "usart.h"
#include "delay.h"
#include "always.h"

__CONFIG(PWRTDIS & UNPROTECT & BORDIS & WDTDIS & LVPDIS & HS & MCLRDIS);

void main(void)
{
	int ASCIIdata;

	CMCON = 0x07;			// Disable Comparators.
	TRISA = 0xFF;			// PORTA pins as inputs.

	TRISB = 0b11110111;		// PORTB pins as input except RB3(CCP1).
	OPTION = 0b00000000;	// Enable PORTB weak pull-ups.

	init_comms();			// Initialize the COMMs 1200 Baud, 8 bits, 1 Stop bit, No parity.

	PR2 = 25;				// Load the PR2 value of 25 to get a PWM Period of 26.32us. PWM freq = 38kHz.
	CCPR1L = 13;			// Load the value of **52 = 13 * 4. This give 50% duty cycle.
	T2CON = 0b00000100;		// 1:1 Prescale, 1:1 Postscale, TMR2 on.
	CCP1CON = 0b00001111;	// Enable PWM mode on pin CCP1(RB3).

	for (;;)
	{
		while(1)
		{
			if 	(RB0 == 0)				// Check if RB0 button was pushed.
			{	ASCIIdata = 0x30;		// Send ASCII '0' if it was button pushed.
				putch(ASCIIdata);
				while(RB0 == 0)			// Wait for the release of the button.
				{
				}
				break;					// Exit the while loop after the button is released.
			}
			else if	(RA3 == 0)			// Do the same for the rest of the buttons with different ASCIIs.
			{	ASCIIdata = 0x31;
				putch(ASCIIdata);
				while(RA3 == 0)
				{
				}
				break;
			}
			else if	(RB4 == 0)
			{	ASCIIdata = 0x32;
				putch(ASCIIdata);
				while(RB4 == 0)
				{
				}
				break;
			}
			else if	(RB5 == 0)
			{	ASCIIdata = 0x33;
				putch(ASCIIdata);
				while(RB5 == 0)
				{
				}
				break;
			}
			else if	(RB6 == 0)		// RB4 and RB5 are volume up and volume down respectively.
			{	ASCIIdata = 0x34;	// Volume Control buttons. May be held on to continuously
				putch(ASCIIdata);	// adjust the volume of Winamp.
				DelayMs(45);		// Slow down data sending rate to the IR Receiver to prevent
				break;				// extreme rise or decrease in volume.
			}
			else if	(RB7 == 0)
			{	ASCIIdata = 0x35;
				putch(ASCIIdata);
				DelayMs(45);
				break;
			}
			else if	(RA0 == 0)		//RB6 and RB7 are Forward and Rewind respectively.
			{	ASCIIdata = 0x36;	// It may be held down for continuous forwarding/rewinding.
				putch(ASCIIdata);	// Delay to slow down sending rate to IR Receiver.
				DelayMs(45);
				break;
			}
			else if	(RA1 == 0)
			{	ASCIIdata = 0x37;
				putch(ASCIIdata);
				DelayMs(45);
				break;
			}
			else if	(RA2 == 0)
			{	ASCIIdata = 0x38;
				putch(ASCIIdata);
				while(RA2 == 0)
				{
				}
				break;
			}
		}
	}
}
