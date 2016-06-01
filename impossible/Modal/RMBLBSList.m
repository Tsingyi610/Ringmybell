//
//  RMBLBSList.m
//  impossible
//
//  Created by Blessed on 16/5/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBLBSList.h"

@implementation RMBLBSList
- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        self.hid = [[dic objectForKey:@"hid"] integerValue];
        self.hname = [dic objectForKey:@"hname"];
        self.hlocation = [dic objectForKey:@"hlocation"];
        self.himage = [dic objectForKey:@"himage"];
        self.uimage = [dic objectForKey:@"uimage"];
        self.cityname = [dic objectForKey:@"cityname"];
        self.hdesc = [dic objectForKey:@"hdesc"];
    }
    return self;
}
@end
