//
//  RMBUtil.m
//  impossible
//
//  Created by Blessed on 16/4/12.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "RMBUtil.h"

@implementation RMBUtil
+(NSString*)getJsonStringFromObj:(id)obj
{
    if ([NSJSONSerialization isValidJSONObject:obj])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&error];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+(NSData*)getJsonDataFromObj:(id)obj
{
    if ([NSJSONSerialization isValidJSONObject:obj])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&error];
        
        return jsonData;
    }
    return nil;
}
@end
