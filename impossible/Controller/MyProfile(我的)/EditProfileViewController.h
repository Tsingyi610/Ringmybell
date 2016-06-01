//
//  EditProfileViewController.h
//  impossible
//
//  Created by Blessed on 16/3/13.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditProfileDelegate <NSObject>
@required
- (void)changeInfomation:(NSString*)content andTag:(NSInteger)tag;
@end


@interface EditProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
@property (weak, nonatomic) IBOutlet UITextField *normalEditTextField;

@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic,assign) NSInteger selectedTag;
@property (nonatomic,copy) NSString *editTargetLabel;
@property (nonatomic,copy) NSString *editTarget;

@property (weak, nonatomic) id<EditProfileDelegate> delegate;
- (IBAction)confirmAction:(id)sender;
@end
