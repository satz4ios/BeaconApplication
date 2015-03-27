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

@interface LoginViewController () {
    UIStoryboard *_MainStoryboard;
    NSAttributedString *_underlineString;
    BOOL rememberCliked;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [_rememberMELbl setFont:[UIFont fontWithName:@"Raleway-Medium" size:15]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_forgotPwdBtn.titleLabel.text]
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                                          }]];
    [_forgotPwdBtn.titleLabel setAttributedText:attributedString];
    [_forgotPwdBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-Medium" size:15]];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginUser:(id)sender {
    _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AdminDashboardViewController *_adminUser = [_MainStoryboard instantiateViewControllerWithIdentifier:@"AdminController"];
    UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_adminUser];
    [self presentViewController:_navigationController animated:YES completion:Nil];
    return;
    
    
    NSString *_urlString = LoginUser;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:_urlString];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [NSMutableDictionary new];
    [_paramsDict setValue:self.emailIdTxtFld.text forKey:@"emailId"];
    [_paramsDict setValue:self.passWrdTxtFld.text forKey:@"password"];
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    
}
-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    NSDictionary *_dictArray;
    for (NSDictionary *_array in [dictionary objectForKey:@"userDetails"]) {
        _dictArray=_array;
    }
    NSString *_loginStatus = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"message"]];
    NSString *_userType = [NSString stringWithFormat:@"%@",[_dictArray objectForKey:@"userType"]];
    
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
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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
}
- (IBAction)rememberMeClick:(id)sender {
    
    if (rememberCliked) {
        rememberCliked=NO;
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeVsbImage"] forState:UIControlStateNormal];

    } else {
        rememberCliked=YES;
        [_checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"RememberMeActImage"] forState:UIControlStateNormal];
    }
    
}
@end
