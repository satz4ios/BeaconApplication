//
//  ServiceCallAPI.m
//  Beaconing
//
//  Created by Madhu.A on 16/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ServiceCallAPI.h"
#import "AFNetworking.h"
@implementation ServiceCallAPI
@synthesize apiDelegate;


-(id)initWithService:(NSString *)UrlString {

    _addressString = UrlString;
    _addressUrl = [NSURL URLWithString:_addressString];
    return self;
}


-(void)sendHttpRequestServiceWithParameters:(NSDictionary *)params {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:_addressString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self.apiDelegate recievedServiceCallData:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 500) {
            NSLog(@"Something went wrong! %@", error);
            [self.apiDelegate recievedServiceCallWithError:error];
        } else if (operation.response.statusCode == 400) {
            [self.apiDelegate recievedServiceCallWithError:error];
            // the auth token we have is no longer valid, clear it
        } else if (operation.response.statusCode == -1005) {
            [self.apiDelegate recievedServiceCallWithError:error];
        }
    }];
}
@end
