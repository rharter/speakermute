//
//  SMPreferences.h
//  SpeakerMute
//
//  Created by Ryan Harter on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static SMPreferences *sharedPreferencesObject;

@interface SMPreferences : NSObject {
	bool		isActive;
	NSArray		*timeSpans;
	NSString	*title, message;
}

@property (copy) bool		isActive;
@property (copy) NSArray*	timeSpans;
@property (copy) NSString*	title;
@property (copy) NSString*	message;

+ (SMPreferences *) sharedPreferences;

@end
