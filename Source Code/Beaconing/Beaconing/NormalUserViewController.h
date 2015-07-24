//
//  NormalUserViewController.h
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 21/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    localNotification,
    loginScreen
}LaunchFrom;

@interface NormalUserViewController : UIViewController

@property (nonatomic,strong)NSDictionary *notificationDict;
@property (nonatomic,assign) LaunchFrom launchFrom;
- (IBAction)backClick:(id)sender;

@end
