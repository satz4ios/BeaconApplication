//
//  TaggedCouponsViewController.m
//  Beaconing
//
//  Created by Marimuthu on 6/6/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "TaggedCouponsViewController.h"
#import "CouponObj.h"


@interface TaggedCouponsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *couponsListView;
@property (nonatomic,strong) NSMutableArray *taggedCoupons;
@end

@implementation TaggedCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _taggedCoupons = [[NSMutableArray alloc] init];
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
    
    [_couponsListView reloadData];
    
    [_couponsListView setBackgroundView:nil];
    [_couponsListView setBackgroundColor:[UIColor clearColor]];

    
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