//
//  SMDaemon.m
//  SpeakerMute
//
//  Created by Ryan Harter on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMDaemon.h"

#pragma mark Listener Callback

OSStatus listener (AudioDeviceID inDevice,
				   UInt32 inChannel,
				   Boolean isInput,
				   AudioDevicePropertyID inPropertyID,
				   void * inClientData)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[(SMDaemon *)inClientData volumeChangeHandler];
	
	[pool release];
	return noErr;
}

@implementation SMDaemon

// Muted flag - TRUE if muted by us, FALSE if muted by the user
BOOL muted = false;

- (void) volumeChangeHandler
{
	// TODO: Check in the preferences to see if we are supposed to be active
	if ([ac volume] > 0.0f)
	{
		if ([ac usingInternalSpeakers])
		{
			NSLog(@"Muting sound.");
			
			[ac mute];
			muted = YES;
			
			// Get the shared workspace
			[[NSWorkspace sharedWorkspace] launchApplication:@"SMDialog"];
		}
		else
		{
			if (muted == YES)
			{
				NSLog(@"Headphones detected and we muted the sound. Resetting...");
				
				// Reset sound so users know it's enabled. Using 40%
				[ac setVolume:0.40];
				
				muted = NO;
			}
		}
	}
}

- (void)awakeFromNib
{
	AudioDeviceID	dev;
	UInt32			size;
	UInt32			channels[2];
	OSStatus		err;
	
	// To start things off we need to instantiate the audio controller.
	ac = [[RHAudioController alloc] init];
	
	NSLog(@"Starting Speaker Mute.");
	
	size = sizeof(dev);
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultSystemOutputDevice, &size, &dev);
	NSCAssert((err == noErr), @"Could not get default system output device");
	//NSLog([NSString stringWithFormat:@"Device ID: %i", dev]);
	
	// Register for volume change notifications
	err = AudioDeviceAddPropertyListener(dev, 0, 0, kAudioDevicePropertyVolumeScalar, listener, self);
	if (err != noErr)
		NSLog(@"Volume Changed.");
	
	// Just to be safe, because sometimes things get f'ed up, we need
	//	to register on the stereo channels as well.
	// TODO: Eventually I need to move this to the Audio Controller object
	// Get channel numbers.
	size = sizeof(channels);
	err = AudioDeviceGetProperty(dev, 0, 0, kAudioDevicePropertyPreferredChannelsForStereo, &size, &channels);
	NSAssert((err == noErr), @"AudioDeviceGetProperty failed to get channel numbers.");
	
	err = AudioDeviceAddPropertyListener(dev, channels[0], false, kAudioDevicePropertyVolumeScalar, listener, self);
	if (err != noErr)
		NSLog(@"Volume Changed on stereo channel.");
	
	err = AudioDeviceAddPropertyListener(dev, channels[1], false, kAudioDevicePropertyVolumeScalar, listener, self);
	if (err != noErr)
		NSLog(@"Volume Changed on stereo channel.");
	
	
	// Also register for notifications of dataSource changes
	err = AudioDeviceAddPropertyListener(dev, 0, 0, kAudioDevicePropertyDeviceHasChanged, listener, self);
	if (err != noErr)
		NSLog(@"Datasource changed.");
	
	[self volumeChangeHandler];
}

@end
