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
#import "UserInfo.h"
#import "ServiceCallAPI.h"
#import "Services.h"
@interface RegisteredBeaconsListViewController() {
    MBProgressHUD *busyView;
}
@property(nonatomic,strong) NSMutableArray *registeredBeacons;
@property (weak, nonatomic) IBOutlet UITableView *beaconListTv;
- (IBAction)onTapBackBtn:(id)sender;

@end

@implementation RegisteredBeaconsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeWSCallToGetListOfBeacons];


    
}


-(void)makeWSCallToGetListOfBeacons {
    
    busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    busyView.labelText = @"Please Wait..";
    busyView.dimBackground = YES;
    busyView.delegate = self;

    NSString *urlStr = GetListOfBeacons;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
    NSString *userType=[[UserInfo SharedInfo] objectForKey:@"userType"];
    [_paramsDict setValue:userId forKey:@"userId"];
    [_paramsDict setValue:userType forKey:@"userType"];
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    
    
}
-(void)makeWSCallToDeleteBeaconList {
    
}
-(void)recievedServiceCallData:(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"errorCode"]isEqualToString:@"400"]) {
        [busyView hide:YES];
        UIAlertView *_noBeaconsAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Oppss.!! NoBeacons Registered Yet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        _noBeaconsAlert.tag=956;
        [_noBeaconsAlert show];
        
    } else {
        [busyView hide:YES];
        self.registeredBeacons  = [[NSMutableArray alloc] init];
        NSArray *_listOfBeacons = [dictionary objectForKey:@"beaconDetails"];
        for (NSDictionary *_beaconDict in _listOfBeacons) {
            BeaconObj *tempObj = [[BeaconObj alloc] init];
            tempObj.Uuid = [_beaconDict objectForKey:@"uuId"];
            tempObj.majorId = [_beaconDict objectForKey:@"majorValue"];
            tempObj.minorId = [_beaconDict objectForKey:@"minorValue"];
            tempObj._beaconDescription = [_beaconDict objectForKey:@"beaconDescription"];
            tempObj._beaconTagLine =[_beaconDict objectForKey:@"beaconTag"];
            [self.registeredBeacons addObject:tempObj];
        }
        [self.beaconListTv reloadData];
    }
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage {
    [busyView hide:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.beaconListTv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.beaconListTv.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListCell"];
    
    BeaconObj *tempObj = [self.registeredBeacons objectAtIndex:[indexPath row]];
    
    UILabel *beaconDescriptionLbl = (UILabel*) [cell viewWithTag:80];
    UILabel *beaconTagLbl = (UILabel*) [cell viewWithTag:90];
    UILabel *uuidLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *majorLbl = (UILabel*) [cell viewWithTag:200];
    UILabel *minorLbl = (UILabel*) [cell viewWithTag:300];
    
    NSString *beaconDescrip = [NSString stringWithFormat:@"Beacon Description : %@",tempObj._beaconDescription];
    NSString *beaconTag = [NSString stringWithFormat:@"Beacon TagLine : %@",tempObj._beaconTagLine];
    NSString *uuidVal = [NSString stringWithFormat:@"UUID : %@",tempObj.Uuid];
    NSString *majorVal = [NSString stringWithFormat:@"Major : %@",tempObj.majorId];
    NSString *minorVal = [NSString stringWithFormat:@"Minor : %@",tempObj.minorId];
    
    [beaconDescriptionLbl setText:beaconDescrip];
    [beaconTagLbl setText:beaconTag];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"I deleted a cell!");
        busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        busyView.labelText = @"Please Wait..";
        busyView.dimBackground = YES;
        busyView.delegate = self;
        
        NSString *urlStr = DeleteBeacon;
        ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
        _serviceAPI.apiDelegate=self;
        NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
        NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
        [_paramsDict setValue:userId forKey:@"userId"];
        BeaconObj *beaconObjid = [self.registeredBeacons objectAtIndex:[indexPath row]];
        NSString *minorVal = [NSString stringWithFormat:@"%@",beaconObjid.minorId];
        [_paramsDict setValue:minorVal forKey:@"minorValue"];
        [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 130;
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==956) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onTapBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
