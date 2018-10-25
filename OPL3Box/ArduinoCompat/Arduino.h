//
//  Arduino.h
//  OPL3Box
//
//  Created by Antonio Malara on 25/10/2018.
//  Copyright © 2018 Antonio Malara. All rights reserved.
//

#ifndef Arduino_h
#define Arduino_h

#include <math.h>

uint32_t micros()           { return 0; }
void     delay(uint16_t us) { }
void     _delay_ms(long ms) { }
void     _delay_us(long ms) { }

void     delayMicroseconds(double us) { }

#define F_CPU 1

enum {
    OUTPUT,
    INPUT_PULLUP,
    INPUT,
};

enum {
    HIGH,
    LOW,
};

void pinMode(int, int) {}
void digitalWrite(int, int) {}
bool digitalRead(int) { return false; }
unsigned long millis() { return 0; }

void noInterrupts() {}
void interrupts() {}

void cli() {}
void sei() {}

void itoa(int n, char* buf, size_t s) {
    snprintf(buf, s, "%d", n);
}

void ltoa(long n, char* buf, size_t s) {
    snprintf(buf, s, "%l", n);
}

void utoa(unsigned int n, char* buf, size_t s) {
    snprintf(buf, s, "%d", n);
}

#define __AVR_ATmega328P__ 1

const uint8_t A0 = 0;
const uint8_t A1 = 1;
const uint8_t A2 = 2;
const uint8_t A3 = 3;
uint8_t PORTB;
uint8_t PORTC;
uint8_t PORTD;
uint8_t DDRD;
uint8_t DDRB;
uint8_t DDRC;
uint8_t PINB;
uint8_t PINC;
uint8_t PIND;
uint8_t DRB;

uint8_t EECR;
uint8_t EEARL;
uint8_t EEDR;

uint8_t pgm_read_byte(const char *) { return 0; }
uint8_t pgm_read_byte(const uint8_t *) { return 0; }
void pgm_write_byte() { }

#define _BV(x) 0

typedef unsigned int*  uint_farptr_t;
void memcpy_PF(const uint8_t * b, uint_farptr_t p, size_t l) { }

#define PROGMEM

typedef struct __FlashStringHelper __FlashStringHelper;


#define min(a, b) std::min(a, b)
#define max(a, b) std::max(a, b)

struct Serial {
    void begin(int) { }
    bool available() { return false; }
    uint8_t read() { return 0; }
};

Serial Serial1;

#endif /* Arduino_h */
