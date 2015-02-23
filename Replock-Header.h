//
//  Replock-Header.h
//  Replock
//
//  Created by Timm Kandziora on 23.02.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <substrate.h>
#import <Foundation/NSDistributedNotificationCenter.h>

#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEventSystem.h>

@interface ReplockHelper : NSObject
+ (id)sharedInstance;
- (void)startListening;
- (void)prepareToLockDevice;
- (void)lockDevice;
@end

@interface CKMessageEntryView
@end

@interface SBLockScreenManager : NSObject
@property (readonly, assign) BOOL isUILocked;
+ (id)sharedInstance;
@end

@interface SpringBoard : UIApplication
- (void)_lockButtonDown:(IOHIDEventRef)event fromSource:(int)source;
- (void)_lockButtonUp:(IOHIDEventRef)event fromSource:(int)source;
@end
