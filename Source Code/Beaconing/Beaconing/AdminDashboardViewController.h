//
//  AdminDashboardViewController.h
//  Beaconing
//
//  Created by Zweezle Media Private Limited on 14/03/15.
//  Copyright (c) 2015 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminDashboardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_TableViewObj;

@end
