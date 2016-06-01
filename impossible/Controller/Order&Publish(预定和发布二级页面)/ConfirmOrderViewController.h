//
//  ConfirmOrderViewController.h
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface ConfirmOrderViewController : BaseViewController
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, copy) NSString *nameData;
@property (nonatomic, copy) NSString *detailData;
@property (nonatomic, assign) NSInteger allowMaxVisitors;
@property (nonatomic, assign) NSInteger price;

@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *houseDetails;

//confirm date
@property (weak, nonatomic) IBOutlet UIView *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *endTime;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *selectVisitorNumber;
@property (weak, nonatomic) IBOutlet UILabel *showVisitorNumber;
@property (weak, nonatomic) IBOutlet UILabel *maxVisitors;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImage;
@property (weak, nonatomic) IBOutlet UIView *choosePayment;

@property (weak, nonatomic) IBOutlet UILabel *hrule;
@property (weak, nonatomic) IBOutlet UIView *agreeStrategy;
@property (weak, nonatomic) IBOutlet UIImageView *tick;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIView *clear;
@property (weak, nonatomic) IBOutlet UIView *alphaCover;
@end
