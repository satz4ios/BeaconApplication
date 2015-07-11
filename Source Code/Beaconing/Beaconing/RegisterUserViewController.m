//
//  RegisterUserViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//
#define ACCEPTABLE_CHARECTERS2 @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_.@-"

#import "RegisterUserViewController.h"
#import "ServiceCallAPI.h"
#import "Services.h"
#import "UICustomActionSheet.h"
#import "MBProgressHUD.h"
@interface RegisterUserViewController () {
    int _userTypeValue;
    BOOL keyboardIsShown;
    UITextField *activeField;
    NSString *_passwordString;
    MBProgressHUD *busyView;

}

@end

@implementation RegisterUserViewController
@synthesize segmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    __scrollView.contentSize=CGSizeMake(0, 900);
    [self loadFonts];
    [self registerForKeyboardNotifications];
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)

}
-(void)loadFonts {
    
    [_userTypeFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_userNameFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_emailId setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_passwrdFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_cPasswrdFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_businesNameFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_contactFld setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];

    [_userNameFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_userNameFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_emailId setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_emailId setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_passwrdFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_passwrdFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_cPasswrdFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_cPasswrdFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_userTypeFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_userTypeFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_businesNameFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_businesNameFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_contactFld setFont:[UIFont fontWithName:@"Raleway-Medium" size:18] ];
    [_contactFld setValue:[UIFont fontWithName:@"Raleway-Medium" size: 18] forKeyPath:@"_placeholderLabel.font"];
    [_registerButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-Medium" size:22]];

    
}
-(void)resignTextFields {
    
    [_userTypeFld resignFirstResponder];
    [_emailId resignFirstResponder];
    [_passwrdFld resignFirstResponder];
    [_contactFld resignFirstResponder];
    [_cPasswrdFld resignFirstResponder];
    [_businesNameFld resignFirstResponder];
    

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
    self._scrollView.contentInset = contentInsets;
    self._scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self._scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self._scrollView.contentInset = contentInsets;
    self._scrollView.scrollIndicatorInsets = contentInsets;
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerUser:(id)sender {
    busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    busyView.labelText = @"Registering...";
    busyView.dimBackground = YES;
    busyView.delegate = self;
    
    
    if ([_userNameFld.text length]<3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username should be at least 3 characters long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [busyView hide:YES];
        return ;
    }
    if (![self isEmailIDValid:_emailId.text]) {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Enter valid E-mail" delegate:self
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginalert show];
        [busyView hide:YES];
        return ;
    }
    else if (_passwrdFld.text.length==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Password is mandatory"  delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
        [alert show];
        [busyView hide:YES];
        return ;
    }
    else if ([_passwrdFld.text length]<8) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Password should be at least 8 characters long"   delegate:self cancelButtonTitle: @"OK"  otherButtonTitles:nil, nil];
        [alert show];
        [busyView hide:YES];
        return ;
    }
    else  if (_cPasswrdFld.text.length==0) {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message: @"Please confirm your password"   delegate:self
                                                   cancelButtonTitle: @"OK"  otherButtonTitles:nil];
        [loginalert show];
        [busyView hide:YES];
        return ;
    }
    else if (![_cPasswrdFld.text isEqualToString:_passwordString]) {
        //Confirm Password is not matching
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message: @"Password does not match the confirm password"   delegate:self
                                                   cancelButtonTitle: @"OK"  otherButtonTitles:nil];
        [loginalert show];
        [busyView hide:YES];
        return ;
    }
    else {
        
        NSString *_urlString = RegisterUser;
        ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:_urlString];
        _serviceAPI.apiDelegate=self;
        NSMutableDictionary *_paramsDict = [NSMutableDictionary new];
        [_paramsDict setValue:_userNameFld.text forKey:@"firstName"];
        //    [_paramsDict setValue:_lNameFld.text forKey:@"lastName"];
        [_paramsDict setValue:_emailId.text forKey:@"emailId"];
        [_paramsDict setValue:_passwrdFld.text forKey:@"password"];
        [_paramsDict setValue:@"26" forKey:@"age"];
        if (_userTypeValue==1) {
            _userTypeValue=1;
            [_paramsDict setValue:_businesNameFld.text forKey:@"businessName"];
            [_paramsDict setValue:_contactFld.text forKey:@"contactNumber"];
        }
        [_paramsDict setValue:[NSNumber numberWithInt:_userTypeValue] forKey:@"userType"];
        [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    }
}


