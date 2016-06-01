//
//  RMBRequestManager.m
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//
#define kUserDomain @"http://192.168.0.123:8080/api/"
#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#import "RMBRequestManager.h"
#import "RMBDataSource.h"
#import "RMBUtil.h"
#import "RMBUserInfo.h"
#import "RMBHouseList.h"
#import "RMBSingleHouse.h"
#import "RMBActivityHouse.h"
#import "RMBCarousel.h"
#import "RMBThreeActivity.h"
#import "RMBLBSList.h"

static RMBRequestManager *g_requestManager = nil;

@interface RMBRequestManager(){
    NSDictionary *temp;
}

@property (nonatomic, strong) NSString *getUser;
@property (nonatomic, strong) NSString *getHouse;

@end


@implementation RMBRequestManager

+ (instancetype)sharedInstance {
    @synchronized (self) {
        if (g_requestManager == nil) {
            g_requestManager = [[self alloc] init];
        }
    }
    return g_requestManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.getUser = [kUserDomain stringByAppendingString:@"user/"];
        self.getHouse = [kUserDomain stringByAppendingString:@"house/"];
    }
    return self;
}

- (NSURLRequest*)generateUserInterfaceRequest:(NSDictionary*)dic {
    NSString *param = [RMBUtil getJsonStringFromObj:dic];
    NSLog(@"%@",param);
    NSString *url_str = nil;
    if ([dic objectForKey:@"s"]) {
        url_str = [self.getUser stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"s"]]];
    } else if ([dic count]>1) {
        NSArray *values = [dic allValues];
        NSArray *keys = [dic allKeys];
        NSString *str = @"";
        for (int i=0; i<values.count; i++) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keys[i],values[i]]];
        }
        NSString *tp = [self.getUser stringByAppendingString:str
                   ];
        url_str = [tp substringToIndex:tp.length-1];
    } else {
        NSString *interface = [[dic allKeys] objectAtIndex:0];
        NSString *value = [[dic allValues] objectAtIndex:0];
        url_str = [self.getUser stringByAppendingString:[NSString stringWithFormat:@"%@=%@",interface,value]];
    }
    NSLog(@"get url = %@",url_str);
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSURLRequest*)generateHouseInterfaceRequest:(NSDictionary*)dic {
    NSString *param = [RMBUtil getJsonStringFromObj:dic];
    NSLog(@"%@",param);
    NSString *url_str = nil;
    if ([dic objectForKey:@"s"]) {
        url_str = [self.getHouse stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"s"]]];
    } else if ([dic objectForKey:@"i"]){
        url_str = [self.getHouse stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[dic objectForKey:@"i"],[dic objectForKey:@"p"]]];
    } else if ([dic count]>1) {
        NSArray *values = [dic allValues];
        NSArray *keys = [dic allKeys];
        NSString *str = @"";
        for (int i=0; i<values.count; i++) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keys[i],values[i]]];
        }
        NSString *tp = [self.getHouse stringByAppendingString:str];
        url_str = [tp substringToIndex:tp.length-1];
    } else {
        url_str = [self.getHouse stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[dic allKeys][0],[dic allValues][0]]];
    }
    NSLog(@"get url = %@",url_str);
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    return request;
}

-(void)sendRequest:(NSURLRequest*)request requestCompletionHandler:(void (^)(NSMutableDictionary* dic, NSString* errorMsg)) requestHandler
{
    //__weak typeof(self)bself = self;
    dispatch_block_t block = ^{
        
        NSError *error;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(data)
            {
                NSError * error = nil;
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                NSString *e = [json objectForKey:@"e"];
                
                if (e) {
                    return requestHandler(nil,e);
                }
                
                return requestHandler(json,nil);
            }
        });
    };
    
    //dispatch_release(block);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    
}

#pragma mark - 根据id获取用户信息
- (void)getUserInfo:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *id2str = [NSString stringWithFormat:@"%ld",(long)uid];
    NSDictionary *dic = @{@"uid":id2str};
    NSURLRequest *request = [self generateUserInterfaceRequest:dic];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg == nil) {
            NSDictionary *data_temp = [dic objectForKey:@"data"];
            RMBUserInfo *data = [[RMBUserInfo alloc] initWithDic:data_temp];
            if (handler) {
                handler(nil,data);
            }
        } else {
            handler(errorMsg,nil);
        }
    }];
}

