//
//  SMDialogController.h
//  SpeakerMute
//
//  Created by Ryan Harter on 1/13/10.
//  Copyright 2010 Ryan Harter. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMDialogController : NSObject {
	IBOutlet	NSTextField		*lblTitle;
	IBOutlet	NSTextField		*lblMessage;
	IBOutlet	NSTextField		*lblAutoClose;
	IBOutlet	NSWindow		*window;
}

- (IBAction)close:(id)sender;

@end
