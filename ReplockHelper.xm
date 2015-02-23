//
//  ReplockHelper.xm
//  Replock
//
//  Created by Timm Kandziora on 23.02.15.
//  Copyright (c) 2014 Timm Kandziora (shinvou). All rights reserved.
//

#import "Replock-Header.h"

@implementation ReplockHelper

+ (id)sharedInstance
{
	static ReplockHelper *sharedInstance;

	static dispatch_once_t provider_token;
	dispatch_once(&provider_token, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

- (void)startListening
{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareToLockDevice) name:@"com.shinvou.replock.lock" object:nil];
}

- (void)prepareToLockDevice
{
	if ([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
		[self performSelector:@selector(lockDevice) withObject:nil afterDelay:0.5];
	}
}

- (void)lockDevice
{
	uint64_t timeStamp = mach_absolute_time(); // I _love_ CPU specific stuff ...
	IOHIDEventRef event = IOHIDEventCreate(kCFAllocatorDefault, kIOHIDEventTypeKeyboard, *(AbsoluteTime *)&timeStamp, 0);
	SpringBoard *springBoard = (SpringBoard *)[objc_getClass("SpringBoard") sharedApplication];
	[springBoard _lockButtonDown:event fromSource:1];
	[springBoard _lockButtonUp:event fromSource:1];
	CFRelease(event);
}

@end

%ctor {
	@autoreleasepool {
		if ([[[NSClassFromString(@"NSProcessInfo") processInfo] processName] isEqualToString:@"SpringBoard"]) {
			[[ReplockHelper sharedInstance] startListening];
		}
	}
}
