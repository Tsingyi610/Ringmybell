//
//  PublishFirstStepViewController.h
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishFirstStepViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@interface IntroCell : UITableViewCell

@end

@interface HouseTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeDesc;

@end