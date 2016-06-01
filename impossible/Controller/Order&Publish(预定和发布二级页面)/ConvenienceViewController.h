//
//  ConvenienceViewController.h
//  impossible
//
//  Created by Blessed on 16/5/1.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface ConvenienceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface ConvenienceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *convenienceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *convenienceImage;

@end