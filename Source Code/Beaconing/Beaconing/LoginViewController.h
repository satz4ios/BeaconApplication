//
//  LoginViewController.h
//  Beaconing
//
//  Created by Madhu.A on 25/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import "ViewController.h"
#import "ServiceCallAPI.h"

@interface LoginViewController : UIViewController<APIserviceProto>
@property (weak, nonatomic) IBOutlet UITextField *emailIdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passWrdTxtFld;

@end
