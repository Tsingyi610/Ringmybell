//
//  WishListViewController.h
//  impossible
//
//  Created by Blessed on 16/2/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface WishListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *wishListImage;
@property (weak, nonatomic) IBOutlet UIImageView *wishListCover;
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *hcity;
@property (weak, nonatomic) IBOutlet UILabel *price_per;

@end

@interface WishListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *noDataDisplay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

