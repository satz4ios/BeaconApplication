//
//  CouponBeaconTaggingPopupViewController.h
//  Beaconing
//
//  Created by Marimuthu on 6/5/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconObj.h"


@interface CouponBeaconTaggingPopupViewController : UIViewController

@property (copy) void (^onSelectionOfRow)(CouponBeaconTaggingPopupViewController *alertVC, BeaconObj *selectedBeacon);

- (void)setOnSelectionOfRow:(void (^)(CouponBeaconTaggingPopupViewController *alertVC, BeaconObj *selectedBeacon))onSelectionOfRow;


@end

