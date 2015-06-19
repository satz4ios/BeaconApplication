//
//  TaggedCouponsViewController.m
//  Beaconing
//
//  Created by Marimuthu on 6/6/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "TaggedCouponsViewController.h"
#import "CouponObj.h"
#import "UserInfo.h"
#import "ServiceCallAPI.h"
#import "Services.h"
#import "CouponObj.h"

@interface TaggedCouponsViewController () {
    MBProgressHUD *busyView;

}

@property (weak, nonatomic) IBOutlet UITableView *couponsListView;
@property (nonatomic,strong) NSMutableArray *taggedCoupons;
@end

@implementation TaggedCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _taggedCoupons = [[NSMutableArray alloc] init];
    
    [self makeWSCallToGetListOfCoupons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (int idx = 0; idx <10; idx++) {
        CouponObj *tempObj = [[CouponObj alloc] init];
        [tempObj setCouponTitle:[NSString stringWithFormat:@"Coupon Name %d",idx]];
        [tempObj setCouponDesc:[NSString stringWithFormat:@"The interest rate stated on bond when it's issued.The coupon is paid semiannually"]];
        [_taggedCoupons addObject:tempObj];
        
    }
    
   // [_couponsListView reloadData];
    
    [_couponsListView setBackgroundView:nil];
    [_couponsListView setBackgroundColor:[UIColor clearColor]];

    
}
-(void)makeWSCallToGetListOfCoupons {
    
    busyView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    busyView.labelText = @"Please Wait..";
    busyView.dimBackground = YES;
    busyView.delegate = self;
    
    /*NSString *urlStr = GetListOfBeacons;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
    NSString *userType=[[UserInfo SharedInfo] objectForKey:@"userType"];
    [_paramsDict setValue:userId forKey:@"userId"];
    [_paramsDict setValue:userType forKey:@"userType"];
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];*/

    
    //url: http://gotocontactsonline.com/beaconapp/listcoupon.php?userId=1&userType=1
    NSString *urlStr = GetListofCoupons;
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
        NSString *message = dictionary[@"message"];
        UIAlertView *_noBeaconsAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        _noBeaconsAlert.tag=956;
        [_noBeaconsAlert show];
        
    } else {
        [busyView hide:YES];
        self.taggedCoupons  = [[NSMutableArray alloc] init];
        NSArray *_listOfBeacons = [dictionary objectForKey:@"beaconDetails"];
        for (NSDictionary *_beaconDict in _listOfBeacons) {
            CouponObj *tempObj = [[CouponObj alloc] init];
            tempObj.couponId = [_beaconDict objectForKey:@"couponId"];
            tempObj.couponTitle = [_beaconDict objectForKey:@"couponTagline"];
            tempObj.couponDesc = [_beaconDict objectForKey:@"couponDescription"];
            tempObj.beaconMajorId = [_beaconDict objectForKey:@"majorValue"];
            tempObj.beaconMinorId = [_beaconDict objectForKey:@"minorValue"];
            /*
             "couponId": "5",
             "uuId": "112",
             "couponDescription": "test",
             "couponTagline": "test",
             "majorValue": "11",
             "minorValue": "37",
             "createdDate": "2015-04-22",
             "userId": "1"
             */
            [self.taggedCoupons addObject:tempObj];
        }
        [self.couponsListView reloadData];
    }

    
    
}
-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
}

#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.taggedCoupons count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponListCell"];
    
    
    CouponObj *tempObj = [_taggedCoupons objectAtIndex:[indexPath   row]];
    
    UILabel *couponTitleLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *couponDescriptionLbl = (UILabel*) [cell viewWithTag:200];


    
    NSString *couponTitleText = @"Coupon Title :  ";
    NSMutableAttributedString *couponTitleAttString=[[NSMutableAttributedString alloc] initWithString:couponTitleText];
    NSInteger _stringLength=[couponTitleText length];
    [couponTitleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
    NSString *couponTitleVal = [NSString stringWithFormat:@"%@",tempObj.couponTitle];
    NSMutableAttributedString *couponTitleAttString1=[[NSMutableAttributedString alloc] initWithString:couponTitleVal];
    _stringLength=[couponTitleVal length];
    
    [couponTitleAttString appendAttributedString:couponTitleAttString1];
    
    [couponTitleLbl setAttributedText:couponTitleAttString];
    

    NSString *couponDescText = @"Coupon Title :  ";
    NSMutableAttributedString *couponDescAttString=[[NSMutableAttributedString alloc] initWithString:couponDescText];
    _stringLength=[couponDescText length];
    [couponDescAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
    NSString *couponDescVal = [NSString stringWithFormat:@"%@",tempObj.couponDesc];
    NSMutableAttributedString *couponDescAttString1=[[NSMutableAttributedString alloc] initWithString:couponDescVal];
    _stringLength=[couponDescVal length];
    
    [couponDescAttString appendAttributedString:couponDescAttString1];
    
    [couponDescriptionLbl setAttributedText:couponDescAttString];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
