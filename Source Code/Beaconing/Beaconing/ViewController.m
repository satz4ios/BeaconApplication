//
//  ViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ViewController.h"
#import "RegisterUserViewController.h"
#import "Services.h"
#import "AdminDashboardViewController.h"
#import "NormalUserViewController.h"
@interface ViewController () {
    UIStoryboard *_MainStoryboard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)loginClick:(id)sender {
    ViewController *_logincontroller = [_MainStoryboard instantiateViewControllerWithIdentifier:@"loginController"];
    [self presentViewController:_logincontroller animated:YES completion:Nil];
}

- (IBAction)registerClick:(id)sender {
    RegisterUserViewController *_register = [_MainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
    [self presentViewController:_register animated:YES completion:NULL];
}
@end
