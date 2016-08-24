//
//  SMDialogController.m
//  SpeakerMute
//
//  Created by Ryan Harter on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMDialogController.h"



@implementation SMDialogController

- (void) awakeFromNib
{
	// Make sure our window is on top.
	[window makeKeyAndOrderFront:nil];
	
	// Make us a delegate of NSApp so that we can
	//	pretend to be document based.
	[NSApp	setDelegate:self];
	
}

- (IBAction)close:(id)sender;
{	
	[window close];
}
	 
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)inSender
{
	return YES;
}

@end
