//
//  NormalUserViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 21/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "NormalUserViewController.h"
#import "CouponObj.h"
#import "BeaconManager.h"
#import "ServiceCallAPI.h"
#import "Services.h"
#import "UserInfo.h"
#import "BeaconConstants.h"
#import "AppDelegate.h"

@interface NormalUserViewController () <BeaconManagerDelegate,APIserviceProto>

@property (weak, nonatomic) IBOutlet UITableView *receivedCouponsList;
@property (strong, nonatomic) NSMutableArray *receivedDeals;
@property(nonatomic,strong) BeaconManager *beaconMgr;

@end

@implementation NormalUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    _receivedDeals = [[NSMutableArray alloc] init];
    
    [self doInitializationForBeaconFeature];
    [_beaconMgr startMonitoringKontactBeacons];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (int idx = 0; idx <10; idx++) {
        CouponObj *tempObj = [[CouponObj alloc] init];
        [tempObj setCouponTitle:[NSString stringWithFormat:@"Coupon Name %d",idx]];
        [tempObj setCouponDesc:[NSString stringWithFormat:@"The interest rate stated on bond when it's issued.The coupon is paid semiannually"]];
   //     [_receivedDeals addObject:tempObj];
        
    }
    
    if (_launchFrom == localNotification) {
        
        NSDictionary *usrDict = _notificationDict;
        
        CouponObj *tempObj = [[CouponObj alloc] init];
        [tempObj setCouponId:usrDict[@"couponId"]];
        [tempObj setCouponDesc:usrDict[@"couponDescription"]];
        [tempObj setCouponTitle:usrDict[@"couponTagline"]];
        [tempObj setBeaconMajorId:usrDict[@"majorValue"]];
        [tempObj setBeaconMinorId:usrDict[@"minorValue"]];
        [_receivedDeals addObject:tempObj];

    }
    [_receivedCouponsList reloadData];
    
    [_receivedCouponsList setBackgroundView:nil];
    [_receivedCouponsList setBackgroundColor:[UIColor clearColor]];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.receivedDeals count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponListCell"];
    
    
    CouponObj *tempObj = [_receivedDeals objectAtIndex:[indexPath   row]];
    
    UILabel *couponTitleLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *couponDescriptionLbl = (UILabel*) [cell viewWithTag:200];
    
    
    
    NSString *couponTitleText = @"Coupon Title :  ";
    NSMutableAttributedString *couponTitleAttString=[[NSMutableAttributedString alloc] initWithString:couponTitleText];
    NSInteger _stringLength=[couponTitleText length];
  //  [couponTitleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
    NSString *couponTitleVal = [NSString stringWithFormat:@"%@",tempObj.couponTitle];
    NSMutableAttributedString *couponTitleAttString1=[[NSMutableAttributedString alloc] initWithString:couponTitleVal];
    _stringLength=[couponTitleVal length];
    
    [couponTitleAttString appendAttributedString:couponTitleAttString1];
    
    [couponTitleLbl setAttributedText:couponTitleAttString];
    
    
    NSString *couponDescText = @"Coupon Title :  ";
    NSMutableAttributedString *couponDescAttString=[[NSMutableAttributedString alloc] initWithString:couponDescText];
    _stringLength=[couponDescText length];
    //[couponDescAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
    NSString *couponDescVal = [NSString stringWithFormat:@"%@",tempObj.couponDesc];
    NSMutableAttributedString *couponDescAttString1=[[NSMutableAttributedString alloc] initWithString:couponDescVal];
    _stringLength=[couponDescVal length];
    
    [couponDescAttString appendAttributedString:couponDescAttString1];
    
    [couponDescriptionLbl setAttributedText:couponDescAttString];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)doInitializationForBeaconFeature{
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        NSLog(@"Beacon monitoring is not available");
        return;
    }
    
    self.beaconMgr = [[BeaconManager alloc] init];
    [self.beaconMgr initializeCoreLocationManager];
    [self.beaconMgr setDelegate:self];
    
}

#pragma mark Beacon Manager delegate methods

-(void)beaconManager:(BeaconManager*)beaconMgr didEnterRegion:(CLRegion*)region{
    
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
    
    NSString *messgae = [NSString stringWithFormat:@"You have entered to %@ region with uuid -> %@",beaconRegion.identifier,beaconRegion.proximityUUID.UUIDString];
    
    NSLog(@"%@",messgae);
    
}