#pragma mark - 获取便利设施
- (void)getHouseConvenienceHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *dic = @{@"s":@"convenience"};
    NSURLRequest *request = [self generateHouseInterfaceRequest:dic];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *convenienceArr = [NSMutableArray arrayWithCapacity:0];
            for (int i=1; i<=dic.count; i++) {
                NSString *item = [dic objectForKey:[NSString stringWithFormat:@"%d",i]];
                [convenienceArr addObject:item];
            }
            [RMBDataSource sharedInstance].convenienceArray = convenienceArr;
            if (handler) {
                handler(nil,[RMBDataSource sharedInstance].convenienceArray);
            }
        } else {
            handler(errorMsg,nil);
        }
    }];
}

#pragma mark - 用户注册
- (void)beforeRegister:(NSString*)uphone completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"uphone":uphone};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            if ([errorMsg isEqualToString:@"validation"]) {
                errorMsg = @"手机号码格式错误";
            } else {
                errorMsg = @"该手机号已注册，请登录";
            }
            handler(errorMsg,nil);
        } else {
            handler(nil,dic);
        }
    }];
}

- (void)insertUserInfoByName:(NSString*)uname password:(NSString*)upwd phone:(NSString*)uphone andmail:(NSString*)umail completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSData *data = [uname dataUsingEncoding:NSUTF8StringEncoding];
    NSString *name_encode = [data base64EncodedStringWithOptions:0];
    NSDictionary *dic = @{@"uname":name_encode,@"upwd":upwd,@"uphone":uphone,@"umail":umail};
    NSURLRequest *request = [self generateUserInterfaceRequest:dic];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSDictionary *loginDic = @{@"uphone":uphone,@"upwd":upwd};
            [[NSUserDefaults standardUserDefaults] setObject:loginDic forKey:@"login_ghost"];
            handler(nil,nil);
        } else {
            if ([errorMsg isEqualToString:@"validation"]) {
                errorMsg = @"手机号码格式错误";
            } else {
                errorMsg = @"注册失败";
            }
            handler(errorMsg,nil);
        }
    }];
}

#pragma mark - 用户登录
- (void)compareUserPassword:(NSString*)upwd andPhone:(NSString*)uphone completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *login_dic = @{@"uphone":uphone,@"upwd":upwd};
    NSURLRequest *request = [self generateUserInterfaceRequest:login_dic];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            if ([errorMsg isEqualToString:@"not register"]) {
                errorMsg = @"该用户未注册";
            } else if ([errorMsg isEqualToString:@"validation"]) {
                errorMsg = @"手机号码格式错误";
            } else {
                errorMsg = @"账号密码错误";
            }
            handler(errorMsg,nil);
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:login_dic forKey:@"login_ghost"];
            handler(nil,dic);
        }
    }];
}

#pragma mark - 修改登录密码
- (void)changeLoginPassword:(NSInteger)uid oldPassword:(NSString*)old newPassword:(NSString*)upwd completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"uid":[NSString stringWithFormat:@"%lu",uid],@"upwd":old,@"newPwd":upwd};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
    
}

#pragma mark - 获取用户通行ID
- (void)getUserIDByUphone:(NSString*)uphone completionHandler:(void (^)(id data))handler {
    NSDictionary *param = @{@"getid":uphone};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        [RMBDataSource sharedInstance].pass = [[dic objectForKey:@"id"] integerValue];
        handler([dic objectForKey:@"id"]);
    }];
}

#pragma mark - 修改个人信息
- (void)changeUserInfo:(NSInteger)uid andContent:(NSString *)content withtype:(NSString *)type completionHandler:(void (^)(NSString *, id))handler {
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *content_encode = [data base64EncodedStringWithOptions:0];
    NSString *attribute = [NSString stringWithFormat:@"change%@",type];
    NSDictionary *param = @{attribute:content_encode,@"uid":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 修改头像
- (void)changeHeadImage:(NSInteger)uid withImageName:(NSString*)imageName completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"changeimage":imageName,@"uid":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 房源列表信息获取
- (void)getHouseListBySearchCityName:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"cityname":urlencode};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSMutableArray *houseArr = [NSMutableArray arrayWithCapacity:0];
            NSArray *temp_data = [dic objectForKey:@"data"];
            for (NSMutableDictionary *item in temp_data) {
                RMBHouseList *house = [[RMBHouseList alloc] initWithDic:item];
                [houseArr addObject:house];
            }
            [RMBDataSource sharedInstance].houseListArray = houseArr;
            handler(nil,houseArr);
        }
    }];
}

