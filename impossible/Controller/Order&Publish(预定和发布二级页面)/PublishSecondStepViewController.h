//
//  PublishSecondStepViewController.h
//  impossible
//
//  Created by Blessed on 16/4/27.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishSecondStepViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *houseType;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIView *amapView;
@property (weak, nonatomic) IBOutlet UIView *displayView;

@property (assign, nonatomic) NSInteger receivedTag;
@end
