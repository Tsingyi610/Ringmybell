//
//  MakeCommentViewController.h
//  impossible
//
//  Created by Blessed on 16/5/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface MakeCommentViewController : BaseViewController

@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, copy) NSString *hnameReceive;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *begin_time;
@property (nonatomic, assign) NSInteger hid;

@property (weak, nonatomic) IBOutlet UIImageView *himage;
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *livedTime;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