#pragma mark - 单个房源信息
- (void)getSingleHouseProfileByHouseId:(NSInteger)hid comletionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *temp_data = [dic objectForKey:@"data"];
            RMBSingleHouse *house = [[RMBSingleHouse alloc] initWithDic:temp_data];
            [RMBDataSource sharedInstance].singleHouseDic = temp_data;
            handler(nil,house);
        }
    }];
}

#pragma mark - 新建房源Main以及其他表的空白信息条目添加
- (void)insertHouseMainSheet:(NSInteger)uid htype:(NSInteger)htype cityid:(NSInteger)cityid maxVisitors:(NSInteger)maxVisitors hroom:(NSInteger)hroom hbed:(NSInteger)hbed hbathroom:(NSInteger)hbathroom completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"uid":[NSString stringWithFormat:@"%lu",uid],@"htype":[NSString stringWithFormat:@"%lu",htype],@"cityid":[NSString stringWithFormat:@"%lu",cityid],@"max_visitors":[NSString stringWithFormat:@"%lu",maxVisitors],@"hroom":[NSString stringWithFormat:@"%lu",hroom],@"hbed":[NSString stringWithFormat:@"%lu",hbed],@"hbathroom":[NSString stringWithFormat:@"%lu",hbathroom]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            [RMBDataSource sharedInstance].hid = [[dic objectForKey:@"hid"] integerValue];
            [RMBDataSource sharedInstance].hname = @"";
            [RMBDataSource sharedInstance].hdesc = @"";
            [RMBDataSource sharedInstance].hlocation = @"";
            [RMBDataSource sharedInstance].price_per = 0;
            handler(nil,[dic objectForKey:@"hid"]);
        }
    }];
}

#pragma mark - 修改minor相关信息
- (void)updateHouseMinor:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([value isEqualToString:@""]) {
        NSDictionary *param = @{@"minorarg":argument,@"hid":[NSString stringWithFormat:@"%lu",hid]};
        NSURLRequest *request = [self generateHouseInterfaceRequest:param];
        [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
            if (errorMsg) {
                handler(errorMsg,nil);
            } else {
                handler(nil,[dic objectForKey:@"s"]);
            }
        }];
    } else {
        NSDictionary *param = @{@"minorarg":argument,@"value":urlencode,@"hid":[NSString stringWithFormat:@"%lu",hid]};
        NSURLRequest *request = [self generateHouseInterfaceRequest:param];
        [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
            if (errorMsg) {
                handler(errorMsg,nil);
            } else {
                handler(nil,[dic objectForKey:@"s"]);
            }
        }];
    }
    
}

- (void)updateHouseOptional:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"optionalarg":argument,@"value":urlencode,@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

- (void)updateHouseMain:(NSInteger)hid arg:(NSString*)argument andValue:(NSString*)value completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"mainarg":argument,@"value":value,@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 我的足迹
- (void)livedHouseInformation:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"step":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].myStep = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 我的评论记录
- (void)myComments:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"userComment":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].myComment = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 添加评论
- (void)addComment:(NSInteger)uid hid:(NSInteger)hid commentContent:(NSString*)content satisfaction:(NSInteger)satisfaction completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSString *urlencode = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"comment":[NSString stringWithFormat:@"%lu",uid],@"hid":[NSString stringWithFormat:@"%lu",hid],@"content":urlencode,@"satisfaction":[NSString stringWithFormat:@"%lu",satisfaction]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 我的默认收藏
- (void)myDefaultCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"defaultCollection":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].defaultCollection = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 我的自定义收藏列表
- (void)myCustomCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"customCollection":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].customCollection = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 获取自定义收藏封面图片
- (void)getCollectionCoverImage:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"customCover":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].coverImage = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 我的自定义收藏列表详细  depressed!!!!!!!!!
//- (void)myCustomCollectionList:(NSInteger)ucid completionHandler:(void (^)(NSString *errMsg, id data))handler {
//    NSDictionary *param = @{@"customCollectionList":[NSString stringWithFormat:@"%lu",ucid]};
//    NSURLRequest *request = [self generateUserInterfaceRequest:param];
//    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
//        if (errorMsg) {
//            if (errorMsg) {
//                handler(errorMsg,nil);
//            } else {
//                NSArray *info = [dic objectForKey:@"data"];
//                [RMBDataSource sharedInstance].customCollectionList = info;
//                handler(nil,info);
//            }
//        }
//    }];
//}

