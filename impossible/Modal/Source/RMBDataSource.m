//
//  RMBDataSource.m
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBDataSource.h"

static RMBDataSource *g_dataSource = nil;

@implementation RMBDataSource

+ (instancetype)sharedInstance {
    @synchronized (self) {
        if (g_dataSource == nil) {
            g_dataSource = [[self alloc] init];
        }
    }
    return g_dataSource;
}

- (instancetype)init {
    if (self = [super init]) {
        self.convenienceArray = [NSArray array];
        self.houseListArray = [NSArray array];
        self.singleHouseDic = [NSDictionary dictionary];
        self.convenienceArraySelected = [NSArray array];
        self.myHouse = [NSArray array];
        self.myStep = [NSArray array];
        self.myComment = [NSArray array];
        self.defaultCollection = [NSArray array];
        self.customCollection = [NSArray array];
        self.customCollectionList = [NSArray array];
        self.wishlist = [NSArray array];
        self.payment =[NSArray array];
        self.optionalDetail = [NSDictionary dictionary];
        self.hotCity = [NSArray array];
        self.carouselArray = [NSArray array];
        self.monthlyThemeDic = [NSDictionary dictionary];
        self.threeActivity = [NSArray array];
        self.coverImage = [NSArray array];
        self.strategy = [NSDictionary dictionary];
        self.messageApplyid = [NSArray array];
        self.messageHouseinfo = [NSArray array];
        
    }
    return self;
}

@end
