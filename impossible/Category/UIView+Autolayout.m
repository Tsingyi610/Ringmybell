//
//  UIView+Autolayout.m
//  impossible
//
//  Created by Blessed on 16/2/10.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

-(UIView*)layout:(NSDictionary*)info{
    if (!info) {
        return self;
    }
    float tmp = 0;
    BOOL bl=[info objectForKey:@"left"]?YES:NO
    ,br=[info objectForKey:@"right"]?YES:NO
    ,bt=[info objectForKey:@"top"]?YES:NO
    ,bb=[info objectForKey:@"bottom"]?YES:NO
    ,bw=[info objectForKey:@"width"]?YES:NO
    ,bh=[info objectForKey:@"height"]?YES:NO;
    self.translatesAutoresizingMaskIntoConstraints=NO;
    
    if([info objectForKey:@"delete"]){
        NSString *del = [info objectForKey:@"delete"];
        NSArray*dels=[del componentsSeparatedByString:@" "];
        for (NSString*tag in dels) {
            if ([tag isEqualToString:@"top"]) {
                bt=YES;
            }else if ([tag isEqualToString:@"bottom"]){
                bb=YES;
            }else if ([tag isEqualToString:@"left"]){
                bl=YES;
            }else if ([tag isEqualToString:@"right"]){
                br=YES;
            }else if ([tag isEqualToString:@"width"]){
                bw=YES;
            }else if ([tag isEqualToString:@"height"]){
                bh=YES;
            }
        }
    }
    if (bl||br||bt||bb) {
        for (NSLayoutConstraint *constraint in self.superview.constraints) {
            if (constraint.firstItem==self||constraint.secondItem==self) {
                NSLayoutAttribute attr=constraint.firstItem==self?constraint.firstAttribute:constraint.secondAttribute;
                if (bl&&(attr==NSLayoutAttributeLeft||attr==NSLayoutAttributeLeading)) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (br&&(attr==NSLayoutAttributeRight||attr==NSLayoutAttributeTrailing)) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (bt&&attr==NSLayoutAttributeTop) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
                if (bb&&attr==NSLayoutAttributeBottom) {
                    [self.superview removeConstraint:constraint];
                    continue;
                }
            }
            
        }
    }
    if (bw||bh) {
        for (NSLayoutConstraint *constraint in self.constraints){
            if (constraint.firstItem==self||constraint.secondItem==self) {
                NSLayoutAttribute attr=constraint.firstItem==self?constraint.firstAttribute:constraint.secondAttribute;
                if (bw&&attr==NSLayoutAttributeWidth) {
                    [self removeConstraint:constraint];
                    continue;
                }
                if (bh&&attr==NSLayoutAttributeHeight) {
                    [self removeConstraint:constraint];
                    continue;
                }
            }
        }
    }
    if ([info objectForKey:@"width"]) {
        tmp = ((NSNumber*)[info objectForKey:@"width"]).floatValue;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tmp]];
    }
    if ([info objectForKey:@"height"]) {
        tmp = ((NSNumber*)[info objectForKey:@"height"]).floatValue;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tmp]];
    }
    if (!self.superview) {
        return self;
    }
    if ([info objectForKey:@"left"]) {
        tmp = ((NSNumber*)[info objectForKey:@"left"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:tmp]];
    }
    if ([info objectForKey:@"top"]) {
        tmp = ((NSNumber*)[info objectForKey:@"top"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:tmp]];
    }
    if ([info objectForKey:@"right"]) {
        tmp = ((NSNumber*)[info objectForKey:@"right"]).floatValue;
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:-tmp]];
    }
    if ([info objectForKey:@"bottom"]) {
        tmp = [[info objectForKey:@"bottom"] floatValue];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.superview
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:-tmp]];
    }
    return self;
}


@end
