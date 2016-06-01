//
//  RMBUserInfo.h
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBUserInfo : NSObject
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *uname;
@property (nonatomic, copy) NSString *ugender;
@property (nonatomic, copy) NSString *udesc;
@property (nonatomic, copy) NSString *umail;
@property (nonatomic, copy) NSString *uphone;
@property (nonatomic, copy) NSString *utime;
@property (nonatomic, copy) NSString *uimageurl;

- (instancetype)initWithDic:(NSDictionary*)dic;
@end
