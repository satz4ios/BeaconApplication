//
//  SearchBeaconViewController.h
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface SearchBeaconViewController : UIViewController<BeaconManagerDelegate,CBCentralManagerDelegate>

@end
