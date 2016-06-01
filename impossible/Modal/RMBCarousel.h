//
//  RMBCarousel.h
//  impossible
//
//  Created by Blessed on 16/5/18.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBCarousel : NSObject
@property (nonatomic, copy) NSString *ca_title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
