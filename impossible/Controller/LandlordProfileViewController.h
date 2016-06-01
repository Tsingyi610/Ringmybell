//
//  LandlordProfileViewController.h
//  impossible
//
//  Created by Blessed on 16/4/24.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface LandlordProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger uid;

@end

@interface LandlordProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *landlordName;
@property (weak, nonatomic) IBOutlet UILabel *enrolTime;
@end

@interface IdentifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *identifyDesc;
@property (weak, nonatomic) IBOutlet UILabel *identifyType;
@property (weak, nonatomic) IBOutlet UIImageView *identifyTypeImage;
@end

@interface PublishedHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *publishedImage;
@property (weak, nonatomic) IBOutlet UILabel *publishedHouseName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPublished;
@end