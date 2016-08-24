//
//  RHAudioController.m
//  SpeakerMute
//
//  Created by Ryan Harter on 1/7/10.
//  Copyright 2010 Ryan Harter. All rights reserved.
//

#import "RHAudioController.h"


@implementation RHAudioController

// Custom Accessors - We need these since we have to update 
//	the variables every time they are accessed.  So do we still
//	need the actual variables or are they just for show?
- (UInt32) dataSource
{
	UInt32			size;
	OSStatus		err;
	AudioDeviceID	dev;
	
	// First we need to get the dev ID
	size = sizeof(dev);
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultSystemOutputDevice, &size, &dev);
	NSAssert((err == noErr), @"AudioHardwareGetProperty failed to get the default system output device");
	
	// Now get the data source
	size = sizeof(dataSource);
	err = AudioDeviceGetProperty(dev, 0, 0, kAudioDevicePropertyDataSource, &size, &dataSource);
	NSAssert((err == noErr), @"AudioDeviceGetProperty failed to get the device data source.");
	
	usingInternalSpeakers = (dataSource == 'ispk');
	
	return dataSource;
}

- (BOOL)usingInternalSpeakers
{
	// Call the dataSource function since that will
	//	update the usingInternalSpeakers variable.
	[self dataSource];
	
	return usingInternalSpeakers;
}

- (float) volume
{
	float			b_vol;
	OSStatus		err;
	AudioDeviceID	dev;
	UInt32			size;
	UInt32			channels[2];
	float			vol[2];
	
	// First we need to get the dev ID
	size = sizeof(dev);
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultSystemOutputDevice, &size, &dev);
	NSAssert((err == noErr), @"AudioHardwareGetProperty failed to get the default system output device");

	// Then we try to get the master volume (channel 0)
	size = sizeof(b_vol);
	err = AudioDeviceGetProperty(dev, 0, 0, kAudioDevicePropertyVolumeScalar, &size, &b_vol);
	
	// Otherwise, try seperate channels
	if (err != noErr)
	{
		// Get channel numbers.
		size = sizeof(channels);
		err = AudioDeviceGetProperty(dev, 0, 0, kAudioDevicePropertyPreferredChannelsForStereo, &size, &channels);
		NSAssert((err == noErr), @"AudioDeviceGetProperty failed to get channel numbers.");
		
		// Get the individual volume
		size = sizeof(float);
		err = AudioDeviceGetProperty(dev, channels[0], 0, kAudioDevicePropertyVolumeScalar, &size, &vol[0]);
		NSAssert((err == noErr), @"AudioDeviceGetProperty failed to get volume of channel 1");
		err = AudioDeviceGetProperty(dev, channels[1], 0, kAudioDevicePropertyVolumeScalar, &size, &vol[1]);
		NSAssert((err == noErr), @"AudioDeviceGetProperty failed to get volume of channel 2");
		
		b_vol = (vol[0] + vol[1]) / 2.00;
	}
	
	return b_vol;  // Dr. Gibbs would be proud of my single exit point :)
}

// Mutators (I guess) - Though we aren't just setting the variables, its
//	really setting the volume and the variable.  That way any time the 
//	volume variable is changed it will also change the volume.
- (void) setVolume:(float)val
{
	OSStatus			err;
	AudioDeviceID		dev;
	UInt32				size;
	Boolean				canset = false;
	UInt32				channels[2];
	
	// First we need to get the dev ID
	size = sizeof(dev);
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultSystemOutputDevice, &size, &dev);
	NSCAssert((err == noErr), @"AudioHardwareGetProperty failed to get the default system output device");

	// Then we try to set the master volume (channel 0)
	size = sizeof(canset);
	err = AudioDeviceGetPropertyInfo(dev, 0, false, kAudioDevicePropertyVolumeScalar, &size, &canset);
	if (err == noErr && canset == true) 
	{
		size = sizeof(val);
		err = AudioDeviceSetProperty(dev, NULL, 0, false, kAudioDevicePropertyVolumeScalar, size, &val);
	}
	else
	{
		// Otherwise try seperate channels
		//  First, get them
		size = sizeof(channels);
		err = AudioDeviceGetProperty(dev, 0, false, kAudioDevicePropertyPreferredChannelsForStereo, &size, &channels);
		NSCAssert((err == noErr), @"AudioDeviceGetProperty failed to get channel numbers.");
		
		// Set the volume
		size = sizeof(float);
		err = AudioDeviceSetProperty(dev, NULL, channels[0], false, kAudioDevicePropertyVolumeScalar, size, &val);
		NSAssert((err == noErr), @"AudioDeviceSetProperty failed to set volume of channel 0");
		err = AudioDeviceSetProperty(dev, NULL, channels[1], false, kAudioDevicePropertyVolumeScalar, size, &val);
		NSAssert((err == noErr), @"AudioDeviceSetProperty failed to set volume of channel ");
	}
}

- (void) mute
{
	[self setVolume:0.00];
}

@end
