//
//  CreateCouponViewController.m
//  Beaconing
//
//  Created by Madhu.A on 20/04/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "CreateCouponViewController.h"
#import "Services.h"
#import "UserInfo.h"
#import "CouponBeaconTaggingPopupViewController.h"


@interface CreateCouponViewController () {
    MBProgressHUD *busyView;
}

@end

@implementation CreateCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.couponDescripFld.layer.borderWidth = 1.0f;
    self.couponDescripFld.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)couponDoneClick:(id)sender {
    
    if (self.couponTaglineFld.text.length==0||self.couponDescripFld.text.length==0) {
       [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please provide the coupon detail and click done" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    } else {
        
        UIStoryboard *_sb= [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CouponBeaconTaggingPopupViewController *_taggingVC = [_sb instantiateViewControllerWithIdentifier:@"CouponBeaconTaggingPopupViewController"];
        
        [_taggingVC setOnSelectionOfRow:^(CouponBeaconTaggingPopupViewController *alertVC, BeaconObj *selectedBeacon) {
            NSLog(@"%@",selectedBeacon);
            
            [self makeServiceCallForTaggingBeacon:selectedBeacon];
        }];
        
        [self addChildViewController:_taggingVC];
        
        UIView *toView = _taggingVC.view;
        
        [self.view addSubview:toView];
        
        
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             
                             // TODO: set final layout constraints here
                             
                            // _forgotPasswordVC.heightConstrain.constant = 150.0;
                             
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {

                         }];
        
    }
}

-(void)makeServiceCallForTaggingBeacon:(BeaconObj*)beacon{
    
    
     busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     busyView.labelText = @"Please Wait..";
     busyView.dimBackground = YES;
     busyView.delegate = self;
     
     NSString *urlStr = CreateCoupon;
     ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
     _serviceAPI.apiDelegate=self;
     NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
     NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
     //        NSString *userType=[[UserInfo SharedInfo] objectForKey:@"userType"];
     [_paramsDict setValue:userId forKey:@"uuId"];
     [_paramsDict setValue:self.couponDescripFld.text forKey:@"couponDescription"];
     [_paramsDict setValue:self.couponTaglineFld.text forKey:@"couponTagline"];
     [_paramsDict setValue:[beacon majorId] forKey:@"majorValue"];
     [_paramsDict setValue:[beacon minorId] forKey:@"minorValue"];
     
     [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}

-(void)recievedServiceCallData:(NSDictionary *)dictionary {

    if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"400"]) {
        [busyView hide:YES];

        [[[UIAlertView alloc]initWithTitle:@"Error" message:[dictionary objectForKey:@"message"] delegate:nil
                             cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            
        
    }
    
    else {
        
        }
    
    
}


-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    
}


@end
