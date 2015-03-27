//
//  ConfigureBeaconViewController.m
//  Beaconing
//
//  Created by Marimuthu on 3/26/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ConfigureBeaconViewController.h"

#import "Services.h"



@interface ConfigureBeaconViewController ()

@property (weak, nonatomic) IBOutlet UITextField *uuidTxtField;
@property (weak, nonatomic) IBOutlet UITextField *majorTxtField;

@property (weak, nonatomic) IBOutlet UITextField *minorTxtField;
@property (weak, nonatomic) IBOutlet UITextField *beaconTagTxtField;
@property (weak, nonatomic) IBOutlet UITextField *beaconDescTxtField;
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
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (IBAction)backClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)makeWSCallForAddingBeacon{

    NSString *urlStr = AddBeacon;
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

   // NSString *errorCode = dictionary[@"errorCode"];
    NSString *message = dictionary[@"message"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert   show];

    
    
}

-(void)recievedServiceCallWithError:(NSError *)ErrorMessage{
    
    
    
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
    
    NSString *beaconTag = self.beaconTagTxtField.text;
    NSString *beaconDesc =  self.beaconDescTxtField.text;
    
    if(!([beaconTag length] > 0)
       || !([beaconDesc length] > 0)){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Pls fill all the details."
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    }
    else{
        [self makeWSCallForAddingBeacon];
    }
}
@end