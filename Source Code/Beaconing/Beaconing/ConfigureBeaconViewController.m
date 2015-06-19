//
//  ConfigureBeaconViewController.m
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ConfigureBeaconViewController.h"
#import "UserInfo.h"
#import "Services.h"
#import "MBProgressHUD.h"



@interface ConfigureBeaconViewController ()<UIAlertViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UILabel *uuidTxtField;
@property (weak, nonatomic) IBOutlet UILabel *majorTxtField;

@property (weak, nonatomic) IBOutlet UILabel *minorTxtField;
@property (weak, nonatomic) IBOutlet UITextField *beaconTagTxtField;
@property (weak, nonatomic) IBOutlet UITextField *beaconDescTxtField;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;


@property (strong,nonatomic) MBProgressHUD *actiivityView;

- (IBAction)onTapAddBtn:(id)sender;

@end

@implementation ConfigureBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self.uuidTxtField setText:_selectedBeacon.Uuid];
    [self.majorTxtField setText:_selectedBeacon.majorId];
    [self.minorTxtField setText:_selectedBeacon.minorId];
    
    if (_launcedFrom == EditBeaconFlow) {
        [_actionBtn setTitle:@" Save " forState:UIControlStateNormal];
        [self.beaconTagTxtField setText:_selectedBeacon._beaconTagLine];
        [self.beaconDescTxtField setText:_selectedBeacon._beaconDescription];
    
    }
    
    _actionBtn.layer.cornerRadius = 5.0;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (IBAction)backClick:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}



-(void)makeWSCallForAddOrEditBeacon{

    NSString *urlStr = AddBeacon;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    [_paramsDict setValue:self.uuidTxtField.text forKey:@"uuId"];
    [_paramsDict setValue:self.majorTxtField.text forKey:@"majorValue"];
    [_paramsDict setValue:self.minorTxtField.text forKey:@"minorValue"];
    [_paramsDict setValue:self.beaconDescTxtField.text forKey:@"beaconDescription"];
    [_paramsDict setValue:self.beaconTagTxtField.text forKey:@"beaconTag"];
    NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
    [_paramsDict setValue:userId forKey:@"userId"];
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}  


-(void)makeWSCallForEditBeacon{
    
    
    
   // http://www.gotocontactsonline.com/beaconapp/updatebeacon.php?uuId=1&majorValue=1&minorValue=1&beaconDescription=test&beaconTag=test&userId=1&beaconId=18
    
    
    NSString *urlStr = UpdateBeacon;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    [_paramsDict setValue:self.uuidTxtField.text forKey:@"uuId"];
    [_paramsDict setValue:self.majorTxtField.text forKey:@"majorValue"];
    [_paramsDict setValue:self.minorTxtField.text forKey:@"minorValue"];
    
    [_paramsDict setValue:self.beaconDescTxtField.text forKey:@"beaconDescription"];
    [_paramsDict setValue:self.beaconTagTxtField.text forKey:@"beaconTag"];
    NSString *userId=[[UserInfo SharedInfo]objectForKey:@"userId"];
    [_paramsDict setValue:userId forKey:@"userId"];
    [_paramsDict setValue:self.selectedBeacon.identifier forKey:@"beaconId"];
    
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}


#pragma mark APIserviceProto delegates

-(void)recievedServiceCallData:(NSDictionary *)dictionary{


    [_actiivityView hide:YES];
    NSString *message = dictionary[@"message"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert   show];

    
    
    
}

-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
    [_actiivityView hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:ErrorMessage.localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert   show];
    
    
}

#pragma mark UITextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onTapAddBtn:(id)sender {
    
    [self resignKeyboard];
    
    _actiivityView= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _actiivityView.labelText = @"Registering Beacon...";
    _actiivityView.dimBackground = YES;

    
    
    NSString *beaconTag = self.beaconTagTxtField.text;
    NSString *beaconDesc =  self.beaconDescTxtField.text;
    
    if(!([beaconTag length] > 0)
       || !([beaconDesc length] > 0)){
        
        [_actiivityView hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please fill all the details."
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        

        
        
    }
    else{
        //[self makeWSCallForAddOrEditBeacon];
       if (_launcedFrom == AddBeaconFlow) {
            [self makeWSCallForAddOrEditBeacon];
        }
        else{
            [self makeWSCallForEditBeacon];
        }
        
    }
}


-(void)resignKeyboard{
    [_beaconDescTxtField resignFirstResponder];
    [_beaconTagTxtField resignFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end