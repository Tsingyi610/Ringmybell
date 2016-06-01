//
//  RMBActivityHouse.h
//  impossible
//
//  Created by Blessed on 16/5/17.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBActivityHouse : NSObject
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger htype;
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *uimage;
@property (nonatomic, copy) NSString *himage;
@property (nonatomic, copy) NSString *cityname;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
