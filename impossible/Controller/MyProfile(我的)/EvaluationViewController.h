//
//  EvaluationViewController.h
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface EvaluationViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface EvaluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UIImageView *satisfactionImage;

@end
