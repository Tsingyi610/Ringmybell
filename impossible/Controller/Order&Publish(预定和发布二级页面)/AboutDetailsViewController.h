//
//  AboutDetailsViewController.h
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutDetailsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface AboutDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *aboutTitle;
@property (weak, nonatomic) IBOutlet UILabel *aboutContent;

@end