//
//  PersonChatViewController.h
//  yupaopao
//
//  Created by a on 16/8/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

typedef enum : NSUInteger {
    personIsNormal,
    personIsVIP,
    personIsSVIP,
} VIPType;

@interface PersonChatViewController : RCConversationViewController

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *state;

@property (nonatomic,assign) VIPType type;

@end
