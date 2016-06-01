//
//  RMBRequestManager.h
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBRequestManager : NSObject
+ (instancetype)sharedInstance;

- (void)getUserInfo:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getUserIDByUphone:(NSString*)uphone completionHandler:(void (^)(id data))handler;
- (void)changeLoginPassword:(NSInteger)uid oldPassword:(NSString*)old newPassword:(NSString*)upwd completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)changeUserInfo:(NSInteger)uid andContent:(NSString*)content withtype:(NSString*)type completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)beforeRegister:(NSString*)uphone completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)insertUserInfoByName:(NSString*)uname password:(NSString*)upwd phone:(NSString*)uphone andmail:(NSString*)umail completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)compareUserPassword:(NSString*)upwd andPhone:(NSString*)uphone completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)livedHouseInformation:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)myComments:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)addComment:(NSInteger)uid hid:(NSInteger)hid commentContent:(NSString*)content satisfaction:(NSInteger)satisfaction completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)myDefaultCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)myCustomCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)myCustomCollectionList:(NSInteger)ucid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)myWishlist:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)insertOrder:(NSInteger)uid hid:(NSInteger)hid orderid:(NSString*)order_id beginTime:(NSString*)begin_time endTime:(NSString*)end_time price:(NSInteger)total_price payment:(NSInteger)payment completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)insertConsult:(NSString*)order_id content:(NSString*)content completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)addFeedback:(NSInteger)uid content:(NSString*)content completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)addCollection:(NSString*)collectionName uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)addHouse2Collection:(NSInteger)ucid hid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)getCollectionHouseList:(NSInteger)ucid uid:(NSInteger)hid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)checkHouseIfContainsCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)getCollectionCoverImage:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)add2WishListWithHid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)changeHeadImage:(NSInteger)uid withImageName:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)lastComment:(NSInteger)hid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)changeOrderRemark:(NSString*)orderid remark:(NSInteger)remark completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)getCurrentRemark:(NSString*)orderid completionHandler:(void (^)(NSString *errMsg, id data))handler;

//dtag
- (void)dtagCustomCollection:(NSInteger)ucid creater:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)dtagSingleHouse:(NSInteger)ucid hid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)dtagWishList:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler;

- (void)getHouseConvenienceHandler:(void (^)(NSString *errMsg, id data))handler;
- (void)getHouseListBySearchCityName:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getSingleHouseProfileByHouseId:(NSInteger)hid comletionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getMainHouseInfomation:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)insertHouseMainSheet:(NSInteger)uid htype:(NSInteger)htype cityid:(NSInteger)cityid maxVisitors:(NSInteger)maxVisitors hroom:(NSInteger)hroom hbed:(NSInteger)hbed hbathroom:(NSInteger)hbathroom completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)updateHouseMinor:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)updateHouseOptional:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)updateHouseMain:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)updatePublishStatus:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getMyHouse:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getEditHouseInfor:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getPastOrderTime:(NSInteger)hid andBeginTime:(NSString*)time andEndTime:(NSString*)endtime completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getPaymentCompletionHandler:(void (^)(id data))handler;
- (void)getSingleOptionalDetail:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)updateHotCity:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getLatestHotCityListCompletionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getHouseStrategy:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getHouseRule:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getStrategyByhid:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler;


//index api
- (void)getCarouselCompletionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getMonthlyRecommendTheme:(NSString*)month completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getMonthlyRecommendHouseList:(NSString*)rid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getBottomThreeActivitiesCompletionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getBottomThreeActivityHouseList:(NSString*)acid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getLBSHouseList:(NSString*)cityid completionHandler:(void (^)(NSString* errMsg, id data))handler;

- (void)getBlurLocationByCityId:(NSInteger)cityid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)checkCityname:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getCityid:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler;


//message api
- (void)initMessageListByUid:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getLatestMessage:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getHouseByApplyID:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)addResponseMessage:(NSString*)applyid content:(NSString*)content completionHandler:(void (^)(NSString* errMsg, id data))handler;
- (void)getMessageContentByApplyid:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler;
@end
