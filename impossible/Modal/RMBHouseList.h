//
//  RMBHouseList.h
//  impossible
//
//  Created by Blessed on 16/5/3.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBHouseList : NSObject
@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger htype;
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *uimage;
@property (nonatomic, copy) NSString *himage;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
