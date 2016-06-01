//
//  MonthlyViewController.h
//  impossible
//
//  Created by Blessed on 16/4/26.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "BaseViewController.h"

@interface MonthlyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//作为可配置的首页二级页面，需要首页传来的参数
@property (assign, nonatomic) NSInteger relyTag;    //判断入口tag
@property (copy, nonatomic) NSData *headerImage; //header图片
@property (copy, nonatomic) NSString *headerLabelText;  //header Cover 文字
@property (copy, nonatomic) NSString *descTitle;        //描述文字title
@property (copy, nonatomic) NSString *descContent;      //描述文字content
@property (nonatomic, copy) NSString *acid; //首页下方活动id
@property (nonatomic, copy) NSString *monthImage;
@end

@interface StaticCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recommendContent;
@property (weak, nonatomic) IBOutlet UILabel *caTitle;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImage;


@end

@interface RecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *himage;
@property (weak, nonatomic) IBOutlet UIImageView *uimage;
@property (weak, nonatomic) IBOutlet UILabel *hname;
@property (weak, nonatomic) IBOutlet UILabel *cityname;
@property (weak, nonatomic) IBOutlet UILabel *htype;
@property (weak, nonatomic) IBOutlet UIButton *wishlist;

@end