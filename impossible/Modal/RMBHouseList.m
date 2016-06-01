//
//  RMBHouseList.m
//  impossible
//
//  Created by Blessed on 16/5/3.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBHouseList.h"

@implementation RMBHouseList

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        self.hid = [[dic objectForKey:@"hid"] integerValue];
        self.uid = [[dic objectForKey:@"uid"] integerValue];
        self.htype = [[dic objectForKey:@"htype"] integerValue];
        self.cityid = [[dic objectForKey:@"cityid"] integerValue];
        self.hname = [dic objectForKey:@"hname"];
        self.uimage = [dic objectForKey:@"uimage"];
        self.himage = [dic objectForKey:@"himage"];
    }
    return self;
}

@end
