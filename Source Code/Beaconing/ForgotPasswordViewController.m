//
//  ForgotPasswordViewController.m
//  PopUpViewDemo
//
//  Created by Marimuthu on 4/5/15.
//  Copyright (c) 2015 Marimuthu. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "UIImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "Services.h"
@interface ForgotPasswordViewController() {
    MBProgressHUD *busyView;

}


@end

@implementation ForgotPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _passwordBGview.layer.cornerRadius=6.0;
    _closeBtn.layer.cornerRadius=6.0;
    _forgotPasswordBtn.layer.cornerRadius=6.0;
    [_forgotPasswordTxtField setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTapCloseBtn:(id)sender {
    
    [self.forgotPasswordBtn setHidden:YES];
    [self.forgotPasswordTxtField setHidden:YES];
    [self.infoLabl setHidden:YES];
    [self.closeBtn setHidden:YES];
    
    self.heightConstrain.constant = 150.0;
    
    // TODO: set initial layout constraints here
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         // TODO: set final layout constraints here
                         
                         self.heightConstrain.constant = 0.0;
                         
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"BlurredView" object:nil];
                         
                     }];
}
- (IBAction)forgotPasswordSubmit:(id)sender {
    
    if (_forgotPasswordTxtField.text.length==0) {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your Email ID which you use for login" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    } else {
        
        busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        busyView.labelText = @"Please Wait..";
        busyView.dimBackground = YES;
        busyView.delegate = self;

        NSString *_urlString = forgotPassword;
        ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:_urlString];
        _serviceAPI.apiDelegate=self;
        NSMutableDictionary *_paramsDict = [NSMutableDictionary new];
        [_paramsDict setValue:self.forgotPasswordTxtField.text forKey:@"emailId"];
        [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];

    }
    
}
-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    [busyView hide:YES];
    if ([[dictionary objectForKey:@"errorCode"] isEqualToString:@"200" ]) {
        UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your password has been sent to your Email ID" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        _alert.tag=987;
        [_alert show];

    } else {
        UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Given Email Id doesn't exist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        _alert.tag=988;
        [_alert show];

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==987) {
        [self onTapCloseBtn:nil];
    }
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    [busyView hide:YES];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
