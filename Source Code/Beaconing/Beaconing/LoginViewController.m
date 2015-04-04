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
    [_forgotPwdBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-Medium" size:14]];
    
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
                _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                AdminDashboardViewController *_adminUser = [_MainStoryboard instantiateViewControllerWithIdentifier:@"AdminController"];
                UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_adminUser];
                [self presentViewController:_navigationController animated:YES completion:Nil];
            }else {
                _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                NormalUserViewController *_normalUser = [_MainStoryboard instantiateViewControllerWithIdentifier:@"NormalUserController"];
                UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_normalUser];
                [self presentViewController:_navigationController animated:YES completion:Nil];
                
            }
            
        } else {
            
        }
    }
    
    
}


-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    activeField = textField;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    activeField = nil;
//}
//
//// Called when the UIKeyboardDidShowNotification is sent.
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
////    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
////    self._scrollView.contentInset = contentInsets;
////    self._scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        [self._embededView setFrame:activeField.frame];
//    }
//}
//
//// Called when the UIKeyboardWillHideNotification is sent
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self._embededView.contentInset = contentInsets;
//    self._embededView.scrollIndicatorInsets = contentInsets;
//}
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_emailIdTxtFld||textField==_passWrdTxtFld)
    {
        rememberCliked=NO;
         [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeVsbImage"] forState:UIControlStateNormal];
    }
}

- (IBAction)forgotPwdClick:(id)sender {
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
