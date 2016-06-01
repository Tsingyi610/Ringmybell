//
//  OrderResultViewController.h
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderResultViewController : BaseViewController
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, assign) NSInteger night;

@property (weak, nonatomic) IBOutlet UILabel *hnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end
