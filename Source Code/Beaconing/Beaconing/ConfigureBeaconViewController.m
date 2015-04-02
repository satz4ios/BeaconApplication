//
//  ConfigureBeaconViewController.m
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ConfigureBeaconViewController.h"

#import "Services.h"
#import "MBProgressHUD.h"



@interface ConfigureBeaconViewController (){

}

@property (weak, nonatomic) IBOutlet UITextField *uuidTxtField;
@property (weak, nonatomic) IBOutlet UITextField *majorTxtField;

@property (weak, nonatomic) IBOutlet UITextField *minorTxtField;
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
//        [[_actionBtn titleLabel] setText:@"Save"];
        [_actionBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (IBAction)backClick:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}




-(void)makeWSCallForAddOrEditBeacon{

    NSString *urlStr = AddOrEditBeacon;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    [_paramsDict setValue:self.uuidTxtField.text forKey:@"uuId"];
    [_paramsDict setValue:self.majorTxtField.text forKey:@"majorValue"];
    [_paramsDict setValue:self.minorTxtField.text forKey:@"minorValue"];
    [_paramsDict setValue:self.beaconDescTxtField.text forKey:@"beaconDescription"];
    [_paramsDict setValue:self.beaconTagTxtField.text forKey:@"beaconTag"];
    
#warning add user id for created by 
    [_paramsDict setValue:@"1" forKey:@"createdBy"];
    
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}  


-(void)makeWSCallForEditBeacon{
    
    //http://gotocontactsonline.com/beaconapp/beaconconfig.php?uuId=1234&majorValue=12&minorValue=0.5&beaconDescription=test&beaconTag=test&createdBy=1
    
    NSString *urlStr = AddOrEditBeacon;
    ServiceCallAPI *_serviceAPI = [[ServiceCallAPI alloc]initWithService:urlStr];
    _serviceAPI.apiDelegate=self;
    NSMutableDictionary *_paramsDict = [[NSMutableDictionary alloc] init];
    [_paramsDict setValue:self.uuidTxtField.text forKey:@"uuId"];
    [_paramsDict setValue:self.majorTxtField.text forKey:@"majorValue"];
    [_paramsDict setValue:self.minorTxtField.text forKey:@"minorValue"];
    [_paramsDict setValue:self.beaconDescTxtField.text forKey:@"beaconDescription"];
    [_paramsDict setValue:self.beaconTagTxtField.text forKey:@"beaconTag"];
    
#warning add user id for created by
    [_paramsDict setValue:@"1" forKey:@"createdBy"];
    
    [_serviceAPI sendHttpRequestServiceWithParameters:_paramsDict];
}


#pragma mark APIserviceProto delegates

-(void)recievedServiceCallData:(NSDictionary *)dictionary{


    [_actiivityView hide:YES];
    NSString *message = dictionary[@"message"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil
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
    _actiivityView.labelText = @"Updating...";
    _actiivityView.dimBackground = YES;

    
    
    NSString *beaconTag = self.beaconTagTxtField.text;
    NSString *beaconDesc =  self.beaconDescTxtField.text;
    
    if(!([beaconTag length] > 0)
       || !([beaconDesc length] > 0)){
        
        [_actiivityView hide:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Pls fill all the details."
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        

        
        
    }
    else{
        [self makeWSCallForAddOrEditBeacon];
/*        if (_launcedFrom == AddBeaconFlow) {
            [self makeWSCallForAddingBeacon];
        }
        else{
            [self makeWSCallForEditBeacon];
        }*/
        
    }
}


-(void)resignKeyboard{
    [_beaconDescTxtField resignFirstResponder];
    [_beaconTagTxtField resignFirstResponder];
}
@end