#pragma mark - 心愿单列表
- (void)myWishlist:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"wishlist":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].wishlist = info;
            handler(nil,info);
        }
    }];
}

#pragma mark - 添加心愿单
- (void)add2WishListWithHid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"insertwishlist":[NSString stringWithFormat:@"%lu",uid],@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 心愿单添加删除标记
- (void)dtagWishList:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"dtagwishlist":[NSString stringWithFormat:@"%lu",uid],@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 新建一个初始未确认订单
- (void)insertOrder:(NSInteger)uid hid:(NSInteger)hid orderid:(NSString*)order_id beginTime:(NSString*)begin_time endTime:(NSString*)end_time price:(NSInteger)total_price payment:(NSInteger)payment completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"order":order_id,@"uid":[NSString stringWithFormat:@"%lu",uid],@"hid":[NSString stringWithFormat:@"%lu",hid],@"begintime":begin_time,@"endtime":end_time,@"price":[NSString stringWithFormat:@"%lu",total_price],@"payment":[NSString stringWithFormat:@"%lu",payment]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 检查预定时间是否符合条件
- (void)getPastOrderTime:(NSInteger)hid andBeginTime:(NSString*)time andEndTime:(NSString*)endtime completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"ordertime":[NSString stringWithFormat:@"%lu",hid],@"begintime":time,@"endtime":endtime};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - Payment
- (void)getPaymentCompletionHandler:(void (^)(id data))handler {
    NSURLRequest *request = [self generateHouseInterfaceRequest:@{@"s":@"payment"}];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].payment = info;
            handler(info);
        }
    }];
}

#pragma mark - 添加反馈信息
- (void)addFeedback:(NSInteger)uid content:(NSString*)content completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSString *urlencode = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"uid":[NSString stringWithFormat:@"%lu",uid],@"fcontent":urlencode};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}


#pragma mark - 添加房源收藏记录
- (void)addHouse2Collection:(NSInteger)ucid hid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"ucid":[NSString stringWithFormat:@"%lu",ucid],@"uid":[NSString stringWithFormat:@"%lu",uid],@"hid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 添加自定义收藏列表
- (void)addCollection:(NSString*)collectionName uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSString *urlencode = [collectionName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"createCC":[NSString stringWithFormat:@"%lu",uid],@"cname":urlencode};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 获取单个收藏列表中的房源具体信息
- (void)getCollectionHouseList:(NSInteger)ucid uid:(NSInteger)hid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"getclist":[NSString stringWithFormat:@"%lu",ucid],@"uid":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            errorMsg = @"该收藏清单中还没您收藏的房源";
            handler(errorMsg,nil);
        } else {
            NSArray *array = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].customCollectionList = array;
            handler(nil,array);
        }
    }];
}

#pragma mark - 检查该房源是否被该用户收藏
- (void)checkHouseIfContainsCollection:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"allhidbyuid":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            handler(nil, info);
        }
    }];
}


#pragma mark - 修改自定义收藏列表的删除标记（以及该列表下的所有房源）
- (void)dtagCustomCollection:(NSInteger)ucid creater:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"uid":[NSString stringWithFormat:@"%lu",uid],@"dtagCC":[NSString stringWithFormat:@"%lu",ucid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 修改单个房源的收藏删除标记
- (void)dtagSingleHouse:(NSInteger)ucid hid:(NSInteger)hid uid:(NSInteger)uid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"hid":[NSString stringWithFormat:@"%lu",hid],@"dtagCC":[NSString stringWithFormat:@"%lu",ucid],@"uid":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil, [dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 获取单个房源的可选信息内容
- (void)getSingleOptionalDetail:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"optional":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            [RMBDataSource sharedInstance].optionalDetail = [dic objectForKey:@"data"];
            handler(nil,[dic objectForKey:@"data"]);
        }
    }];
}

#pragma mark - 更新发布状态
- (void)updatePublishStatus:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"topublish":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 我的收藏
- (void)getMyHouse:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"own":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].myHouse = info;
            handler(nil,info);
        }
    }];
}

