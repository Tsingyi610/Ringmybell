//
//  IndexViewController.h
//  impossible
//
//  Created by Blessed on 16/1/29.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface IndexViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageControl;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *monthlyRec;

@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *monthlyBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *lbsBackImage;

//首页栏目view 须添加tapGesture
@property (weak, nonatomic) IBOutlet UIView *monthlyView;
@property (weak, nonatomic) IBOutlet UIView *tourStrategyView;
@property (weak, nonatomic) IBOutlet UIView *firstBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *firstBottomImage;
@property (weak, nonatomic) IBOutlet UILabel *firstBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *secondBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *secondBottomImage;
@property (weak, nonatomic) IBOutlet UILabel *secondBottomLabel;
@property (weak, nonatomic) IBOutlet UIView *thirdBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdBottomImage;
@property (weak, nonatomic) IBOutlet UILabel *thirdBottomLabel;
@end
