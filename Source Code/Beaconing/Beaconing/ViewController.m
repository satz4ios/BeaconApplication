//
//  ViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ViewController.h"
#import "RegisterUserViewController.h"
@interface ViewController () {
    UIStoryboard *_MainStoryboard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUser:(id)sender {
    
}

- (IBAction)registerUser:(id)sender {
    _MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisterUserViewController *_register = [_MainStoryboard instantiateViewControllerWithIdentifier:@"RegisterController"];
    [self presentViewController:_register animated:YES completion:NULL];
}
@end
