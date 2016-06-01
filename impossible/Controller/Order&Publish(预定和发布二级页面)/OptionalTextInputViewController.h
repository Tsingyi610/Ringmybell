//
//  OptionalTextInputViewController.h
//  impossible
//
//  Created by Blessed on 16/5/15.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface OptionalTextInputViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *optionalInputTV;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (assign, nonatomic) NSInteger selectTag;
@end
