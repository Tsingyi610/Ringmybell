//
//  SettingsViewController.h
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@interface SettingsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

