//
//  RMBSingleHouse.h
//  impossible
//
//  Created by Blessed on 16/5/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBSingleHouse : NSObject

@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSString *htype;
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, assign) NSInteger max_visitors;
@property (nonatomic, assign) NSInteger hroom;
@property (nonatomic, assign) NSInteger hbed;
@property (nonatomic, assign) NSInteger hbathroom;
@property (nonatomic, assign) NSInteger min_evenings;
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *hdesc;
@property (nonatomic, copy) NSString *himage;
@property (nonatomic, copy) NSString *bedtype;
@property (nonatomic, copy) NSString *checkin_time;
@property (nonatomic, copy) NSString *checkout_time;
@property (nonatomic, copy) NSString *convenience;
@property (nonatomic, copy) NSString *price_per;
@property (nonatomic, copy) NSString *mon_extrafee;
@property (nonatomic, copy) NSString *week_extrafee;
@property (nonatomic, assign) NSInteger unsub_strategy;
@property (nonatomic, copy) NSString *hlocation;


- (instancetype)initWithDic:(NSDictionary*)dic;
@end
