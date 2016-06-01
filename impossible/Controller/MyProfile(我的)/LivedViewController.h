//
//  LivedViewController.h
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface LivedViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger sourceTag;
@property (nonatomic, copy) NSArray *comment;
@end

@interface LivedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UILabel *isComment;

@end