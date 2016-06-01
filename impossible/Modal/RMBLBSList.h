//
//  RMBLBSList.h
//  impossible
//
//  Created by Blessed on 16/5/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBLBSList : NSObject

@property (nonatomic, assign) NSInteger hid;
@property (nonatomic, copy) NSString *hname;
@property (nonatomic, copy) NSString *hdesc;
@property (nonatomic, copy) NSString *himage;
@property (nonatomic, copy) NSString *cityname;
@property (nonatomic, copy) NSString *hlocation;
@property (nonatomic, copy) NSString *uimage;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
