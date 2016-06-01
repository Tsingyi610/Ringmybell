//
//  FavorViewController.h
//  impossible
//
//  Created by Blessed on 16/4/16.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface FavorViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface FavorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;
@property (weak, nonatomic) IBOutlet UILabel *collectionNum;
@end

@interface AddCell : UITableViewCell

@end