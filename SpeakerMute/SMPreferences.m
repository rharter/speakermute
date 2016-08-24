//
//  SMPreferences.m
//  SpeakerMute
//
//  Created by Ryan Harter on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMPreferences.h"

@implementation SMPreferences

@synthesize	isActive;
@synthesize	timeSpans;
@synthesize	title;
@synthesize	message;

+ (SMPreferences *) sharedPreferences
{
	@synchronized(self)
	{
		if (sharedPreferencesObject == nil)
		{
			[[self alloc] init];
		}
	}
	return sharedPreferencesObject;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedPreferencesObject == nil)
		{
			return [super allocWithZone:zone];
		}
	}
	return sharedPreferencesObject;
}

- (id)init
{
	SMPreferences prefs = [self class];
	
	@synchronized(prefs)
	{
		if (sharedPreferencesObject == nil)
		{
			if (self = [super init])
			{
				sharedPreferencesObject = self
				// Custom init here.
			}
		}
	}
}

@end
