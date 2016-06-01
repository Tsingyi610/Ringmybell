//
//  RMBThreeActivity.h
//  impossible
//
//  Created by Blessed on 16/5/18.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBThreeActivity : NSObject
@property (nonatomic, copy) NSString *acid;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
