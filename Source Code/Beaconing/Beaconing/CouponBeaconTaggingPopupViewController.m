//
//  CouponBeaconTaggingPopupViewController.m
//  Beaconing
//
//  Created by Marimuthu on 6/5/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "CouponBeaconTaggingPopupViewController.h"
#import "BeaconObj.h"
#import "MBProgressHUD.h"
#import "Services.h"
#import "ServiceCallAPI.h"
#import "UserInfo.h"

@interface CouponBeaconTaggingPopupViewController ()<APIserviceProto,MBProgressHUDDelegate>{
        MBProgressHUD *busyView;
}
@property (weak, nonatomic) IBOutlet UITableView *beaconListTv;

- (IBAction)onTapCloseButton:(id)sender;
@property (nonatomic,strong) NSMutableArray *registeredBeacons;
@property (weak, nonatomic) IBOutlet UIView *listBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTrailingSpaceConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLeadingSpaceConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomSpaceConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTopSpaceConstrain;
@end

@implementation CouponBeaconTaggingPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registeredBeacons = [[NSMutableArray alloc] init];
    [self configureView];
    [self makeWSCallToGetListOfBeacons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _bgViewTrailingSpaceConstrain.constant = 150.0;
        _bgViewLeadingSpaceConstrain.constant = 150.0;
        _bgViewBottomSpaceConstrain.constant = 120.0;
        _bgViewTopSpaceConstrain.constant = 120.0;
        
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    _listBgView.layer.cornerRadius=10.0;
    
    self.beaconListTv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //[self detectBluetoothWithOSAlert:YES];
    
    
   /*     for (int idx =0; idx<5; idx++) {
            BeaconObj *tempObj = [[BeaconObj alloc] init];
            tempObj.Uuid = @"123-123-asdasassd-123-asdaads";
            tempObj.majorId = @"123";
            tempObj.minorId = @"123";
    
            [self.registeredBeacons addObject:tempObj];
        }
    
        [self.beaconListTv reloadData];
    */
    
}

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
    _onSelectionOfRow(self,[self.registeredBeacons objectAtIndex:[indexPath row ]]);
    [self onTapCloseButton:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTapCloseButton:(id)sender {
    
//    [self.forgotPasswordBtn setHidden:YES];
//    [self.forgotPasswordTxtField setHidden:YES];
//    [self.infoLabl setHidden:YES];
//    [self.closeBtn setHidden:YES];
//    
//    self.heightConstrain.constant = 150.0;
    
    // TODO: set initial layout constraints here
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         // TODO: set final layout constraints here
                         
                        // self.heightConstrain.constant = 0.0;
                         
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];

                         
                     }];
    
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

-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
}

@end
