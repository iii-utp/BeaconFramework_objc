//
//  ViewController.h
//  Beaconframework_objc
//
//  Created by ccHsieh on 2018/2/7.
//  Copyright © 2018年 cchsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BeaconFramework/BeaconFramework.h>


@interface ViewController : UIViewController
@property (nonatomic, strong) IIINotification *notification;
@property (nonatomic, strong) IIIBeacon *iiibeacon;
@property (nonatomic, strong) BeaconInfo *beacon_info;
@property (nonatomic, strong) IIIBeaconDetection *detection;
@property (nonatomic, strong) NSMutableArray *beaconIdList;
@property (nonatomic, strong) NSMutableArray *sellerNameList;
@property (nonatomic, strong) UITableView *tableView;

@end