- (void)getMainHouseInfomation:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"gethidmain":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *info = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].bedroom = [NSString stringWithFormat:@"%@",[info objectForKey:@"hroom"]];
            [RMBDataSource sharedInstance].bed = [NSString stringWithFormat:@"%@",[info objectForKey:@"hbed"]];
            [RMBDataSource sharedInstance].bathroom = [NSString stringWithFormat:@"%@",[info objectForKey:@"hbathroom"]];
            [RMBDataSource sharedInstance].maxVisitors = [NSString stringWithFormat:@"%@",[info objectForKey:@"max_visitors"]];
            [RMBDataSource sharedInstance].minEvenings = [NSString stringWithFormat:@"%@",[info objectForKey:@"min_evenings"]];
            [RMBDataSource sharedInstance].htype = [[info objectForKey:@"htype"] integerValue];
        }
    }];
}

//从我的房源入口进行修改发布房源信息
- (void)getEditHouseInfor:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"tocomplete":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *info = [dic objectForKey:@"data"];
            if ([[info objectForKey:@"hname"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].hname = @"";
            } else {
                [RMBDataSource sharedInstance].hname = [info objectForKey:@"hname"];
            }
            if ([[info objectForKey:@"hdesc"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].hdesc = @"";
            } else {
                [RMBDataSource sharedInstance].hdesc = [info objectForKey:@"hdesc"];
            }
            if ([[info objectForKey:@"hlocation"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].hlocation = @"";
            } else {
                [RMBDataSource sharedInstance].hlocation = [info objectForKey:@"hlocation"];
            }
            if ([[info objectForKey:@"price_per"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].price_per = 0;
            } else {
                [RMBDataSource sharedInstance].price_per = [[info objectForKey:@"price_per"] integerValue];
            }
            if ([[info objectForKey:@"visitor_limited"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].visitor_limited = @"";
            } else {
                [RMBDataSource sharedInstance].visitor_limited = [info objectForKey:@"visitor_limited"];
            }
            if ([[info objectForKey:@"transport"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].transport = @"";
            } else {
                [RMBDataSource sharedInstance].transport = [info objectForKey:@"transport"];
            }
            if ([[info objectForKey:@"rule"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].rule = @"";
            } else {
                [RMBDataSource sharedInstance].rule = [info objectForKey:@"rule"];
            }
            if ([[info objectForKey:@"others"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].others = @"";
            } else {
                [RMBDataSource sharedInstance].others = [info objectForKey:@"others"];
            }
            if ([[info objectForKey:@"block_style"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].block_style = @"";
            } else {
                [RMBDataSource sharedInstance].block_style = [info objectForKey:@"block_style"];
            }
            [RMBDataSource sharedInstance].bedroom = [NSString stringWithFormat:@"%@",[info objectForKey:@"hroom"]];
            [RMBDataSource sharedInstance].bed = [NSString stringWithFormat:@"%@",[info objectForKey:@"hbed"]];
            [RMBDataSource sharedInstance].bathroom = [NSString stringWithFormat:@"%@",[info objectForKey:@"hbathroom"]];
            [RMBDataSource sharedInstance].maxVisitors = [NSString stringWithFormat:@"%@",[info objectForKey:@"max_visitors"]];
            [RMBDataSource sharedInstance].minEvenings = [NSString stringWithFormat:@"%@",[info objectForKey:@"min_evenings"]];
            [RMBDataSource sharedInstance].htype = [[info objectForKey:@"htype"] integerValue];
            if ([[info objectForKey:@"hconvenience"] isKindOfClass:[NSNull class]]) {
                [RMBDataSource sharedInstance].convenienceArraySelected = @[];
            } else {
                [RMBDataSource sharedInstance].convenienceArraySelected = [[info objectForKey:@"hconvenience"] componentsSeparatedByString:@"."];
            }
            [RMBDataSource sharedInstance].himage = [info objectForKey:@"himage"];
            handler(nil,info);
        }
    }];
}

#pragma mark - 模糊地址
- (void)getBlurLocationByCityId:(NSInteger)cityid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"locationbycityid":[NSString stringWithFormat:@"%lu",cityid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *temp_data = [dic objectForKey:@"data"];
            [RMBDataSource sharedInstance].cityname = [temp_data objectForKey:@"cityname"];
            [RMBDataSource sharedInstance].province = [temp_data objectForKey:@"province"];
            handler(nil,temp_data);
        }
    }];
}

#pragma mark - 检查城市是否被系统支持
- (void)checkCityname:(NSString *)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"checkcity":urlencode};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSInteger cityid = [[dic objectForKey:@"data"] integerValue];
            [RMBDataSource sharedInstance].cityid = cityid;
            handler(nil,[dic objectForKey:@"data"]);
        }
    }];
}

