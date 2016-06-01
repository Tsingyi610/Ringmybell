//
//  HeaderTwoViewController.h
//  impossible
//
//  Created by Blessed on 16/4/30.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface HeaderTwoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headViewImage;
@property (weak, nonatomic) IBOutlet UILabel *titleDesc;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger showWhatDisplay;

@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, assign) NSInteger imageTag;
@property (nonatomic, copy) NSString *ca_title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSMutableArray *imageDataArray;

@end
