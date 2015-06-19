//
//  CouponObj.h
//  Beaconing
//
//  Created by Marimuthu on 6/6/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponObj : NSObject
@property(nonatomic,strong) NSString *couponTitle;
@property(nonatomic,strong) NSString *couponDesc;
@property(nonatomic,strong) NSString *couponId;
@property(nonatomic,strong) NSString *beaconMajorId;
@property(nonatomic,strong) NSString *beaconMinorId;
@end
