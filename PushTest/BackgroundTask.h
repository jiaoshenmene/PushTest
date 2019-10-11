//
//  BackgroundTask.h
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundTask : NSObject
+ (instancetype)sharedInstance;
- (void)beginBackgroundTask;
@end

NS_ASSUME_NONNULL_END
