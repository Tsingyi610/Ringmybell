//
//  GetFavorViewController.h
//  impossible
//
//  Created by Blessed on 16/4/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface GetFavorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *symbolicImage;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *ifMarkedView;

@end

@interface GetFavorViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
