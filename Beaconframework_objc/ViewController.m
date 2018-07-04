//
//  ViewController.m
//  Beaconframework_objc
//
//  Created by ccHsieh on 2018/2/7.
//  Copyright © 2018年 cchsieh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, IIIBeaconDetectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beaconInit];
    
    _beaconIdList = [[NSMutableArray alloc] init];
    _sellerNameList = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beaconInit{
    _notification = [IIINotification new] ;
    _iiibeacon = [IIIBeacon new];
    _detection = [IIIBeaconDetection new];
    
    [_iiibeacon get_beacons_withkey_securityWithServer:@"ideas.iiibeacon.net" key: @"YOUR_APP_KEY" completion: ^(BeaconInfo *item , BOOL Sucess) {
        if (Sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _detection = [[IIIBeaconDetection alloc] initWithBeacon_data:item];
                _detection.delegate = self;
                [_detection Start];
            });
        }
    }];
}

//找到對應Beacon (required!!)
- (void)BeaconDetectd{
    if (_detection.ActiveBeaconList.count > 0) {
        for (ActiveBeacon* key in [self.detection ActiveBeaconList]) {
            if ([self insertData:key.id] == true){
                [_beaconIdList addObject:key.id];
                [_notification get_push_message_securityWithSecurity_server:@"ideas.iiibeacon.net" major: key.major.integerValue minor:key.minor.integerValue key:@"YOUR_APP_KEY" completion:^(message *item, BOOL Sucess){
                    if (Sucess) {
                        //資料回傳成功
                        if (item.content.products.count > 0) {
                            NSLog(@"%@", [item.content.products[0] sellerName]);
                            [_sellerNameList addObject:[item.content.products[0] sellerName]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_tableView reloadData];
                            });
                        }
                    }
                }];
            }
        }
    }
}

- (BOOL)insertData:(NSString *)data {
    for (NSString *string in _beaconIdList){
        if (string == data){
            return false;
        }
    }
    return true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _beaconIdList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _beaconIdList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", _sellerNameList[indexPath.row]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Beacon List";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

@end
