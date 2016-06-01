//
//  UIColor+Extra.m
//  gjj51
//
//  Created by 魏裕群 on 15/8/2.
//  Copyright (c) 2015年 jianbing. All rights reserved.
//

#import "UIColor+Extra.h"
#define CHECK_CLR(x) if(x==NSNotFound)break

static NSMutableDictionary *sm_colors;

@implementation UIColor(Extra)

+(UIColor*)colorWithRGB:(NSString*)string{
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (sm_colors) {
        id col = [sm_colors objectForKey:string];
        if (col) {
            return col;
        }
    }else{
        sm_colors = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    do{
        static NSString*cs=@"0123456789ABCDEF";
        string = [string uppercaseString];
        if (string.length==4&&[string characterAtIndex:0]=='#') {
            NSInteger r = [cs rangeOfString:[string substringWithRange:NSMakeRange(1, 1)]].location;
            CHECK_CLR(r);
            NSInteger g = [cs rangeOfString:[string substringWithRange:NSMakeRange(2, 1)]].location;
            CHECK_CLR(g);
            NSInteger b = [cs rangeOfString:[string substringWithRange:NSMakeRange(3, 1)]].location;
            CHECK_CLR(b);
            UIColor *col = [UIColor colorWithRed:(float)r/15.0f green:(float)g/15.0f blue:(float)b/15.0f alpha:1];
            [sm_colors setObject:col forKey:string];
            return col;
        }else if (string.length==7&&[string characterAtIndex:0]=='#') {
            NSInteger tmp = [cs rangeOfString:[string substringWithRange:NSMakeRange(1, 1)]].location;
            CHECK_CLR(tmp);
            NSInteger r = [cs rangeOfString:[string substringWithRange:NSMakeRange(2, 1)]].location;
            CHECK_CLR(r);
            r+=16*tmp;
            tmp = [cs rangeOfString:[string substringWithRange:NSMakeRange(3, 1)]].location;
            CHECK_CLR(tmp);
            NSInteger g = [cs rangeOfString:[string substringWithRange:NSMakeRange(4, 1)]].location;
            CHECK_CLR(g);
            g+=16*tmp;
            tmp = [cs rangeOfString:[string substringWithRange:NSMakeRange(5, 1)]].location;
            CHECK_CLR(tmp);
            NSInteger b = [cs rangeOfString:[string substringWithRange:NSMakeRange(6, 1)]].location;
            CHECK_CLR(b);
            b+=16*tmp;
            UIColor *col = [UIColor colorWithRed:(CGFloat)r/255.0f green:(CGFloat)g/255.0f blue:(CGFloat)b/255.0f alpha:1];
            [sm_colors setObject:col forKey:string];
            return col;
        }
    }while (false);
    return nil;
}

@end
