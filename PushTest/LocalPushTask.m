//
//  LocalPushTask.m
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "LocalPushTask.h"

@implementation LocalPushTask
+ (instancetype)sharedInstance {
    static LocalPushTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LocalPushTask new];
    });
    return instance;
}

- (void) detectServerMessage {
    // create sever message
    
    // create local push
    
}
@end
