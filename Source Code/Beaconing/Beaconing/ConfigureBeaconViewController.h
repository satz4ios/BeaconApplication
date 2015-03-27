//
//  ConfigureBeaconViewController.h
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCallAPI.h"
#import "BeaconObj.h"

@interface ConfigureBeaconViewController : UIViewController<APIserviceProto,UITextFieldDelegate>

@property (nonatomic,strong) BeaconObj *selectedBeacon;
@end
