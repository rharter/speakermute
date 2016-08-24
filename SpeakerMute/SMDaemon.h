//
//  SMDaemon.h
//  SpeakerMute
//
//  Created by Ryan Harter on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RHAudioController.h"

@interface SMDaemon : NSObject {
	BOOL				muted;
	RHAudioController	*ac;
}

- (void) volumeChangeHandler;

@end
