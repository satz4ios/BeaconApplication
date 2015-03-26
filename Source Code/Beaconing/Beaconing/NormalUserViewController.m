//
//  NormalUserViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 21/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "NormalUserViewController.h"

@interface NormalUserViewController ()

@end

@implementation NormalUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;

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

- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
@end
