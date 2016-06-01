//
//  LBSViewController.h
//  impossible
//
//  Created by Blessed on 16/4/26.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface LBSViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *cityid;
@end

@interface LBSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *hlocation;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *hdesc;
@property (weak, nonatomic) IBOutlet UIView *goodSatisfaction;
@property (weak, nonatomic) IBOutlet UIImageView *himage;

@end