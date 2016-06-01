//
//  RMBDataSource.h
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMBUserInfo.h"

@interface RMBDataSource : NSObject

@property (nonatomic, strong) RMBUserInfo *userInfo;
@property (nonatomic, copy) NSArray *convenienceArray;
@property (nonatomic, copy) NSArray *houseListArray;
@property (nonatomic, copy) NSDictionary *singleHouseDic;

//user passport
@property (nonatomic, assign) NSInteger pass;

//blur location
@property (nonatomic, copy) NSString *cityname;
@property (nonatomic, copy) NSString *province;

//发布空间数据源
@property (nonatomic, assign) NSInteger htype;
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *location_city;
@property (nonatomic, copy) NSString *location_province;
@property (nonatomic, copy) NSString *maxVisitors;
@property (nonatomic, copy) NSString *bedroom;
@property (nonatomic, copy) NSString *bed;
@property (nonatomic, copy) NSString *bathroom;
@property (nonatomic, assign) NSInteger hid;    //发布创建时根据该用户的最新的记录获取的hid 如入口为我的房源 则根据选择来获取hid
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *hdesc;
@property (nonatomic, copy) NSString *hlocation;
@property (nonatomic, assign) NSInteger price_per;
@property (nonatomic, copy) NSString *minEvenings;
@property (nonatomic, copy) NSString *himage;
@property (nonatomic, copy) NSArray *convenienceArraySelected;
//详情
@property (nonatomic, copy) NSString *visitor_limited;
@property (nonatomic, copy) NSString *block_style;
@property (nonatomic, copy) NSString *others;
@property (nonatomic, copy) NSString *transport;
@property (nonatomic, copy) NSString *rule;

//我的房源
@property (nonatomic, copy) NSArray *myHouse;

//我的足迹
@property (nonatomic, copy) NSArray *myStep;

//我的评价
@property (nonatomic, copy) NSArray *myComment;

//我的收藏
@property (nonatomic, copy) NSArray *defaultCollection;
@property (nonatomic, copy) NSArray *customCollection;
@property (nonatomic, copy) NSArray *customCollectionList;
@property (nonatomic, copy) NSArray *coverImage;
//心愿单
@property (nonatomic, copy) NSArray *wishlist;

@property (nonatomic, copy) NSArray *payment;

//单个房源的可选内容
@property (nonatomic, copy) NSDictionary *optionalDetail;

//搜索页面房源热度即时排序
@property (nonatomic, copy) NSArray *hotCity;

//轮播图
@property (nonatomic, copy) NSArray *carouselArray;
//每月推荐主题
@property (nonatomic, copy) NSDictionary *monthlyThemeDic;

//下方三个活动信息
@property (nonatomic, copy) NSArray *threeActivity;

//singlehouse reuse view
@property (nonatomic, copy) NSDictionary *strategy;
@property (nonatomic, copy) NSString *houseRule;

//message
@property (nonatomic, copy) NSArray *messageApplyid;
@property (nonatomic, copy) NSArray *messageHouseinfo;

+ (instancetype) sharedInstance;
@end
