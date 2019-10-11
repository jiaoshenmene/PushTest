//
//  PUserDefault.h
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PUserDefault : NSObject
+ (void)saveBackgroundEnterTimes:(int)times;
+ (int)getBackgroundEnterTimes;
@end

NS_ASSUME_NONNULL_END
