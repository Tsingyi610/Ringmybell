//
//  RegistViewController.h
//  impossible
//
//  Created by Blessed on 16/1/28.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *hintContainer;

@property (weak, nonatomic) IBOutlet UIView *back2Welcome;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
