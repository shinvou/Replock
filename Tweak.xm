//
//  Tweak.xm
//  Replock
//
//  Created by Timm Kandziora on 23.02.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "Replock-Header.h"

%group MessagesNotificationViewService

%hook CKInlineReplyViewController

- (void)messageEntryViewSendButtonHit:(CKMessageEntryView *)entryView
{
	%orig();

	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.shinvou.replock.lock" object:nil userInfo:nil];
}

%end

%end

%ctor {
	@autoreleasepool {
		if ([[[NSClassFromString(@"NSProcessInfo") processInfo] processName] isEqualToString:@"MessagesNotificationViewService"]) {
			%init(MessagesNotificationViewService);
		}
	}
}
