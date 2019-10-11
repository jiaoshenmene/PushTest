//
//  PUserDefault.m
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "PUserDefault.h"

#define PUserDefault_Key_BackgroundEnterTimes @"PUserDefault_Key_BackgroundEnterTimes"

@implementation PUserDefault

+ (void)saveBackgroundEnterTimes:(int)times
{
    [[NSUserDefaults standardUserDefaults] setInteger:times forKey:PUserDefault_Key_BackgroundEnterTimes];
}

+ (int)getBackgroundEnterTimes
{
    int times = 0;
    times = (int)[[NSUserDefaults standardUserDefaults] integerForKey:PUserDefault_Key_BackgroundEnterTimes];
    return times;
    
}

@end
