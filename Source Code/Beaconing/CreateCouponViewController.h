//
//  CreateCouponViewController.h
//  Beaconing
//
//  Created by Madhu.A on 20/04/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "ServiceCallAPI.h"
@interface CreateCouponViewController : UIViewController<UITextFieldDelegate,APIserviceProto,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *couponTaglineFld;
@property (weak, nonatomic) IBOutlet UITextView *couponDescripFld;
- (IBAction)couponDoneClick:(id)sender;

@end
