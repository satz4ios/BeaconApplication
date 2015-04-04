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

@interface AdminDashboardViewController () {
    NSMutableArray *_listOfMenu;
    NSMutableArray *_listOfMenuImages;
}
- (IBAction)onTapAddBeacon:(id)sender;

- (IBAction)onTapConfigureBeaconBtn:(id)sender;

@end

@implementation AdminDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    _listOfMenu = [[NSMutableArray alloc]initWithObjects:@"Add Beacon",@"Configure Beacon",@"Create Coupon",@"Configure Coupon",@"Contact Us",@"Help",@"Settings", nil];
    _listOfMenuImages = [[NSMutableArray alloc]initWithObjects:@"add.-beacon.png",@"beacon-config.png",@"create-coupon.png",@"beacon-config.png",@"contact.png",@"help-us.png",@"beacon-config.png", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    return [_listOfMenu count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeScreenList"];
    UILabel *uuidLbl = (UILabel*) [cell viewWithTag:99];
    UIImageView *menuImgVw = (UIImageView*) [cell viewWithTag:88];
    uuidLbl.text=[_listOfMenu objectAtIndex:indexPath.row];
    menuImgVw.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_listOfMenuImages objectAtIndex:indexPath.row]]];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UIStoryboard *_mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        NearbyBeaconListViewController *_searchBeaconVC = [_mainStoryboard instantiateViewControllerWithIdentifier:@"SearchBeaconViewController"];
        [self.navigationController pushViewController:_searchBeaconVC animated:YES];

    } else if (indexPath.row==1) {
        UIStoryboard *_mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        RegisteredBeaconsListViewController *_regBeaconList = [_mainStoryBoard instantiateViewControllerWithIdentifier:@"RegisteredBeaconsListViewController"];
        [self.navigationController pushViewController:_regBeaconList animated:YES];

    }
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
    
    
}
- (IBAction)onTapConfigureBeaconBtn:(id)sender {
    
    
}
@end
