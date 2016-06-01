//
//  CollectionListViewController.h
//  impossible
//
//  Created by Blessed on 16/5/20.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface CollectionListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger ucid;
@end

@interface CollectionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *himage;
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *htype;
@property (weak, nonatomic) IBOutlet UILabel *cityname;
@property (weak, nonatomic) IBOutlet UIImageView *uimage;
@end