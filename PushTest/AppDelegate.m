//
//  AppDelegate.m
//  PushTest
//
//  Created by 杜甲 on 2019/10/11.
//  Copyright © 2019 杜甲. All rights reserved.
//

#import "AppDelegate.h"
#import "PUserDefault.h"

#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <PushKit/PushKit.h>

#import <GTSDK/GeTuiSdk.h>

#import "BackgroundTask.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, GeTuiSdkDelegate, PKPushRegistryDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    //
//    [self registerAPN];
    [self voipRegistration];
    return YES;
}


#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)registerAPN {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                              }
                          }];
    [UIApplication sharedApplication].delegate = self;
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {

    NSString *token = [[[[NSString stringWithFormat:@"%@", deviceToken] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"token = %@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#pragma mark - GeTuiSdkDelegate

/// [ GTSDK回调 ] SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [ GTSDK ]：个推SDK已注册，返回clientId
    NSLog(@"[ TestDemo ] [GTSdk RegisterClient]:%@", clientId);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"willPresentNotification");
}
// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse");
}

// The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    NSLog(@"openSettingsForNotification");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    int times = [PUserDefault getBackgroundEnterTimes];
    times++;
    [PUserDefault saveBackgroundEnterTimes:times];
    if (times >= 3) {
        [self alertUserEnablePush];
    }

    [[BackgroundTask sharedInstance] beginBackgroundTask];
}

- (void)alertUserEnablePush {
    //    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"test" message:@"请打开push权限" preferredStyle:UIAlertControllerStyleAlert];
    //    [alert showViewController:self.window.rootViewController sender:self];
    //
    //    UIAlertAction *btn2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        NSLog(@"打开设置页面");
    //    }];
    //
    //    UIAlertAction *btn1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //
    //    [alert addAction:btn1];
    //    [alert addAction:btn2];
    //    [self.window.rootViewController presentViewController:alert animated:YES completion:^{
    //
    //    }];
}

- (void)pushtest {
}
- (void)voipRegistration {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:mainQueue];
    voipRegistry.delegate = self;
    // Set the push type to VoIP
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
//    UNAuthorizationOptions ntype = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
    
}

- (void)pushRegistry:(nonnull PKPushRegistry *)registry
    didUpdatePushCredentials:(nonnull PKPushCredentials *)pushCredentials
                     forType:(nonnull PKPushType)type {
    
    NSString *token = [[[[NSString stringWithFormat:@"%@", pushCredentials.token] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSLog(@"token = %@", token);
    // [ 测试代码 ] 日志打印DeviceToken
    NSLog(@"[ TestDemo ] [ VoipToken(NSData) ]: %@\n\n", token);
    
    //向个推服务器注册 VoipToken 为了方便开发者，建议使用新方法
    [GeTuiSdk registerVoipTokenCredentials:pushCredentials.token];
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload
             forType:(PKPushType)type {
    NSLog(@"dictionaryPayload = %@",payload.dictionaryPayload);
    
    // 收到voip push，执行后台逻辑，并生成local push。
      
}


@end
