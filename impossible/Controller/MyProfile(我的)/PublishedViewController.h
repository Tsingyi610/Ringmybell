//
//  PublishedViewController.h
//  impossible
//
//  Created by Blessed on 16/4/8.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishedViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface PublishedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hcityAndProvince;
@property (weak, nonatomic) IBOutlet UILabel *publishedTime;
@property (weak, nonatomic) IBOutlet UIImageView *himage;

@end