-(void)beaconManager:(BeaconManager*)beaconMgr didExitRegion:(CLRegion*)region{
    
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
    
    NSString *messgae = [NSString stringWithFormat:@"You have exited to %@ region with uuid -> %@",beaconRegion.identifier,beaconRegion.proximityUUID.UUIDString];
    
    NSLog(@"%@",messgae);
    
}
-(void)beaconManager:(BeaconManager*)beaconMgr
     didRangeBeacons:(NSArray*)beacons
            inRegion:(CLBeaconRegion*)region{
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
       AppDelegate *appDelegate =  (AppDelegate *) [[UIApplication sharedApplication] delegate]   ;
        [appDelegate    extendBackgroundRunningTime];
    }
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    
    NSLog(@"UUID ==> ; %@ ",uuid);
    
    if ([[[foundBeacon proximityUUID] UUIDString] isEqualToString:KONTACTBEACON_UUID]  ) {
        
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion*)foundBeacon;
        
        NSString *messgae = [NSString stringWithFormat:@"You are in the range of beacon region with uuid -> %@, major -> %ld, minor -> %ld",beaconRegion.proximityUUID.UUIDString,(long)[beaconRegion.major integerValue], (long)[beaconRegion.minor integerValue]];
        
        NSLog(@"%@",messgae);
        
        [self createPlist];
        
        NSString* plistPath = [self getPlistPath];
        
        
        NSMutableArray *contentArray = [[NSArray arrayWithContentsOfFile:plistPath] mutableCopy];
        
        __block BOOL _alreadyPresent = NO;
        
        [contentArray enumerateObjectsUsingBlock:^(NSDictionary *individualBeacon, NSUInteger idx, BOOL *stop) {
            
            if ([individualBeacon[@"Major"] isEqualToString:[beaconRegion.major stringValue] ]
                && [individualBeacon[@"Minor"] isEqualToString: [beaconRegion.minor stringValue]] ) {
                _alreadyPresent = YES;
                *stop = YES;
            }
        }];
        
        _alreadyPresent = NO;
        
        if (!_alreadyPresent) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSDictionary *beaconDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects:[beaconRegion.major stringValue],[beaconRegion.minor stringValue], nil] forKeys:[NSArray arrayWithObjects:@"Major",@"Minor", nil]];
                [contentArray addObject:beaconDict];
                
                
                [contentArray writeToFile:plistPath atomically:YES];
                [self sendWSRequestToFetchCouponDataForBeacon:foundBeacon];
                
                
                
            });
        }
        
        
    }
    
}
- (void)beaconManager:(BeaconManager *)beaconMgr didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}


-(void)intimateUserWithMsg:(NSString*)msg andUserInfo:(NSDictionary*)userInfo{
    
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        UILocalNotification *notify = [[UILocalNotification alloc] init];
        [notify setAlertBody:msg];
        [notify setUserInfo:userInfo];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notify];
    }
    else{
        [_receivedCouponsList reloadData];
        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@""
//                              message:msg
//                              delegate:nil
//                              cancelButtonTitle:@"Ok"
//                              otherButtonTitles:nil, nil];
//        [alert  show];
    }
    
}


#pragma mark Beacon Feature Service

-(void)sendWSRequestToFetchCouponDataForBeacon:(CLBeacon*)beacon
{
    
    
    NSString *urlStr = GetConsumerCoupon;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
    // http://gotocontactsonline.com/beaconapp/consumerservice.php?userId=1&userType=1&minorValue=23
    NSString *userType=[[UserInfo SharedInfo]objectForKey:@"userType"];
    [_paramsDict setValue:userId forKey:@"userId"];
    [_paramsDict setValue:userType forKey:@"userType"];
    [_paramsDict setValue:[[beacon minor] stringValue] forKey:@"minorValue"];
    //[_paramsDict setValue:@"123" forKey:@"minorValue"];
    
    
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    
}




-(NSString*)getPlistPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"DetectedBeaconList.plist"];
    
    return path;
}
-(void)createPlist{
    //Get the documents directory path
    
    NSString *path = [self getPlistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
    }
    
    NSMutableArray *data;
    
    if ([fileManager fileExistsAtPath: path]) {
        
        data = [[NSMutableArray alloc] initWithContentsOfFile: path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableArray alloc] init];
    }
    
    //To insert the data into the plist
    [data writeToFile:path atomically:YES];
    
    
}


#pragma mark API protocols

-(void)recievedServiceCallData:(NSDictionary *)dictionary{
   
    
    if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"200"]) {
        
        NSDictionary *usrDict = [dictionary[@"userDetails"] firstObject];
        
        CouponObj *tempObj = [[CouponObj alloc] init];
        [tempObj setCouponId:usrDict[@"couponId"]];
        [tempObj setCouponDesc:usrDict[@"couponDescription"]];
        [tempObj setCouponTitle:usrDict[@"couponTagline"]];
        [tempObj setBeaconMajorId:usrDict[@"majorValue"]];
        [tempObj setBeaconMinorId:usrDict[@"minorValue"]];
        [_receivedDeals addObject:tempObj];
        
       [self intimateUserWithMsg:@""andUserInfo:usrDict];
       
    }
            
    
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
}


-(void)dealloc{
    NSLog(@"dealloc");
}

@end
