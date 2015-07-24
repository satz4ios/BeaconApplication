//
//  LoginViewController.m
//  Beaconing
//
//  Created by Madhu.A on 25/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterUserViewController.h"
#import "Services.h"
#import "AdminDashboardViewController.h"
#import "NormalUserViewController.h"
#import "MBProgressHUD.h"
#import "ForgotPasswordViewController.h"
#import "UIImageEffects.h"
#import "UserInfo.h"
@interface LoginViewController () {
    UIStoryboard *_MainStoryboard;
    NSAttributedString *_underlineString;
    BOOL rememberCliked;
    UITextField *activeField;
    MBProgressHUD *busyView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self LoadFonts];
//    [self registerForKeyboardNotifications];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"])
    {
        _emailIdTxtFld.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail"]];
        _passWrdTxtFld.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"]];
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeActImage"] forState:UIControlStateNormal];
    }
    else
    {
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeVsbImage"] forState:UIControlStateNormal];
    }
    
}

-(void)LoadFonts {
    [_emailIdTxtFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_passWrdTxtFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_emailIdTxtFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_passWrdTxtFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_emailIdTxtFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_passWrdTxtFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    _emailIdTxtFld.layer.cornerRadius=8.0;
    _passWrdTxtFld.layer.cornerRadius=8.0;
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"Raleway-SemiBold" size:22];
    [_rememberMELbl setFont:[UIFont fontWithName:@"Raleway-Medium" size:14]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_forgotPwdBtn.titleLabel.text]
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                                          }]];
    [_forgotPwdBtn.titleLabel setAttributedText:attributedString];
    [_forgotPwdBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:14]];
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginUser:(id)sender {
    
        busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    busyView.labelText = @"Logging In";
    busyView.dimBackground = YES;
    busyView.delegate = self;

    [_emailIdTxtFld resignFirstResponder];
    [_passWrdTxtFld resignFirstResponder];
    if (_emailIdTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"  message:@"Please enter your Username/Email"  delegate:nil cancelButtonTitle:@"OK"   otherButtonTitles:nil, nil];
        [alert show];
        [busyView hide:YES];
        return;
    }
    else if (_passWrdTxtFld.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"  message:@"Please enter your Password"  delegate:nil cancelButtonTitle:@"OK"   otherButtonTitles:nil, nil];
        [alert show];
        //        [self hideBusyView];
        [busyView hide:YES];

        return;
    }
    else
    {
        
        NSString *_urlString = LoginUser;
        ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:_urlString];
        _serviceAPI.apiDelegate=self;
        NSMutableDictionary *_paramsDict = [NSMutableDictionary new];
        [_paramsDict setValue:self.emailIdTxtFld.text forKey:@"emailId"];
        [_paramsDict setValue:self.passWrdTxtFld.text forKey:@"password"];
        [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    }
    
}
-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    NSDictionary *_dictArray;
    if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"400"]) {
        [busyView hide:YES];
        if ([[dictionary objectForKey:@"message"]isEqualToString:@"Emailid and Password Mismatch"]) {
            [[[UIAlertView alloc]initWithTitle:@"Login Error" message:@"Email ID and Password Mismatch" delegate:nil
                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            
        } else if ([[dictionary objectForKey:@"message"]isEqualToString:@"Please activate your account from your email id"]) {
            [[[UIAlertView alloc]initWithTitle:@"Validation Error" message:@"Please activate your account from your Email ID and try again " delegate:nil
                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        } 
    }else {
        for (NSDictionary *_array in [dictionary objectForKey:@"userDetails"]) {
            _dictArray=_array;
        }
        NSString *_loginStatus = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
        NSString *_userType = [NSString stringWithFormat:@"%@",[_dictArray objectForKey:@"userType"]];
        [busyView hide:YES];
        
        if ([_loginStatus isEqualToString:@"Successfully Logged in"]) {
            if ([_userType isEqualToString:@"1"]) {
                
                NSString *userId=[_dictArray objectForKey:@"userId"];
                NSString *userType=[_dictArray objectForKey:@"userType"];
                [[UserInfo SharedInfo]setObject:userId forKey:@"userId"];
                [[UserInfo SharedInfo]setObject:userType forKey:@"userType"];

                _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                AdminDashboardViewController *_adminUser = [_MainStoryboard instantiateViewControllerWithIdentifier:@"AdminController"];
                UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_adminUser];
                [self presentViewController:_navigationController animated:YES completion:Nil];
            }else {
                
                NSString *userId=[_dictArray objectForKey:@"userId"];
                NSString *userType=[_dictArray objectForKey:@"userType"];
                [[UserInfo SharedInfo]setObject:userId forKey:@"userId"];
                [[UserInfo SharedInfo]setObject:userType forKey:@"userType"];
                
                _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                NormalUserViewController *_normalUser = [_MainStoryboard instantiateViewControllerWithIdentifier:@"NormalUserController"];
                [_normalUser setLaunchFrom:loginScreen];
                UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_normalUser];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IS_CUSTOMER"];
                
                [self presentViewController:_navigationController animated:YES completion:Nil];
                
            }
            
        } else {
            
        }
    }
    
    
}


-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    [busyView hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:ErrorMessage.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert   show];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    if (textField==_emailIdTxtFld||textField==_passWrdTxtFld)
    {
        rememberCliked=NO;
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeVsbImage"] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self._embededView.contentInset = contentInsets;
    self._embededView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self._embededView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self._embededView.contentInset = contentInsets;
    self._embededView.scrollIndicatorInsets = contentInsets;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)forgotPwdClick:(id)sender {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissBlurredView:) name:@"BlurredView" object:nil];
    backgroundImage = [UIImageView new];
    backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundImage];
    [self showInView:self.view];
    UIStoryboard *_sb= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ForgotPasswordViewController *_forgotPasswordVC = [_sb instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    
    [self addChildViewController:_forgotPasswordVC];
    
    UIView *toView = _forgotPasswordVC.view;
    
    [self.view addSubview:toView];
    
    [_forgotPasswordVC.forgotPasswordBtn setHidden:YES];
    [_forgotPasswordVC.forgotPasswordTxtField setHidden:YES];
    [_forgotPasswordVC.infoLabl setHidden:YES];
    [_forgotPasswordVC.closeBtn setHidden:YES];
    
    _forgotPasswordVC.heightConstrain.constant = 0.0;
    
    // TODO: set initial layout constraints here
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         // TODO: set final layout constraints here
                         
                         _forgotPasswordVC.heightConstrain.constant = 150.0;
                         
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         [_forgotPasswordVC didMoveToParentViewController:self];
                         
                         [_forgotPasswordVC.forgotPasswordBtn setHidden:NO];
                         [_forgotPasswordVC.forgotPasswordTxtField setHidden:NO];
                         [_forgotPasswordVC.infoLabl setHidden:NO];
                         [_forgotPasswordVC.closeBtn setHidden:NO];
                     }];

}
-(void)dismissBlurredView:(NSNotification *)notif {
    
    [backgroundImage removeFromSuperview];
}
-(void)showInView:(UIView *)view {
    UIGraphicsBeginImageContext([view.layer frame].size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *inImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *outImage = [UIImageEffects imageByApplyingBlurToImage:inImage withRadius:5.0 tintColor:_blurTintColor saturationDeltaFactor:1.2 maskImage:nil];
    
    UIGraphicsBeginImageContext(outImage.size);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, outImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, outImage.size.width, outImage.size.height), outImage.CGImage);
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, outImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    CGRect circlePoint = (_clearArea);
    CGContextSetFillColorWithColor( UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor );
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextFillRect(UIGraphicsGetCurrentContext(), circlePoint);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    backgroundImage.image = finalImage;
    
}

- (IBAction)rememberMeClick:(id)sender {
    
    if (rememberCliked) {
        rememberCliked=NO;
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeVsbImage"] forState:UIControlStateNormal];

    } else {
        rememberCliked=YES;
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeActImage"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:_emailIdTxtFld.text forKey:@"userEmail"];
        [[NSUserDefaults standardUserDefaults]setObject:_passWrdTxtFld.text forKey:@"userPwd"];

    }
    
}
@end
