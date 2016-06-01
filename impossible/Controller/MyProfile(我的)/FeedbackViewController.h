//
//  FeedbackViewController.h
//  impossible
//
//  Created by Blessed on 16/5/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
