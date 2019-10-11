//
//  ViewController.m
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()<UNUserNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectAppEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectAppEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)detectAppEnterBackground {
    NSLog(@"弹出本地推送");
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body"
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:3 repeats:NO];

    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond" content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
    
}

- (void)detectAppEnterForeground {
    
}


@end
