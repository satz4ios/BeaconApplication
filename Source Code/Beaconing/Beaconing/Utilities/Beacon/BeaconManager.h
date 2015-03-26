//
//  BeaconManager.h
//  IngVysyaBank
//
//  Created by Marimuthu on 1/27/15.
//  Copyright (c) 2015 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@class BeaconManager;

@protocol BeaconManagerDelegate<NSObject>

-(void)beaconManager:(BeaconManager*)beaconMgr didEnterRegion:(CLRegion*)region;

-(void)beaconManager:(BeaconManager*)beaconMgr didExitRegion:(CLRegion*)region;
-(void)beaconManager:(BeaconManager*)beaconMgr
      didRangeBeacons:(NSArray*)beacons
             inRegion:(CLBeaconRegion*)region;
- (void)beaconManager:(BeaconManager *)beaconMgr didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;

@end


@interface BeaconManager : NSObject

@property (nonatomic, unsafe_unretained) id<BeaconManagerDelegate> delegate;


-(void)initializeCoreLocationManager;
-(void)startMonitoringRegions:(NSArray*)beaconRegions;
-(void)startRangingRegion:(CLRegion*)region;
-(void)stopMonitoringRegions:(NSArray*)beaconRegions;
-(void)stopRangingRegion:(CLRegion*)region;
-(void)startMonitoringKontactBeacons;
-(void)stopMonitoringAndRangingKontactBeacons;


@end


