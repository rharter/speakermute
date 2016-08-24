//
//  RHAudioController.h
//  SpeakerMute
//
//  Created by Ryan Harter on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <Foundation/Foundation.h>

@interface RHAudioController : NSObject {
	float			volume;
	UInt32			dataSource;
	BOOL			usingInternalSpeakers;
}

- (float) volume;
- (UInt32) dataSource;
- (BOOL) usingInternalSpeakers;

- (void) setVolume:(float)val;
- (void) mute;

@end
