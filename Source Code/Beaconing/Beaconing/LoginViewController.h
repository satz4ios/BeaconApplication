//
//  LoginViewController.h
//  Beaconing
//
//  Created by Madhu.A on 25/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ViewController.h"
#import "ServiceCallAPI.h"
#import <QuartzCore/QuartzCore.h>
@interface LoginViewController : UIViewController<APIserviceProto,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailIdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passWrdTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)forgotPwdClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *rememberMELbl;
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
- (IBAction)rememberMeClick:(id)sender;

@end
