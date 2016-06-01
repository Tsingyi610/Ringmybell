//
//  PersonalInfoViewController.h
//  impossible
//
//  Created by Blessed on 16/3/5.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"


@interface PersonalInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@interface HeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end

@interface NormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalDetailLabel;

@end


