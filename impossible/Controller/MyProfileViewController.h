//
//  MyProfileViewController.h
//  impossible
//
//  Created by Blessed on 16/2/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface MyProfileViewController : BaseViewController

//user info view
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;


@end
