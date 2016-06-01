//
//  ExtraFeeViewController.h
//  impossible
//
//  Created by Blessed on 16/3/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface ExtraFeeViewController : BaseViewController
@property (nonatomic, assign) NSInteger distinguish;
@property (nonatomic, assign) NSInteger hid;

//1
@property (weak, nonatomic) IBOutlet UILabel *weekDiscount;
@property (weak, nonatomic) IBOutlet UILabel *monthDiscount;
@property (weak, nonatomic) IBOutlet UILabel *weekDiscountNum;
@property (weak, nonatomic) IBOutlet UILabel *monthDiscountNum;

//2 & rule
@property (weak, nonatomic) IBOutlet UILabel *strategy;

@end
