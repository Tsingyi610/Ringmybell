//
//  MessageViewController.h
//  impossible
//
//  Created by Blessed on 16/3/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface NormalMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *lastContent;
@property (weak, nonatomic) IBOutlet UIView *imreply;

@end