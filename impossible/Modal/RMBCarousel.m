//
//  RMBCarousel.m
//  impossible
//
//  Created by Blessed on 16/5/18.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBCarousel.h"

@implementation RMBCarousel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        self.ca_title = [dic objectForKey:@"ca_title"];
        self.content = [dic objectForKey:@"content"];
        self.image = [dic objectForKey:@"image"];
    }
    return self;
}
    
@end
