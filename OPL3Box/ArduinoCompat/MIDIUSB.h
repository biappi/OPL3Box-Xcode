//
//  MIDIUSB.h
//  OPL3Box
//
//  Created by Antonio Malara on 25/10/2018.
//  Copyright © 2018 Antonio Malara. All rights reserved.
//

#ifndef MIDIUSB_h
#define MIDIUSB_h

struct midiEventPacket_t {
    uint8_t header;
    uint8_t byte1;
    uint8_t byte2;
    uint8_t byte3;
    
};

struct USB {
    midiEventPacket_t read() {
        return midiEventPacket_t();
    }
};

static USB MidiUSB;

#endif /* MIDIUSB_h */
