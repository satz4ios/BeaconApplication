//
//  UserInfo.m
//  Beaconing
//
//  Created by Madhu Kunal on 04/04/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize BeaconsArray;
static UserInfo* _sharedInformation= nil;

+(UserInfo*)SharedInfo {
    
    @synchronized([UserInfo class])
    {
        if (!_sharedInformation)
            [[self alloc] init];
        
        return _sharedInformation;
    }
    
    return nil;
}
+(id)alloc {
    @synchronized([UserInfo class]) {
        NSAssert(_sharedInformation == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInformation = [super alloc];
        return _sharedInformation;
    }
    
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        BeaconsArray=[[NSMutableArray alloc]init];
        
    }
    
    return self;
}

@end
