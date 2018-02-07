//
//  AppDelegate.m
//  beacon_test
//
//  Created by JoeJoe on 2016/4/6.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<IIIBeaconDetectionDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     _notification = [IIINotification new] ;
    _iiibeacon = [IIIBeacon new];
    _detection = [IIIBeaconDetection new];
    
    [_iiibeacon get_beacons_withkey_securityWithServer:@"ideas.iiibeacon.net" key: @"e36a76430c205c03e6f3be43db917f7ea464cd4c" completion: ^(BeaconInfo *item , BOOL Sucess) {
        if (Sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _detection = [[IIIBeaconDetection alloc] initWithBeacon_data:item];
                _detection.delegate = self;
                [_detection Start];
            });
        }
    }];
    
    return YES;
}

//找到對應Beacon (required!!)
-(void)BeaconDetectd{
    if (_detection.ActiveBeaconList.count > 0) {
        for (ActiveBeacon* key in [self.detection ActiveBeaconList]) {
            NSLog(key.id);
                [_notification get_push_message_securityWithSecurity_server:@"ideas.iiibeacon.net" major: key.major.integerValue minor:key.minor.integerValue key:@"e36a76430c205c03e6f3be43db917f7ea464cd4c" completion:^(message *item, BOOL Sucess){
                    if (Sucess) {
                        //資料回傳成功
                        if (item.content.products.count > 0) {
                            NSLog(@"%@", [item.content.products[0] sellerName]);
                        }
                    }
                }];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end


