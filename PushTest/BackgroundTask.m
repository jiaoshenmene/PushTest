//
//  BackgroundTask.m
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "BackgroundTask.h"
#import <UIKit/UIKit.h>
@implementation BackgroundTask

+ (instancetype)sharedInstance {
    static BackgroundTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BackgroundTask new];
    });
    return instance;
}

- (void)beginBackgroundTask {
    // 启动后台任务
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"后台程序");
        [app endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;

    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        while (true) {
            int remainingTime = app.backgroundTimeRemaining;
            if (remainingTime <= 5) {
                break;
            }
            NSLog(@"remainging background time: %d",remainingTime);
            [NSThread sleepForTimeInterval:1.0];
        }
        [app endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    });

    
}

@end
