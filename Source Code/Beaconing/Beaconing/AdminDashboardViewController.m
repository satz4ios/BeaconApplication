//
//  AdminDashboardViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "AdminDashboardViewController.h"
#import "SearchBeaconViewController.h"

@interface AdminDashboardViewController ()
- (IBAction)onTapAddBeacon:(id)sender;

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
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SearchBeaconViewController *_searchBeaconVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchBeaconViewController"];
    UINavigationController *_navigationController = [[UINavigationController alloc]initWithRootViewController:_searchBeaconVC];
    [self presentViewController:_navigationController animated:YES completion:Nil];
}
@end
