//
//  RegisterUserViewController.h
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceCallAPI.h"
@interface RegisterUserViewController : UIViewController<APIserviceProto,UITextFieldDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;

}
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *fNameFld;
@property (weak, nonatomic) IBOutlet UITextField *lNameFld;
@property (weak, nonatomic) IBOutlet UITextField *emailId;
@property (weak, nonatomic) IBOutlet UITextField *passwrdFld;
@property (weak, nonatomic) IBOutlet UITextField *cPasswrdFld;
@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *businesNameFld;
@property (weak, nonatomic) IBOutlet UITextField *contactFld;
@property (weak, nonatomic) IBOutlet UIScrollView *_scrollView;

- (IBAction)registerUser:(id)sender;

@end
