//
//  UserInfo.h
//  Beaconing
//
//  Created by Madhu Kunal on 04/04/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSUserDefaults {
    NSMutableArray                  *BeaconsArray;

}
@property(nonatomic,strong)NSMutableArray                  *BeaconsArray;
+(UserInfo*)SharedInfo;
@end
