//
//  RegisteredBeaconsListViewController.m
//  Beaconing
//
//  Created by Marimuthu on 4/2/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "RegisteredBeaconsListViewController.h"
#import "BeaconObj.h"
#import "ConfigureBeaconViewController.h"

@interface RegisteredBeaconsListViewController()
@property(nonatomic,strong) NSMutableArray *registeredBeacons;
@property (weak, nonatomic) IBOutlet UITableView *beaconListTv;
- (IBAction)onTapBackBtn:(id)sender;

@end

@implementation RegisteredBeaconsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.registeredBeacons  = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    
    for (int idx =0; idx<5; idx++) {
        BeaconObj *tempObj = [[BeaconObj alloc] init];
        tempObj.Uuid = @"123";
        tempObj.majorId = @"123";
        tempObj.minorId = @"123";
        
        [self.registeredBeacons addObject:tempObj];
    }
    
    [self.beaconListTv reloadData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (IBAction)backClick:(id)sender {
    //[self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    [self.navigationController popViewControllerAnimated:YES];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    return [self.registeredBeacons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListCell"];
    
    BeaconObj *tempObj = [self.registeredBeacons objectAtIndex:[indexPath row]];
    
    
    UILabel *uuidLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *majorLbl = (UILabel*) [cell viewWithTag:200];
    UILabel *minorLbl = (UILabel*) [cell viewWithTag:300];
    
    NSString *uuidVal = [NSString stringWithFormat:@"UUID : %@",tempObj.Uuid];
    NSString *majorVal = [NSString stringWithFormat:@"Major : %@",tempObj.majorId];
    NSString *minorVal = [NSString stringWithFormat:@"Minor : %@",tempObj.minorId];
    
    
    [uuidLbl setText:uuidVal];
    
    [majorLbl setText:majorVal];
    [minorLbl setText:minorVal];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ConfigureBeaconViewController *_configBeacon = [mainStoryboard instantiateViewControllerWithIdentifier:@"ConfigureBeaconViewController"];
    [_configBeacon setSelectedBeacon:[self.registeredBeacons objectAtIndex:[indexPath row]]];
    [_configBeacon setLauncedFrom:EditBeaconFlow];
    
    [self.navigationController pushViewController:_configBeacon animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"I deleted a cell!");
    }
}

- (IBAction)onTapBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
