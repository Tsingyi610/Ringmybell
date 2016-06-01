//
//  RMBSingleHouse.m
//  impossible
//
//  Created by Blessed on 16/5/4.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBSingleHouse.h"

@implementation RMBSingleHouse

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self == [super init]) {
        NSArray *type = @[@"整套房子",@"独立房间",@"合住房间"];
        self.hid = [[dic objectForKey:@"hid"] integerValue];
        self.uid = [[dic objectForKey:@"uid"] integerValue];
        self.htype = [type objectAtIndex:[[dic objectForKey:@"htype"]integerValue]-1];
        self.cityid = [[dic objectForKey:@"cityid"] integerValue];
        self.max_visitors = [[dic objectForKey:@"max_visitors"] integerValue];
        self.min_evenings = [[dic objectForKey:@"min_evenings"] integerValue];
        self.hroom = [[dic objectForKey:@"hroom"] integerValue];
        self.hbed = [[dic objectForKey:@"hbed"] integerValue];
        self.hbathroom = [[dic objectForKey:@"hbathroom"] integerValue];
        self.hname = [dic objectForKey:@"hname"];
        self.hdesc = [dic objectForKey:@"hdesc"];
        self.himage = [dic objectForKey:@"himage"];
        self.bedtype = [dic objectForKey:@"bedtype"];
        self.checkin_time = [dic objectForKey:@"checkin_time"];
        self.checkout_time = [dic objectForKey:@"checkout_time"];
        self.convenience = [dic objectForKey:@"convenience"];
        self.price_per = [dic objectForKey:@"price_per"];
        self.mon_extrafee = [dic objectForKey:@"mon_extrafee"];
        self.week_extrafee = [dic objectForKey:@"week_extrafee"];
        self.unsub_strategy = [[dic objectForKey:@"unsub_strategy"] integerValue];
        self.hlocation = [dic objectForKey:@"hlocation"];
    }
    return self;
}
@end
