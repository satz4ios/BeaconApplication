//
//  ForgotPasswordViewController.h
//  PopUpViewDemo
//
//  Created by Marimuthu on 4/5/15.
//  Copyright (c) 2015 Marimuthu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCallAPI.h"
#import "MBProgressHUD.h"
@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate,APIserviceProto,MBProgressHUDDelegate,UIAlertViewDelegate> {
    UIImageView *backgroundImage;
    IBOutlet UIView *_passwordBGview;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrain;
@property (weak, nonatomic) IBOutlet UITextField *forgotPasswordTxtField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoLabl;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)onTapCloseBtn:(id)sender;
@end
