//
//  MoreOptionsViewController.h
//  impossible
//
//  Created by Blessed on 16/4/20.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreOptionsViewController : BaseViewController

//选择时间
@property (weak, nonatomic) IBOutlet UIView *arrivingTimeView;
@property (weak, nonatomic) IBOutlet UIView *leavingTimeView;

//房客数量
@property (weak, nonatomic) IBOutlet UILabel *visitorsNumber;
@property (weak, nonatomic) IBOutlet UIImageView *reduceImage;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;

//房源类型
@property (weak, nonatomic) IBOutlet UIView *wholeHouseView;
@property (weak, nonatomic) IBOutlet UIView *wholeHouseImageBorder;
@property (weak, nonatomic) IBOutlet UIImageView *wholeHouseImage;
@property (weak, nonatomic) IBOutlet UILabel *wholeHouseLabel;

@property (weak, nonatomic) IBOutlet UIView *singleRoomView;
@property (weak, nonatomic) IBOutlet UIView *singleRoomImageBorder;
@property (weak, nonatomic) IBOutlet UIImageView *singleRoomImage;
@property (weak, nonatomic) IBOutlet UILabel *singleRoomLabel;

@property (weak, nonatomic) IBOutlet UIView *sharedRoomView;
@property (weak, nonatomic) IBOutlet UIView *sharedRoomImageBorder;
@property (weak, nonatomic) IBOutlet UIImageView *sharedRoomImage;
@property (weak, nonatomic) IBOutlet UILabel *sharedRoomLabel;

//最高价格
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//房间安排
@property (weak, nonatomic) IBOutlet UILabel *bedNumber;
@property (weak, nonatomic) IBOutlet UIImageView *reduceBedNumberImage;
@property (weak, nonatomic) IBOutlet UIImageView *addBedNumberImage;
@property (weak, nonatomic) IBOutlet UILabel *bedroomNumber;
@property (weak, nonatomic) IBOutlet UIImageView *reduceBedroomImage;
@property (weak, nonatomic) IBOutlet UIImageView *addBedroomImage;
@property (weak, nonatomic) IBOutlet UILabel *sanitationNumber;
@property (weak, nonatomic) IBOutlet UIImageView *reduceSanitationImage;
@property (weak, nonatomic) IBOutlet UIImageView *addSanitationImage;


//便利设施
@property (weak, nonatomic) IBOutlet UITableView *facilitiesTableView;


@end

@interface FacilitiesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *facilitiesName;
@property (weak, nonatomic) IBOutlet UIImageView *ifSelected;

@end