-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"400"]) {
        [busyView hide:YES];

        if ([[dictionary objectForKey:@"message"]isEqualToString:@"User Already Exists"]) {
            [[[UIAlertView alloc]initWithTitle:@"User Error" message:@"User with same Email Id already exists. Please use alternative Email ID" delegate:nil
                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else {
        [busyView hide:YES];
        UIAlertView *_alertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Successfully Registered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        _alertView.tag=125;
        [_alertView show];
    }
}
-(IBAction)ShowUserTypeActionSheet:(id)sender {
    
    UICustomActionSheet* actionSheet = [[UICustomActionSheet alloc] initWithTitle:@"Choose your Type" delegate:nil buttonTitles:@[@"Cancel",@"Customer",@"Bussiness Owner",]];
    actionSheet.delegate=self;
    [actionSheet setButtonColors:@[[UIColor redColor]]];
    [actionSheet setBackgroundColor:[UIColor clearColor]];
    [actionSheet setTintColor:[UIColor lightGrayColor]];
    [actionSheet setSubtitle:@"Which user are you?"];
    [actionSheet setSubtitleColor:[UIColor whiteColor]];
    [actionSheet showInView:self.view];
}
-(void)customActionSheet:(UICustomActionSheet *)customActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self resignTextFields];
    if (buttonIndex == 1) {
        // Selected User consumer //
        _userTypeValue=2;
        _userTypeFld.text=@"   Customer";
        [_businesNameFld setText:nil];
        [_contactFld setText:nil];
        [UIView animateWithDuration:0.5 animations:^{
//            _businesNameFld.alpha=0.5;
//            _contactFld.alpha=0.5;
            __verticalConstraintBtn.constant=17;

        } completion:^(BOOL finished) {
            _businesNameFld.alpha=0;
            _contactFld.alpha=0;
            _businesNameFld.hidden=YES;
            _contactFld.hidden=YES;
            
        }];
    } else if (buttonIndex == 2) {
        // Selected User Bussiness //
        _userTypeValue=1;
        _userTypeFld.text=@"   Bussiness Owner";
        [UIView animateWithDuration:0.3 animations:^{
            _businesNameFld.hidden=NO;
            _contactFld.hidden=NO;
            _businesNameFld.alpha=0.5;
            _contactFld.alpha=0.5;
            __verticalConstraintBtn.constant=145;
        } completion:^(BOOL finished) {
            _businesNameFld.alpha=1;
            _contactFld.alpha=1;
            
        }];
    } else {
        //User Cancelled Action Sheet
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==125) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_userNameFld)
    {
        NSInteger insertDelta = string.length - range.length;
        if (_userNameFld.text.length + insertDelta > 15  && range.length == 0  )
        {
            return NO;
        }
        else
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS2] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
            return YES;
        }
    }
    if (textField==_passwrdFld)
    {
        NSInteger insertDelta = string.length - range.length;
        if (_passwrdFld.text.length+insertDelta >=15)
        {
            return NO;
        }
        else
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS2] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
            return YES;
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField==_passwrdFld)
    {
        _passwordString = [NSString stringWithFormat:@"%@",_passwrdFld.text];
    }
    if (textField==_userNameFld)
    {
        if ([textField.text length]<3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username should be at least 3 characters long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return YES;
        }
        return YES;
        
    }
    if(textField == _emailId)
    {
        if (![self isEmailIDValid:_emailId.text])
        {
            UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Enter valid E-mail" delegate:self
                                                       cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginalert show];
            return YES;
        }
        
    }
    if (textField == _passwrdFld)
    {
        if (textField.text.length==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Password is mandatory"  delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil, nil];
            [alert show];
            
            return YES;
            
        }
        else if ([textField.text length]<8)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"   message:@"Password should be at least 8 characters long"   delegate:self cancelButtonTitle: @"OK"  otherButtonTitles:nil, nil];
            [alert show];
            
            return YES;
            
        }
        else
        {
            _passwordString= [NSString stringWithFormat:@"%@",_passwrdFld.text];
            //NSString  *_ConfrimPWDString= [NSString stringWithFormat:@"%@",confirmPwd.text];
            //mandatory7.hidden=YES;
            return YES;
        }
    }
    
    if (textField==_cPasswrdFld)
    {
        if (_cPasswrdFld.text.length==0)
        {
            UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message: @"Please confirm your password"   delegate:self
                                                       cancelButtonTitle: @"OK"  otherButtonTitles:nil];
            [loginalert show];
            return YES;
        }
        else if (![_cPasswrdFld.text isEqualToString:_passwordString])
        {
            
            //Confirm Password is not matching
            UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Error"   message: @"Password does not match the confirm password"   delegate:self
                                                       cancelButtonTitle: @"OK"  otherButtonTitles:nil];
            [loginalert show];
            return YES;
            
            
        }
    }
    
    
    return YES;
}
-(BOOL)isEmailIDValid:(NSString *)_emailId
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    if (([emailTest evaluateWithObject:_emailId] != YES))
    {
        return NO;
    }
    else
        return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
