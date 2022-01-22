//
//  AppDelegate.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property NSDictionary *notification;

@end

