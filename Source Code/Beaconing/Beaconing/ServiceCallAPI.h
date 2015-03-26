//
//  ServiceCallAPI.h
//  Beaconing
//
//  Created by Madhu.A on 16/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//



#import <Foundation/Foundation.h>

@protocol APIserviceProto

-(void)recievedServiceCallData:(NSDictionary *)dictionary;
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage;
@end

@interface ServiceCallAPI : NSObject {
    
   __unsafe_unretained id<APIserviceProto>apiDelegate;
    NSString *_addressString;
    NSURL *_addressUrl;
}
@property(nonatomic,assign)id<APIserviceProto>apiDelegate;
-(id)initWithService:(NSString *)UrlString;
-(void)sendHttpRequestServiceWithParameters:(NSDictionary *)params;
@end
