//
//  AppDelegate.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import "AppDelegate.h"
#import <UserNotifications/UNNotificationContent.h>
#import <UserNotifications/UNNotification.h>
#import <UserNotifications/UNNotificationRequest.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.notification = nil;
    
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];

    [self registerForRemoteNotifications];
    
    return YES;
}

- (void)registerForRemoteNotifications
{
        // iOS 10 and greater
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
}

#pragma mark - UISceneSession lifecycle

/*
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
*/

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    self.notification = notification.request.content.userInfo;
    //[self processNotification:notification:1];
    
    completionHandler (UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    self.notification = response.notification.request.content.userInfo;
    //[self processNotification:response.notification:2];
    
    completionHandler ();
        
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *pushtoken = [self stringFromDeviceToken:deviceToken];
    //NSLog(pushtoken);
    
    NSError *error = nil;
    NSString *address = [NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/addtoken.php?token=%@", pushtoken];
    NSURL *url = [NSURL URLWithString:address];
    [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"pusherror=%@", [error description]);
}

- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

@end
