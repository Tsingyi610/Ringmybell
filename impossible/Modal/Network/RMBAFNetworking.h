//
//  RMBAFNetworking.h
//  impossible
//
//  Created by Blessed on 16/5/3.
//  Copyright © 2016年 ringmybell. All rights reserved.
//


#define kImageUploadPath @"http://192.168.0.123:8080/upload"
#define kImageUploadUserPath @"http://192.168.0.123:8080/upload/users"
#define kUserHeadImagePath @"http://192.168.0.123:8080/static/upload/users"
#define kIndexActivityPath @"http://192.168.0.123:8080/static/upload/activity"
#define kIndexCarousel @"http://192.168.0.123:8080/static/upload/carousel"
#define kHouseImagePath @"http://192.168.0.123:8080/static/upload/houses"

#import <Foundation/Foundation.h>

@interface RMBAFNetworking : NSObject
+ (instancetype)sharedInstance;

- (void)saveImageToServerWithFileName:(NSString*)imageName url:(NSString*)url method:(NSString*)method andPath:(NSString*)path completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)downloadUserHeadImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler;
- (void)downloadIndexActivityImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler;
- (void)downloadCarouselImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler;
- (void)downloadHouseImage:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id filePath))handler;
@end
