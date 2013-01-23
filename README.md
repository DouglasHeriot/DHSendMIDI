# DHSendMIDI

DHSendMIDI is a simple tool for sending MIDI messages from an OS X command line.

There’s no complicated config files to set up or anything – it just simple sends MIDI messages for you!

Note that sometimes there could be a little delay as OS X wakes up its internal MIDI Server on each execution. It seems that if you’ve got other apps using MIDI also open, it can do this so quickly you probably won’t notice it.

## Sounds awesome!

There’s no prebuilt downloads just yet (I’ll get to that soon when it’s ready for general use)

## Usage

    DHSendMIDI [options] byte1 [byte2]

### Voice Messages

You can use one of the self-explanatory options to set the kind of message you’d like to send: `--note-on`, `--note-off`, `--aftertouch`, `--control-change`, `--program-change`, `--channel-pressure`, `--pitch-wheel`.

Some examples:

    DHSendMIDI --control-change 7 9

    DHSendMIDI --note-on 54 127
    
    DHSendMIDI --note-off 54 0

    DHSendMIDI --program-change 2

Note that program change and channel pressure messages only have one data byte to send.

    DHSendMIDI --pitch-wheel 0 64
    
Note pitch bend messages are 2 bytes, making a 14-bit value (yes, 14 bits – MIDI uses 7-bit values, and the 8th bit to represent control bytes). It’s *little endian*, so values `0 64` places the wheel in the centre.

### Channel

Set the channel (a number 1-16) with `--channel` or `-c`

    DHSendMIDI --channel 8 --cc 0 127

    
(Sends control change message setting controller `0` to value `127`, on channel `8`)

### Destination Device

You can specify a specific device to send to. When this option isn’t specified, messages are sent to **all** devices.

For example, to send to IAC Driver, Bus 1:

    DHSendMIDI --destination "Bus 1" --note-on 52 113


### Other Options

* `--verbose`, `-v` – Prints message being sent
* `--version`, `-V` – Displays version
	

### More Help

For slightly more detailed options (and short versions), see

    DHSendMIDI --help


## Getting the Code

Note it includes SnoizeMIDI as a submodule, so clone recursively:

    git clone --recursive git://github.com/DouglasHeriot/DHSendMIDI.git

## License

DHSendMIDI has a BSD-style license. See the file LICENSE.md

Also includes SnoizeMIDI:


### SnoizeMIDI

Copyright © 2001-2010, Kurt Revis.  All rights reserved.

Small modifications by Douglas Heriot, 2011.
http://github.com/krevis/MIDIApps/
http://github.com/DouglasHeriot/MIDIApps/

See LICENSE.md for more details

