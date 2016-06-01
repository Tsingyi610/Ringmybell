//
//  PublishThirdStepViewController.h
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishThirdStepViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxVisitors;
@property (weak, nonatomic) IBOutlet UILabel *bedroom;
@property (weak, nonatomic) IBOutlet UILabel *bed;
@property (weak, nonatomic) IBOutlet UILabel *bathroom;


@property (assign, nonatomic) NSInteger receivedTag;
@end
