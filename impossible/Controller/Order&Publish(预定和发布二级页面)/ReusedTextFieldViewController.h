//
//  ReusedTextFieldViewController.h
//  impossible
//
//  Created by Blessed on 16/4/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@protocol CallbackDelegate <NSObject>
@required
- (void)callbackData:(NSString*)data andTag:(NSInteger)tag;
@end


@interface ReusedTextFieldViewController : BaseViewController
@property (assign, nonatomic) NSInteger navTitleTag;
@property (copy, nonatomic) NSArray *typeArr;
@property (copy, nonatomic) NSString *arg;
@property (copy, nonatomic) NSArray *toChange;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) id<CallbackDelegate> delegate;
@end
