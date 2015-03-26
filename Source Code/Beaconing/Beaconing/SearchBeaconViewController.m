//
//  SearchBeaconViewController.m
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "SearchBeaconViewController.h"
#import "BeaconObj.h"

@interface SearchBeaconViewController ()

@property (strong,nonatomic) BeaconManager *beaconMgr;

@property (strong,nonatomic) NSMutableArray *searchedBeacons;
@property (weak, nonatomic) IBOutlet UITableView *beaconListTv;

@end

@implementation SearchBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.beaconMgr = [[BeaconManager alloc] init];
    [self.beaconMgr setDelegate:self];
    [self.beaconMgr initializeCoreLocationManager];
    
    self.searchedBeacons  = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self.beaconMgr startMonitoringKontactBeacons];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        [self.beaconMgr stopMonitoringAndRangingKontactBeacons];
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
    return 5;
    return [self.searchedBeacons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListCell"];

    //BeaconObj *tempObj = [self.searchedBeacons objectAtIndex:[indexPath row]];
    BeaconObj *tempObj = [[BeaconObj alloc] init];
    tempObj.Uuid = @"123";
    tempObj.majorId = @"123";
    tempObj.minorId = @"123";
    
    UILabel *uuidLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *majorLbl = (UILabel*) [cell viewWithTag:200];
    UILabel *minorLbl = (UILabel*) [cell viewWithTag:300];
    
    [uuidLbl setText:tempObj.Uuid];
    
    NSString *majorMinorVal = [NSString stringWithFormat:@"%@,%@",tempObj.majorId,tempObj.minorId];
//    [majorLbl setText:tempObj.majorId];
    [minorLbl setText:@""];
    
    [majorLbl setText:majorMinorVal];
    
    return cell;
}


#pragma mark beacon mgr delegates
-(void)beaconManager:(BeaconManager*)beaconMgr didEnterRegion:(CLRegion*)region{
    NSLog(@"didEnterRegion");
}

-(void)beaconManager:(BeaconManager*)beaconMgr didExitRegion:(CLRegion*)region{
    NSLog(@"didExitRegion");
    

    
}
-(void)beaconManager:(BeaconManager*)beaconMgr
     didRangeBeacons:(NSArray*)beacons
            inRegion:(CLBeaconRegion*)region{

    
    [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CLBeacon *beacon = (CLBeacon*)obj;
        
        if (beacon.proximity == CLProximityImmediate || beacon.proximity == CLProximityImmediate ) {
            
            BeaconObj *tempObj = [[BeaconObj alloc] init];
            
            [tempObj setUuid:[[beacon proximityUUID]UUIDString]];
            [tempObj setMajorId:[NSString stringWithFormat:@"%@",[beacon major]]];
            [tempObj setMinorId:[NSString stringWithFormat:@"%@",[beacon minor]]];
            
            if (![self.searchedBeacons containsObject:tempObj]) {
                [self.searchedBeacons addObject:tempObj];
                [self.beaconListTv reloadData];
            }
        }
        
    }];
    
    NSLog(@"didRangeBeacons");
    

    
    
    
}
- (void)beaconManager:(BeaconManager *)beaconMgr didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
} 


@end
