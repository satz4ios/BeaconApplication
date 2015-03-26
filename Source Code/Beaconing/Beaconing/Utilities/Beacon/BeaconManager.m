//
//  BeaconManager.m
//  IngVysyaBank
//
//  Created by Marimuthu on 1/27/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "BeaconManager.h"
#import "BeaconConstants.h"
#import "AppDelegate.h"

#define KONTACTBEACON_UUID @"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"
#define KONTACTBEACON_RGN_ID @"KONTACTBEACON_RGN_ID"

@interface BeaconManager()<CLLocationManagerDelegate>{
    
}

@property (strong, nonatomic) CLLocationManager *locaionMgr;
@property (strong, nonatomic) CLBeaconRegion *beaconRgn;
@property (strong,nonatomic) NSMutableArray *rgnsToMonitor;

@end

@implementation BeaconManager

-(void)initializeCoreLocationManager{
    
    self.locaionMgr = [[CLLocationManager alloc] init];
    
    [self.locaionMgr setDelegate:self];
    
    if ([self.locaionMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locaionMgr requestAlwaysAuthorization];
    }
    
    if ([self.locaionMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locaionMgr requestWhenInUseAuthorization];
    }
}


-(void)startMonitoringKontactBeacons{
    NSArray *uuids = @[KONTACTBEACON_UUID];
    
    NSArray *rgnIdentifiers = @[KONTACTBEACON_RGN_ID];
    
    self.rgnsToMonitor = [[NSMutableArray alloc] init];
    
    
    [uuids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[uuids objectAtIndex:idx]];
        
        CLBeaconRegion *beaconRgn = [[CLBeaconRegion alloc]
                                     initWithProximityUUID:uuid identifier:[rgnIdentifiers objectAtIndex:idx]];
        
        [self.rgnsToMonitor addObject:beaconRgn];
    }];
    
    [self startMonitoringRegions:self.rgnsToMonitor];

}

-(void)stopMonitoringAndRangingKontactBeacons{
    if ([self.rgnsToMonitor count]>0) {
        [self stopMonitoringRegions:self.rgnsToMonitor];
        [self stopRangingINGBeacon];
    }

}

-(void)stopRangingINGBeacon{

    [self.rgnsToMonitor enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self stopRangingRegion:obj];
    }];
}
-(void)startMonitoringRegions:(NSArray*)beaconRegions{
    
    for (CLBeaconRegion *rgn in beaconRegions) {
        
        [self.locaionMgr startMonitoringForRegion:rgn];
       // [self.locaionMgr requestStateForRegion:rgn];
        [rgn setNotifyEntryStateOnDisplay:YES];
    }
}


-(void)stopMonitoringRegions:(NSArray*)beaconRegions{
    
    for (CLBeaconRegion *rgn in beaconRegions) {
        [self.locaionMgr stopMonitoringForRegion:rgn];
    }
}

-(void)startRangingRegion:(CLRegion*)region{
    [self.locaionMgr startRangingBeaconsInRegion:(CLBeaconRegion*)region];
}

-(void)stopRangingRegion:(CLRegion*)region{
    [self.locaionMgr stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
}
#pragma mark CLLocationManager Delegates


- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
 //       [(AppDelegate*)[[UIApplication sharedApplication] delegate] extendBackgroundRunningTime];
    }
    
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    
    if ([_delegate respondsToSelector:@selector(beaconManager:didEnterRegion:)]) {
        [_delegate beaconManager:self didEnterRegion:region];
    }
    
    
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    
    if ([_delegate respondsToSelector:@selector(beaconManager:didExitRegion:)]) {
        [_delegate beaconManager:self didExitRegion:region];
    }
    
}


-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    if ([_delegate respondsToSelector:@selector(beaconManager:didRangeBeacons:inRegion:)]) {
        [_delegate beaconManager:self didRangeBeacons:beacons inRegion:region];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    if ([_delegate respondsToSelector:@selector(beaconManager:didDetermineState:forRegion:)]) {
        [_delegate beaconManager:self didDetermineState:state forRegion:region];
    }
    
    if (state == CLRegionStateInside){
        NSLog(@"is in target region");
        //[self.locaionMgr startRangingBeaconsInRegion:self.beaconRgn];
        [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
    else{
        NSLog(@"is out of target region");
    }
    
}

@end
