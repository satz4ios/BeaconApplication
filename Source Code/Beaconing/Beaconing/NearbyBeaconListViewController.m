//
//  SearchBeaconViewController.m
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "NearbyBeaconListViewController.h"
#import "BeaconObj.h"
#import "ConfigureBeaconViewController.h"

@interface NearbyBeaconListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) BeaconManager *beaconMgr;

@property (strong,nonatomic) NSMutableArray *searchedBeacons;
@property (weak, nonatomic) IBOutlet UITableView *beaconListTv;

@property (strong,nonatomic) CBCentralManager *bluetoothManager;


@end

@implementation NearbyBeaconListViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self detectBluetoothWithOSAlert:YES];
    
    
    for (int idx =0; idx<5; idx++) {
        BeaconObj *tempObj = [[BeaconObj alloc] init];
        tempObj.Uuid = @"123";
        tempObj.majorId = @"123";
        tempObj.minorId = @"123";
        
        [self.searchedBeacons addObject:tempObj];
    }
    
    [self.beaconListTv reloadData];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        [self.beaconMgr stopMonitoringAndRangingKontactBeacons];
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    return [self.searchedBeacons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconListCell"];

    BeaconObj *tempObj = [self.searchedBeacons objectAtIndex:[indexPath row]];
    
    
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
    [_configBeacon setSelectedBeacon:[self.searchedBeacons objectAtIndex:[indexPath row]]];
    [_configBeacon setLauncedFrom:AddBeaconFlow];

    [self.navigationController pushViewController:_configBeacon animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        
        if (beacon.proximity == CLProximityImmediate || beacon.proximity == CLProximityNear ) {
            
            BeaconObj *tempObj = [[BeaconObj alloc] init];
            
            [tempObj setUuid:[[beacon proximityUUID]UUIDString]];
            [tempObj setMajorId:[NSString stringWithFormat:@"%@",[beacon major]]];
            [tempObj setMinorId:[NSString stringWithFormat:@"%@",[beacon minor]]];
            
            
            __block BOOL isAlreadyPresent = NO;
            
            [self.searchedBeacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                

                if ([[obj Uuid] isEqualToString:[tempObj Uuid]] &&
                    [[obj majorId] isEqualToString:[tempObj majorId]] &&
                    [[obj minorId] isEqualToString:[tempObj minorId]]
                    ) {
                    
                    isAlreadyPresent = YES;
                }
                
            }];
            
            if (!isAlreadyPresent) {
                [self.searchedBeacons addObject:tempObj];
                [self.beaconListTv reloadData];
            }
        }
        
    }];
    
    NSLog(@"didRangeBeacons");
    

    
    
    
}
- (void)beaconManager:(BeaconManager *)beaconMgr didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}


-(void)detectBluetoothWithOSAlert:(BOOL)isAlertNeeded
{
    if ([CBCentralManager class]) {
        
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        
        
        if (isAlertNeeded) {
            self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()] ;
        }
        else{
            self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                         queue:nil
                                                                       options:
                                     [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                                 forKey:CBCentralManagerOptionShowPowerAlertKey]];
            
        }
        
    } else {
        
        NSLog(@"Core bluetooth not supported");
    }
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = [[NSString alloc] init];
    
    
    switch(central.state)
    {
        case CBCentralManagerStateResetting:
            stateString = @"The connection with the system service was momentarily lost, update imminent.";
            break;
        case CBCentralManagerStateUnsupported:
            stateString = @"The platform doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            stateString = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:{
            
            stateString = @"Bluetooth is currently powered off.Please switch it on from settings";
    
        }
            break;
        case CBCentralManagerStatePoweredOn:{
            
            stateString = @"Bluetooth is currently powered on and available to use.";
            [self.beaconMgr startMonitoringKontactBeacons];
        }
            break;
        default:
            stateString = @"State unknown, update imminent.";
            break;
    }
    
    NSLog(@"%@",stateString);
    
}



@end