- (void)getCityid:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"checkcity":urlencode};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(@"0",nil);
        } else {
            handler(nil,[dic objectForKey:@"data"]);
        }
    }];
}

#pragma mark - 更新城市热点
- (void)updateHotCity:(NSString*)cityname completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"hot":urlencode};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        } else {
            handler(errorMsg,nil);
        }
    }];
}

#pragma mark - 获取最新的城市热度数组
- (void)getLatestHotCityListCompletionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"s":@"gethot"};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            [RMBDataSource sharedInstance].hotCity = [dic objectForKey:@"data"];
            handler(nil,[dic objectForKey:@"data"]);
        }
    }];
}

#pragma mark - 重用api
- (void)getHouseStrategy:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"extrafee":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            [RMBDataSource sharedInstance].strategy = [dic objectForKey:@"data"];
            handler(nil,[dic objectForKey:@"data"]);
        } else {
            handler(errorMsg,nil);
        }
    }];
}

- (void)getHouseRule:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"tocomplete":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *info = [dic objectForKey:@"data"];
            if ([[info objectForKey:@"rule"] isKindOfClass:[NSNull class]]) {
                handler(nil,@"无");
            } else {
                handler(nil, [info objectForKey:@"rule"]);
            }
        }
    }];
}

- (void)getStrategyByhid:(NSInteger)hid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"strategy":[NSString stringWithFormat:@"%lu",hid]};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"data"]);
        } else {
            handler(errorMsg,nil);
        }
    }];
}

//index api
#pragma mark - 首页轮播图
- (void)getCarouselCompletionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSURLRequest *request = [self generateUserInterfaceRequest:@{@"s":@"carousel"}];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *element in [dic objectForKey:@"data"]) {
                RMBCarousel *carousel = [[RMBCarousel alloc] initWithDic:element];
                [array addObject:carousel];
            }
            handler(nil,array);
        }
    }];
}

#pragma mark - 获取每月主题
- (void)getMonthlyRecommendTheme:(NSString*)month completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"monthly":month};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            [RMBDataSource sharedInstance].monthlyThemeDic = [[dic objectForKey:@"data"] objectAtIndex:0];
            handler(nil, [dic objectForKey:@"data"]);
        }
    }];
}

#pragma mark - 获取每月房源列表
- (void)getMonthlyRecommendHouseList:(NSString*)rid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"rid":rid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *element in [dic objectForKey:@"data"]) {
                RMBActivityHouse *list = [[RMBActivityHouse alloc] initWithDic:element];
                [data addObject:list];
            }
            handler(nil,data);
        }
    }];
}

#pragma mark - 获取底部三个活动信息
- (void)getBottomThreeActivitiesCompletionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSURLRequest *request = [self generateUserInterfaceRequest:@{@"s":@"activity"}];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *element in [dic objectForKey:@"data"]) {
                RMBThreeActivity *list = [[RMBThreeActivity alloc] initWithDic:element];
                [array addObject:list];
            }
            handler(nil,array);
        }
    }];
}

#pragma mark - 获取活动信息房源列表
- (void)getBottomThreeActivityHouseList:(NSString*)acid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"acid":acid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *element in [dic objectForKey:@"data"]) {
                RMBActivityHouse *list = [[RMBActivityHouse alloc] initWithDic:element];
                [array addObject:list];
            }
            handler(nil,array);
        }
    }];
}

#pragma mark - 获取附近房源信息
- (void)getLBSHouseList:(NSString*)cityid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"lbs":cityid};
    NSURLRequest *request = [self generateHouseInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            if ([errorMsg isEqualToString:@"notallowed"]) {
                errorMsg = @"您所在的城市未在支持列表内";
            } else {
                errorMsg = @"您所在的城市暂无房源登记";
            }
            handler(errorMsg,nil);
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary  *element in [dic objectForKey:@"data"]) {
                RMBLBSList *list = [[RMBLBSList alloc] initWithDic:element];
                [array addObject:list];
            }
            handler(nil,array);
        }
    }];
}


//message api

#pragma mark - 获取信息列表的订单编号
- (void)initMessageListByUid:(NSInteger)uid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"applylist":[NSString stringWithFormat:@"%lu",uid]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSArray *applyidArr = [dic objectForKey:@"data"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSString *element in applyidArr) {
                [array addObject:element];
            }
            [RMBDataSource sharedInstance].messageApplyid = array;
            handler(nil,applyidArr);
        }
    }];
}

