//
//  AppDelegate.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconManager.h"
#import "BeaconConstants.h"
#import "ServiceCallAPI.h"
#import "Services.h"
#import "NormalUserViewController.h"
#import "UserInfo.h"


@interface AppDelegate ()<BeaconManagerDelegate,APIserviceProto>

@property(nonatomic,strong) BeaconManager *beaconMgr;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    


    
    [self doInitializationForBeaconFeature];

    sleep(5);

    //dummy testing
//        CLBeacon *beacon = [[CLBeacon alloc] init];
//    [self sendWSRequestToFetchCouponDataForBeacon:beacon];

    
    /*UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert |UIUserNotificationTypeBadge;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    [notify setAlertBody:@"test"];
    notify.fireDate = [[NSDate alloc]initWithTimeInterval:60 sinceDate:[NSDate date]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    
    */
    
    
    
    // If application is launched due to  notification,present another view controller.
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification)
    {
        
        [self launchViewControllerForNotification];


    }
    
    return YES;
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [self launchViewControllerForNotification];
}

-(void)launchViewControllerForNotification{
    UIStoryboard *mainStoryboard = [UIStoryboard    storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NormalUserViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NormalUserViewController"];
    
    [self.window.rootViewController presentViewController:viewController animated:YES completion:NULL];
}
#pragma mark Background task
- (void)extendBackgroundRunningTime {
    if (_backgroundTask != UIBackgroundTaskInvalid) {
        // if we are in here, that means the background task is already running.
        // don't restart it.
        return;
    }
    NSLog(@"Attempting to extend background running time");
    
    __block Boolean self_terminate = YES;
    
    _backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"DummyTask" expirationHandler:^{
        NSLog(@"Background task expired by iOS");
        if (self_terminate) {
            [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
            _backgroundTask = UIBackgroundTaskInvalid;
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Background task started");
        
        while (true) {
            NSLog(@"background time remaining: %8.2f", [UIApplication sharedApplication].backgroundTimeRemaining);
            [NSThread sleepForTimeInterval:1];
        }
        
    });
}

- (void)endBackgroundTask {
    if (_backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
    }
    _backgroundTask = UIBackgroundTaskInvalid;
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
            
            if (individualBeacon[@"Major"] == [beaconRegion.major stringValue]
            && individualBeacon[@"Minor"] == [beaconRegion.minor stringValue] ) {
                _alreadyPresent = YES;
                *stop = YES;
            }
        }];
        
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
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil];
        [alert  show];
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
    //[_paramsDict setValue:[[beacon minor] stringValue] forKey:@"minorValue"];
    [_paramsDict setValue:@"123" forKey:@"minorValue"];
    
    
    
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
    
    
    [self intimateUserWithMsg:@""andUserInfo:@{}];
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
}


@end
