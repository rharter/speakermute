//
//  SMTimeSpan.h
//  SpeakerMute
//
//  Created by Ryan Harter on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMTimeSpan : NSObject {
	NSDate		*startTime, *endTime;
	NSString	*name;
}

@property (copy) NSDate*	startTime;
@property (copy) NSDate*	endTime;
@property (copy) NSString*	name;

@end
