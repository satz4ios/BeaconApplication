//
//  NormalUserViewController.m
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 21/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "NormalUserViewController.h"
#import "CouponObj.h"

@interface NormalUserViewController ()
@property (weak, nonatomic) IBOutlet UITableView *receivedCouponsList;
@property (strong, nonatomic) NSMutableArray *receivedDeals;

@end

@implementation NormalUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    _receivedDeals = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (int idx = 0; idx <10; idx++) {
        CouponObj *tempObj = [[CouponObj alloc] init];
        [tempObj setCouponTitle:[NSString stringWithFormat:@"Coupon Name %d",idx]];
        [tempObj setCouponDesc:[NSString stringWithFormat:@"The interest rate stated on bond when it's issued.The coupon is paid semiannually"]];
        [_receivedDeals addObject:tempObj];
        
    }
    
    [_receivedCouponsList reloadData];
    
    [_receivedCouponsList setBackgroundView:nil];
    [_receivedCouponsList setBackgroundColor:[UIColor clearColor]];
    
    
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

#pragma mark TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.receivedDeals count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponListCell"];
    
    
    CouponObj *tempObj = [_receivedDeals objectAtIndex:[indexPath   row]];
    
    UILabel *couponTitleLbl = (UILabel*) [cell viewWithTag:100];
    UILabel *couponDescriptionLbl = (UILabel*) [cell viewWithTag:200];
    
    
    
    NSString *couponTitleText = @"Coupon Title :  ";
    NSMutableAttributedString *couponTitleAttString=[[NSMutableAttributedString alloc] initWithString:couponTitleText];
    NSInteger _stringLength=[couponTitleText length];
  //  [couponTitleAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
    NSString *couponTitleVal = [NSString stringWithFormat:@"%@",tempObj.couponTitle];
    NSMutableAttributedString *couponTitleAttString1=[[NSMutableAttributedString alloc] initWithString:couponTitleVal];
    _stringLength=[couponTitleVal length];
    
    [couponTitleAttString appendAttributedString:couponTitleAttString1];
    
    [couponTitleLbl setAttributedText:couponTitleAttString];
    
    
    NSString *couponDescText = @"Coupon Title :  ";
    NSMutableAttributedString *couponDescAttString=[[NSMutableAttributedString alloc] initWithString:couponDescText];
    _stringLength=[couponDescText length];
    //[couponDescAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(3.0/255.0) green:(186.0/255.0) blue:(143.0/255.0) alpha:1.0] range:NSMakeRange(0, _stringLength)];
    
    
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

@end
