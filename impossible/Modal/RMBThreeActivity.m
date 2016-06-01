//
//  RMBThreeActivity.m
//  impossible
//
//  Created by Blessed on 16/5/18.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBThreeActivity.h"

@implementation RMBThreeActivity
- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self == [super init]) {
        self.acid = [dic objectForKey:@"acid"];
        self.theme = [dic objectForKey:@"theme"];
        self.image = [dic objectForKey:@"image"];
    }
    return self;
}
@end
