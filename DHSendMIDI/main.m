//
//  main.m
//  DHSendMIDI
//
//  Created by Douglas Heriot on 23/01/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SnoizeMIDI/SnoizeMIDI.h>
#include <getopt.h>

enum OPTION
{
	O_VERSION			= 'V',
	O_HELP				= 'h',
	
	O_CHANNEL			= 'c',
	O_DESTINATION		= 'd',
	O_VERBOSE			= 'v',
	
	O_NOTE_OFF			= 'm',
	O_NOTE_ON			= 'n',
	O_AFTERTOUCH		= 'a',
	O_CONTROL_CHANGE	= 'r',
	O_PROGRAM_CHANGE	= 'p',
	O_CHANNEL_PRESSURE	= 's',
	O_PITCH_WHEEL		= 'w',
};

void printVersion(void);
void printHelp(void);

int main(int argc, char * const *argv)
{
	@autoreleasepool
	{
		SMVoiceMessageStatus messageStatus = SMVoiceMessageStatusControl;
		Byte channel = 1;
		uint8_t data[2] = {0};
		NSString *destination = nil;
		BOOL verbose = NO;
		
		static struct option longOoptions[] = {
			{"version",			no_argument,		NULL,	O_VERSION},
			{"help",			no_argument,		NULL,	O_HELP},
			
			{"channel",			required_argument,	NULL,	'c'},
			{"destination",		required_argument,	NULL,	'd'},
			{"verbose",			no_argument,		NULL,	'v'},
			
			{"note-off",		no_argument,		NULL,	O_NOTE_OFF},
			{"note-on",			no_argument,		NULL,	O_NOTE_ON},
			{"aftertouch",		no_argument,		NULL,	O_AFTERTOUCH},
			{"control-change",	no_argument,		NULL,	O_CONTROL_CHANGE},
			{"control",			no_argument,		NULL,	O_CONTROL_CHANGE},
			{"cc",				no_argument,		NULL,	O_CONTROL_CHANGE},
			{"program-change",	no_argument,		NULL,	O_PROGRAM_CHANGE},
			{"program",			no_argument,		NULL,	O_PROGRAM_CHANGE},
			{"pc",				no_argument,		NULL,	O_PROGRAM_CHANGE},
			{"channel-pressure",no_argument,		NULL,	O_CHANNEL_PRESSURE},
			{"pressure",		no_argument,		NULL,	O_CHANNEL_PRESSURE},
			{"pitch-wheel",		no_argument,		NULL,	O_PITCH_WHEEL},
			{"pitch",			no_argument,		NULL,	O_PITCH_WHEEL},
		};
		const char shortOptions[] = {
			O_VERSION, O_HELP,
			O_CHANNEL, ':', O_DESTINATION, ':', O_VERBOSE,
			O_NOTE_ON, O_NOTE_OFF, O_AFTERTOUCH, O_CONTROL_CHANGE, O_PROGRAM_CHANGE, O_CHANNEL_PRESSURE, O_PITCH_WHEEL,
			'\0'};
		
		int ch;
		while((ch = getopt_long(argc, argv, shortOptions, longOoptions, NULL)) != -1)
		{
			switch ((enum OPTION)ch)
			{
				case O_VERSION:
					printVersion();
					exit(0);
					break;
					
				case O_HELP:
					printVersion();
					printHelp();
					exit(0);
					break;
					
				case O_CHANNEL:
					channel = atoi(optarg);
					
					// Make sure it’s within bounds 1-16
					channel -= 1;
					channel %= 16;
					channel += 1;
					break;
					
				case O_DESTINATION:
					destination = [NSString stringWithUTF8String:optarg];
					break;
					
				case O_VERBOSE:
					verbose = YES;
					break;
					
				case O_NOTE_ON:
					messageStatus = SMVoiceMessageStatusNoteOn;
					break;
				case O_NOTE_OFF:
					messageStatus = SMVoiceMessageStatusNoteOff;
					break;
				case O_AFTERTOUCH:
					messageStatus = SMVoiceMessageStatusAftertouch;
					break;
				case O_CONTROL_CHANGE:
					messageStatus = SMVoiceMessageStatusControl;
					break;
				case O_PROGRAM_CHANGE:
					messageStatus = SMVoiceMessageStatusProgram;
					break;
				case O_CHANNEL_PRESSURE:
					messageStatus = SMVoiceMessageStatusChannelPressure;
					break;
				case O_PITCH_WHEEL:
					messageStatus = SMVoiceMessageStatusPitchWheel;
					break;
			}
		}
		
		argc -= optind;
		argv += optind;
		
		
		// Create the message
		SMVoiceMessage *message = [[SMVoiceMessage alloc] initWithTimeStamp:0 statusByte:messageStatus];
		[message setTimeStampToNow];
		[message setChannel:channel];
		
		const NSUInteger requiredLength = message.otherDataLength;
		
		// Check the given arguments
		if(argc != requiredLength)
		{
			const char s[] = {requiredLength == 1 ? '\0' : 's', '\0'};
			fprintf(stderr, "%s message must have %lu argument%s\n", message.typeForDisplay.UTF8String, requiredLength, s);
			
			return 1;
		}
		
		
		// Get the arguments
		// Make sure they’re within 0-127, by &ing with 0x7F
		
		data[0] = atoi(argv[0]) & 0x7F;
		[message setDataByte1:data[0]];
		
		if(requiredLength > 1)
		{
			data[1] = atoi(argv[1]) & 0x7F;
			[message setDataByte2:data[2]];
		}
		
		
		SMPortOutputStream *os = [[SMPortOutputStream alloc] init];
		
		// Set the destination endpoints
		NSSet *endpoints = nil;
		
		if(destination)
			endpoints = [NSSet setWithObject:[SMDestinationEndpoint destinationEndpointWithName:destination]];
		else
			endpoints = [NSSet setWithArray:[SMDestinationEndpoint destinationEndpoints]];
						 
		[os setEndpoints:endpoints];
		
		
		// Send the message
		[os takeMIDIMessages:@[message]];
		
		
		if(verbose)
		{
			printf("Sent %s: %d", message.typeForDisplay.UTF8String, data[0]);
			if([message otherDataLength] > 1)
				printf(" %d", data[1]);
			printf("\n");
		}
	}
    return 0;
}

void printVersion(void)
{
	printf("DHSendMIDI 1.0\nCopyright 2013, Douglas Heriot\nhttps://github.com/DouglasHeriot/DHSendMIDI\n");
}

void printHelp(void)
{
	printf("DHSendMIDI");
}