#pragma mark - 在创建新订单时新建一条留言记录 & 用户添加咨询信息
- (void)insertConsult:(NSString*)order_id content:(NSString*)content completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSString *urlencode = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"apply":order_id,@"consult":urlencode};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 房东添加信息
- (void)addResponseMessage:(NSString*)applyid content:(NSString*)content completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSString *urlencode = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"apply":applyid,@"response":urlencode};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

#pragma mark - 获取最新的回复记录
- (void)getLatestMessage:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"applycontent":applyid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSString *lastContent = @"";
            NSArray *orderContent = [dic objectForKey:@"c"];
            NSArray *responseContent = [dic objectForKey:@"r"];
            if ([[dic objectForKey:@"r"] isKindOfClass:[NSString class]] && [[dic objectForKey:@"r"]isEqualToString:@"nodata"]) {
                lastContent = [[orderContent lastObject] objectForKey:@"content"];
                handler(nil,lastContent);
            } else {
                NSString *orderLastTime = [[orderContent lastObject] objectForKey:@"time"];
                NSString *responseLastTime = [[responseContent lastObject] objectForKey:@"time"];
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateStyle:NSDateFormatterFullStyle];
                NSDate *orderDate = [format dateFromString:orderLastTime];
                NSDate *responseDate = [format dateFromString:responseLastTime];
                NSInteger orderTime = [orderDate timeIntervalSince1970];
                NSInteger responseTime = [responseDate timeIntervalSince1970];
                
                if (orderTime > responseTime) {
                    lastContent = [[orderContent lastObject] objectForKey:@"content"];
                } else {
                    lastContent = [[responseContent lastObject] objectForKey:@"content"];
                }
                handler(nil,lastContent);
            }
            
        }
    }];
}

#pragma mark - 获取单个id的所有信息
- (void)getMessageContentByApplyid:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"applycontent":applyid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            NSMutableArray *messages = [NSMutableArray arrayWithCapacity:0];
            
            NSArray *orderContent = [dic objectForKey:@"c"];
            NSArray *responseContent = [dic objectForKey:@"r"];
            if ([[dic objectForKey:@"r"] isKindOfClass:[NSString class]] && [[dic objectForKey:@"r"]isEqualToString:@"nodata"]) {
                handler(nil,orderContent);
            } else {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateStyle:NSDateFormatterFullStyle];
                
                for (NSDictionary *element in orderContent) {
                    [messages addObject:element];
                }
                for (NSDictionary *element in responseContent) {
                    [messages addObject:element];
                }
                
                NSArray *sortArray = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
                NSArray *sorted = [messages sortedArrayUsingDescriptors:sortArray];
                
                handler(nil,sorted);
            }
        }
    }];
}

#pragma mark - 根据applyid获取房源数据
- (void)getHouseByApplyID:(NSString*)applyid completionHandler:(void (^)(NSString* errMsg, id data))handler {
    NSDictionary *param = @{@"applyhouse":applyid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            [RMBDataSource sharedInstance].messageHouseinfo = [dic objectForKey:@"data"];
            handler(nil,[dic objectForKey:@"data"]);
        }
    }];
}

- (void)lastComment:(NSInteger)hid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSURLRequest *request = [self generateUserInterfaceRequest:@{@"lastComment":[NSString stringWithFormat:@"%lu",hid]}];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSDictionary *info = [dic objectForKey:@"data"];
            handler(nil,info);
        }
    }];
}

- (void)changeOrderRemark:(NSString*)orderid remark:(NSInteger)remark completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"orderid":orderid,@"remark":[NSString stringWithFormat:@"%lu",remark]};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (!errorMsg) {
            handler(nil,[dic objectForKey:@"s"]);
        }
    }];
}

- (void)getCurrentRemark:(NSString*)orderid completionHandler:(void (^)(NSString *errMsg, id data))handler {
    NSDictionary *param = @{@"currentRemark":orderid};
    NSURLRequest *request = [self generateUserInterfaceRequest:param];
    [self sendRequest:request requestCompletionHandler:^(NSMutableDictionary *dic, NSString *errorMsg) {
        if (errorMsg) {
            handler(errorMsg,nil);
        } else {
            NSString *remark = [dic objectForKey:@"remark"];
            handler(nil,remark);
        }
    }];
}
@end
