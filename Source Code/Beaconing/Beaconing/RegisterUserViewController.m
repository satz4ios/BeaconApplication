//
//  RegisterUserViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "ServiceCallAPI.h"
#import "Services.h"
@interface RegisterUserViewController () {
    int _userTypeValue;
}

@end

@implementation RegisterUserViewController
@synthesize segmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    NSString *_urlString = RegisterUser;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:_urlString];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [NSMutableDictionary new];
    [_paramsDict setValue:_fNameFld.text forKey:@"firstName"];
    [_paramsDict setValue:_lNameFld.text forKey:@"lastName"];
    [_paramsDict setValue:_emailId.text forKey:@"emailId"];
    [_paramsDict setValue:_passwrdFld.text forKey:@"password"];
    [_paramsDict setValue:@"26" forKey:@"age"];
    [_paramsDict setValue:[NSNumber numberWithInt:_userTypeValue] forKey:@"userType"];
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}

- (IBAction)userTypeSelection:(id)sender {
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        _userTypeValue=1;
        [UIView animateWithDuration:0.5 animations:^{
            _businesNameFld.hidden=NO;
            _contactFld.hidden=NO;
            _businesNameFld.alpha=0.5;
            _contactFld.alpha=0.5;

        } completion:^(BOOL finished) {
            _businesNameFld.alpha=1;
            _contactFld.alpha=1;

        }];
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        _userTypeValue=2;
        
        [UIView animateWithDuration:0.5 animations:^{
            _businesNameFld.alpha=0.5;
            _contactFld.alpha=0.5;
        } completion:^(BOOL finished) {
            _businesNameFld.alpha=0;
            _contactFld.alpha=0;
            _businesNameFld.hidden=YES;
            _contactFld.hidden=YES;

        }];
    }
}
-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    
    
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
