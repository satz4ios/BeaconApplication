//
//  AdminDashboardViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "AdminDashboardViewController.h"
#import "NearbyBeaconListViewController.h"
#import "RegisteredBeaconsListViewController.h"

@interface AdminDashboardViewController ()
- (IBAction)onTapAddBeacon:(id)sender;

- (IBAction)onTapConfigureBeaconBtn:(id)sender;

@end

@implementation AdminDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapAddBeacon:(id)sender {
    
    UIStoryboard *_mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NearbyBeaconListViewController *_searchBeaconVC = [_mainStoryboard instantiateViewControllerWithIdentifier:@"SearchBeaconViewController"];
    [self.navigationController pushViewController:_searchBeaconVC animated:YES];
    
}
- (IBAction)onTapConfigureBeaconBtn:(id)sender {
    
    UIStoryboard *_mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisteredBeaconsListViewController *_regBeaconList = [_mainStoryBoard instantiateViewControllerWithIdentifier:@"RegisteredBeaconsListViewController"];
    [self.navigationController pushViewController:_regBeaconList animated:YES];
    
}
@end
