//
//  main.m
//  DHSendMIDI
//
//  Created by Douglas Heriot on 23/01/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SnoizeMIDI/SnoizeMIDI.h>

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		if(argc != 3)
		{
			fprintf(stderr, "Must have 2 arguments - MIDI CC Controller and Value\n");
			return 1;
		}
		
		SMPortOutputStream *os = [[SMPortOutputStream alloc] init];
		[os setEndpoints:[NSSet setWithArray:[SMDestinationEndpoint destinationEndpoints]]];
		
		uint8_t byte1 = atoi(argv[1]);
		uint8_t byte2 = atoi(argv[2]);
		
		SMVoiceMessage *message = [[SMVoiceMessage alloc] initWithTimeStamp:0 statusByte:SMVoiceMessageStatusControl];
		[message setTimeStampToNow];
		[message setDataByte1:byte1];
		[message setDataByte2:byte2];
		[message setChannel:1];
		
		[os takeMIDIMessages:@[message]];
		
		printf("Sent CC %u %u\n", byte1, byte2);
	}
    return 0;
}

