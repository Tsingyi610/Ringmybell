//
//  RMBUserInfo.m
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBUserInfo.h"

@implementation RMBUserInfo
- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        self.uname = [dic objectForKey:@"uname"];
        self.uid = [[dic objectForKey:@"uid"] intValue];
        self.ugender = [dic objectForKey:@"ugender"];
        self.umail = [dic objectForKey:@"umail"];
        self.udesc = [dic objectForKey:@"udesc"];
        self.uphone = [dic objectForKey:@"uphone"];
        self.utime = [dic objectForKey:@"utime"];
        self.uimageurl = [dic objectForKey:@"uimageurl"];
    }
    return self;
}
@end
