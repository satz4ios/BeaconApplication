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
@interface ForgotPasswordViewController()


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
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
