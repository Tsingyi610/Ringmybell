//
//  UIView+Constraint.m
//  impossible
//
//  Created by Blessed on 16/4/19.
//  Copyright © 2016年 ringmybell. All rights reserved.
//

#import "UIView+Constraint.h"
#import <objc/runtime.h>

static char layoutKey;
static char animateLayoutKey;

@implementation UILayoutProperty

-(UILayoutProperty *)initWithLayout:(UILayout *)layout property:(NSLayoutAttribute)attribute{
    if (self = [super init]) {
        _layout = layout;
        _property = attribute;
    }
    return self;
}

-(UILayout *(^)(UILayoutProperty *,CGFloat))spacing{
    return ^id(UILayoutProperty *property,CGFloat constant){
        
        UIView *container = nil;
        UIView *view = self.layout.view;
        UIView *relatedView = property.layout.view;
        
        if (view.superview == relatedView.superview && view.superview != nil) {
            container = view.superview;
        }else if(view.superview == relatedView){
            container = relatedView;
        }else if (view == relatedView.superview){
            container = view;
        }
        [container addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:self.property
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:relatedView
                                                              attribute:property.property multiplier:1.0 constant:constant]];
        return self.layout;
    };
}

@end

@interface UILayout(){
    NSMutableArray *_relatedViewStack;
}
@end

@implementation UILayout

-(void)pushRelatedView{
    if (!_relatedViewStack) {
        _relatedViewStack = [NSMutableArray arrayWithCapacity:5];
    }
    if (_relatedView) {
        [_relatedViewStack addObject:_relatedView];
    }else{
        [_relatedViewStack addObject:[NSNull null]];
    }
}

-(void)popRelatedView{
    if (_relatedViewStack && _relatedViewStack.count) {
        id lastObject = [_relatedViewStack lastObject];
        if ([lastObject isKindOfClass:[UIView class]]) {
            _relatedView = lastObject;
        }
        [_relatedViewStack removeLastObject];
    }
}

-(UILayout *(^)(UIView *))equalTo{
    return ^id(UIView *view){
        [self pushRelatedView];
        _relatedView = view;
        return self;
    };
}

-(UILayout *(^)())end{
    return ^id(){
        [self popRelatedView];
        return self;
    };
}

-(UILayout *)initWithView:(UIView *)view{
    if (self = [super init]) {
        _view = view;
        _view.translatesAutoresizingMaskIntoConstraints = NO;
        _left   = [[UILayoutProperty alloc]initWithLayout:self property:NSLayoutAttributeLeading];
        _right  = [[UILayoutProperty alloc]initWithLayout:self property:NSLayoutAttributeTrailing];
        _bottom = [[UILayoutProperty alloc]initWithLayout:self property:NSLayoutAttributeBottom];
        _top    = [[UILayoutProperty alloc]initWithLayout:self property:NSLayoutAttributeTop];
    }
    return self;
}

-(UILayout *(^)(CGFloat))width{
    return ^id(CGFloat width){
        NSArray* constrains = _view.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth&&constraint.firstItem==_view) {
                constraint.constant = width;
                return self;
            }
        }
        [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
        return self;
    };
}

-(UILayout *(^)(CGFloat))height{
    return ^id(CGFloat height){
        NSArray* constrains = _view.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight&&constraint.firstItem==_view) {
                constraint.constant = height;
                return self;
            }
        }
        [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
        return self;
    };
}

-(UILayout *(^)(CGSize))size{
    return ^id(CGSize size){
        return self.width(size.width).height(size.height);
    };
}

-(UILayout *(^)(CGFloat))ratio{
    return ^id(CGFloat ratio){
        [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeHeight multiplier:ratio constant:0]];
        return self;
    };
}

-(UILayout *(^)())scaleWidth{
    return ^id(){
        return self.scaleSize(1,UILayoutAttributeWidth);
    };
}

-(UILayout *(^)())scaleHeight{
    return ^id(){
        return self.scaleSize(1,UILayoutAttributeHeight);
    };
}

-(UILayout *(^)(CGFloat, int))scaleSize{
    return ^id(CGFloat multipier,int attrs){
        BOOL bw = attrs & UILayoutAttributeWidth
        ,bh = attrs & UILayoutAttributeHeight;
        
        UIView *container = nil;
        UIView *relatedView = _relatedView?_relatedView:_view.superview;
        
        if (_view.superview == relatedView.superview && _view.superview != nil) {
            container = _view.superview;
        }else if(_view.superview == relatedView){
            container = relatedView;
        }else if (_view == relatedView.superview){
            container = _view;
        }
        if(container && (bw || bh)){
            BOOL obw = bw,obh = bh;
            
            NSArray* constraints = container.constraints;
            for (NSLayoutConstraint* constraint in constraints) {
                if (bw) {
                    if (constraint.secondAttribute == NSLayoutAttributeWidth && constraint.firstAttribute == NSLayoutAttributeWidth) {
                        if ((constraint.firstItem == _view && constraint.secondItem == relatedView)
                            ||(constraint.firstItem == relatedView && constraint.secondItem == _view)) {
                            [container removeConstraint:constraint];
                            bw = false;
                            if (!bh) {
                                break;
                            }
                        }
                    }
                }
                if (bh) {
                    if (constraint.secondAttribute == NSLayoutAttributeHeight && constraint.firstAttribute == NSLayoutAttributeHeight) {
                        if ((constraint.firstItem == _view && constraint.secondItem == relatedView)
                            ||(constraint.firstItem == relatedView && constraint.secondItem == _view)) {
                            [container removeConstraint:constraint];
                            bh = false;
                            if (!bw) {
                                break;
                            }
                        }
                    }
                }
            }
            if (obw) {
                if (multipier==0) {
                    [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeWidth multiplier:0 constant:0]];
                }else{
                    [container addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem: relatedView attribute:NSLayoutAttributeWidth multiplier:multipier constant:0]];
                }
            }
            if (obh) {
                if (multipier==0) {
                    [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: nil attribute:NSLayoutAttributeHeight multiplier:0 constant:0]];
                }else{
                    [container addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: relatedView attribute:NSLayoutAttributeHeight multiplier:multipier constant:0]];
                }
            }
        }
        return self;
    };
}

-(UILayout *(^)(CGFloat rate))scaleWidthToHeight{
    return ^id(CGFloat rate){
        [_view addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeHeight multiplier:rate constant:0]];
        return self;
    };
}

-(UILayout *(^)(CGPoint))position{
    return ^id(CGPoint point){
        self.remove(UILayoutAttributeLeft|UILayoutAttributeTop);
        [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_view.superview
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:point.x]];
        [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_view.superview
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:point.y]];
        return self;
    };
}
-(UILayout *(^)(CGFloat))x{
    return ^id(CGFloat x){
        return self.edge(UIEdgeInsetsMake(0, x, 0, 0),UILayoutAttributeLeft);
    };
}
-(UILayout *(^)(CGFloat))y{
    return ^id(CGFloat y){
        return self.edge(UIEdgeInsetsMake(y, 0, 0, 0),UILayoutAttributeTop);
    };
}

-(UILayout *(^)(UIEdgeInsets))insets{
    return ^id(UIEdgeInsets insets){
        return self.equalTo(nil).edge(insets,UILayoutAttributeLeft|UILayoutAttributeRight|UILayoutAttributeTop|UILayoutAttributeBottom).end();
    };
}

-(UILayout *(^)(UIEdgeInsets,int))edge{
    return ^id(UIEdgeInsets insets,int attrs){
        BOOL bl = attrs & UILayoutAttributeLeft
        ,br = attrs & UILayoutAttributeRight
        ,bt = attrs & UILayoutAttributeTop
        ,bb = attrs & UILayoutAttributeBottom;
        
        UIView *relatedView = _relatedView?_relatedView:_view.superview;
        
        self.remove(attrs&(UILayoutAttributeLeft|UILayoutAttributeRight|UILayoutAttributeTop|UILayoutAttributeRight));
        
        if (bl) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:relatedView
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:insets.left]];
        }
        
        if (bt) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:relatedView
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:insets.top]];
        }
        
        if (br) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:relatedView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0
                                                                         constant:-insets.right]];
        }
        
        if (bb) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:relatedView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-insets.bottom]];
        }
        return self;
    };
}

-(UILayout *(^)())fullHeight{
    return ^id(){
        return self.equalTo(nil).edge(UIEdgeInsetsZero,UILayoutAttributeTop|UILayoutAttributeBottom).end();
    };
}

-(UILayout *(^)())fullWidth{
    return ^id(){
        return self.equalTo(nil).edge(UIEdgeInsetsZero,UILayoutAttributeLeft|UILayoutAttributeRight).end();
    };
}

-(UILayout*(^)(NSInteger attrs))remove{
    return ^id(NSInteger attrs){
        BOOL bl = attrs & UILayoutAttributeLeft
        ,br = attrs & UILayoutAttributeRight
        ,bt = attrs & UILayoutAttributeTop
        ,bb = attrs & UILayoutAttributeBottom
        ,ch = attrs & UILayoutAttributeHorizontal
        ,cv = attrs & UILayoutAttributeVertical
        ,bw = attrs & UILayoutAttributeWidth
        ,bh = attrs & UILayoutAttributeHeight;
        if (bl||br||bt||bb||ch||cv) {
            for (NSLayoutConstraint *constraint in _view.superview.constraints) {
                if (constraint.firstItem==_view||constraint.secondItem==_view) {
                    NSLayoutAttribute attr=constraint.firstItem==_view?constraint.firstAttribute:constraint.secondAttribute;
                    if (bl&&(attr==NSLayoutAttributeLeft||attr==NSLayoutAttributeLeading)) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                    if (br&&(attr==NSLayoutAttributeRight||attr==NSLayoutAttributeTrailing)) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                    if (bt&&attr==NSLayoutAttributeTop) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                    if (bb&&attr==NSLayoutAttributeBottom) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                    if (ch&&attr==NSLayoutAttributeCenterX) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                    if (cv&&attr==NSLayoutAttributeCenterY) {
                        [_view.superview removeConstraint:constraint];
                        continue;
                    }
                }
                
            }
        }
        if (bw||bh) {
            for (NSLayoutConstraint *constraint in _view.constraints){
                if (constraint.firstItem==_view||constraint.secondItem==_view) {
                    NSLayoutAttribute attr=constraint.firstItem==_view?constraint.firstAttribute:constraint.secondAttribute;
                    if (bw&&attr==NSLayoutAttributeWidth) {
                        [_view removeConstraint:constraint];
                        continue;
                    }
                    if (bh&&attr==NSLayoutAttributeHeight) {
                        [_view removeConstraint:constraint];
                        continue;
                    }
                }
            }
        }
        return self;
    };
}

-(UILayout *(^)(int))center{
    return ^id(int attrs){
        UIView *relatedView = _relatedView?_relatedView:_view.superview;
        
        if(relatedView != _view.superview && relatedView.superview !=_view.superview){
            return self;
        }
        
        if (attrs & UILayoutAttributeHorizontal) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
        if (attrs & UILayoutAttributeVertical) {
            [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        }
        return self;
    };
}


-(UILayout *(^)(UIView *, CGFloat))follow{
    return ^id(UIView *view,CGFloat margin){
        return self.top.spacing(view.layout.bottom,margin);
    };
}

-(UILayout *(^)(UIView *, CGFloat))after{
    return ^id(UIView *view,CGFloat margin){
        return self.left.spacing(view.layout.right,margin);
    };
}

-(UILayout *(^)(UIView*))equalWidth{
    return ^id(UIView *view){
        [_view.superview addConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        return self;
    };
}

-(UILayout *(^)(UIView*))equalHeight{
    return ^id(UIView *view){
        NSLayoutConstraint *viewLayout = [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        viewLayout.priority = UILayoutPriorityRequired;
        [_view.superview addConstraint:viewLayout];
        return self;
    };
}

@end

#pragma mark animate static & define basic data type

typedef struct {
    CGFloat multiplier;
    CGFloat constant;
}AnimateNode;

@class AnimateLayoutElementGroup;
@class AnimateLayoutRenderer;

static float animationDuration = 0;
static AnimateLayoutElementGroup *currentAnimateElement;
static AnimateLayoutRenderer     *renderer;

#pragma mark AnimateLayoutElement

@protocol AnimateElement <NSObject>

-(void)update;

@end

@protocol AnimateLayoutElementDelegate <NSObject>

@optional
-(void)animateLayoutElementShouldWillStart:(id<AnimateElement>)sender;
-(void)animateLayoutElementDidFinish:(id<AnimateElement>)sender;

@end

@interface AnimateElement : NSObject <AnimateElement>{
@protected
    __weak id<AnimateLayoutElementDelegate> _delegate;
}

@property(nonatomic,weak)id<AnimateLayoutElementDelegate> delegate;

@end

@implementation AnimateElement

-(void)update{};

@end

@interface AnimateLayoutElement : AnimateElement

@property(nonatomic,retain)UIView *container;
@property(nonatomic,retain)NSLayoutConstraint *constraint;

@property(nonatomic,assign)AnimateNode origin;
@property(nonatomic,assign)AnimateNode target;

@property(nonatomic,assign)float duration;
@property(nonatomic,assign,readonly)float currentFrame;
@property(nonatomic,assign,readonly)float lastFrame;

@end

@implementation AnimateLayoutElement

-(void)setDuration:(float)duration{
    _duration = duration;
    _currentFrame = 0;
    _lastFrame = 60*duration;
}

-(void)update{
    CGFloat progress = _lastFrame==0?1:_currentFrame/_lastFrame;
    _currentFrame++;
    if(progress==0){
        if (_delegate && [_delegate respondsToSelector:@selector(animateLayoutElementShouldWillStart:)]) {
            [_delegate animateLayoutElementShouldWillStart:self];
        }
    }else if (progress>=1) {
        progress = 1;
        if (_delegate && [_delegate respondsToSelector:@selector(animateLayoutElementDidFinish:)]) {
            [_delegate animateLayoutElementDidFinish:self];
        }
    }
    if (_origin.multiplier == _target.multiplier) {
        _constraint.constant = _origin.constant+(_target.constant-_origin.constant)*progress;
        [_container layoutIfNeeded];
        return;
    }
    [_container removeConstraint:_constraint];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_constraint.firstItem
                                                                  attribute:_constraint.firstAttribute
                                                                  relatedBy:_constraint.relation
                                                                     toItem:_constraint.secondItem
                                                                  attribute:_constraint.secondAttribute
                                                                 multiplier:_origin.multiplier+(_target.multiplier-_origin.multiplier)*progress
                                                                   constant:_origin.constant+(_target.constant-_origin.constant)*progress];
    self.constraint = constraint;
    [_container addConstraint:constraint];
}

@end

#pragma mark AnimateLayoutElementGroup

@interface AnimateLayoutElementGroup : AnimateElement <AnimateLayoutElementDelegate>

@property(nonatomic,retain)NSMutableArray *elements;
@property(nonatomic,retain)NSMutableArray *willRemoveElements;

@end

@implementation AnimateLayoutElementGroup

-(instancetype)init{
    if (self = [super init]) {
        _elements = [NSMutableArray arrayWithCapacity:3];
        _willRemoveElements = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

-(void)addElement:(AnimateElement*)object{
    [_elements addObject:object];
    object.delegate = self;
}

-(void)update{
    for (AnimateElement *tmp in _elements) {
        [tmp update];
    }
    if (_willRemoveElements.count) {
        for (id tmp in _willRemoveElements) {
            [_elements removeObject:tmp];
        }
    }
    if (!_elements.count) {
        if (_delegate && [_delegate respondsToSelector:@selector(animateLayoutElementDidFinish:)]) {
            [_delegate animateLayoutElementDidFinish:self];
        }
    }
}

-(void)animateLayoutElementDidFinish:(id<AnimateElement>)sender{
    [_willRemoveElements addObject:sender];
}



@end

#pragma mark AnimateLayout

@interface AnimateLayout : UILayout

@end

@implementation AnimateLayout

-(void)addAnimate:(NSLayoutConstraint*)constraint container:(UIView*)container origin:(AnimateNode)origin target:(AnimateNode)target{
    if (currentAnimateElement) {
        AnimateLayoutElement *element = [[AnimateLayoutElement alloc]init];
        element.constraint = constraint;
        element.origin = origin;
        element.target = target;
        element.container = container;
        element.duration = animationDuration;
        [currentAnimateElement addElement:element];
    }
}

-(UILayout *(^)(CGFloat))height{
    return ^id(CGFloat height){
        [_view layoutIfNeeded];
        CGFloat originHeight = _view.frame.size.height;
        NSArray* constrains = _view.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight&&constraint.firstItem==_view) {
                if (constraint.multiplier==1) {
                    constraint.constant = originHeight;
                    [self addAnimate:constraint
                           container:_view
                              origin:(AnimateNode){.multiplier=1,.constant=originHeight}
                              target:(AnimateNode){.multiplier=1,.constant=height}];
                    return self;
                }else{
                    [_view removeConstraint:constraint];
                    break;
                }
            }
        }
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_view
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:originHeight];
        [_view addConstraint:constraint];
        [self addAnimate:constraint
               container:_view
                  origin:(AnimateNode){.multiplier=1,.constant=originHeight}
                  target:(AnimateNode){.multiplier=1,.constant=height}];
        return self;
    };
}

-(UILayout *(^)(CGFloat))y{
    return ^id(CGFloat y){
        [_view layoutIfNeeded];
        CGFloat originY = _view.frame.origin.y;
        
        self.remove(UILayoutAttributeTop);
        UIView *relatedView = _relatedView?_relatedView:_view.superview;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_view
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:relatedView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:originY];
        [_view.superview addConstraint:constraint];
        [self addAnimate:constraint
               container:_view
                  origin:(AnimateNode){.multiplier=1,.constant=originY}
                  target:(AnimateNode){.multiplier=1,.constant=y}];
        return self;
    };
}

@end

#pragma mark AnimateLayoutRenderer

@interface AnimateLayoutRenderer : NSObject <AnimateLayoutElementDelegate>

-(void)pushAnimation:(AnimateElement*)element;
-(void)commit;

@property(nonatomic,retain) CADisplayLink * animateTimer;
@property(nonatomic,retain) AnimateLayoutElementGroup * root;

@end

@implementation AnimateLayoutRenderer

-(instancetype)init{
    if (self = [super init]) {
        _root = [[AnimateLayoutElementGroup alloc]init];
        _root.delegate = self;
    }
    return self;
}

-(void)pushAnimation:(AnimateElement *)element{
    [_root addElement:element];
}

-(void)animateLayoutElementDidFinish:(id<AnimateElement>)sender{
    [_animateTimer invalidate];
    _animateTimer = nil;
}

-(void)commit{
    if(!_animateTimer){
        _animateTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateConstraintsAnimation:)];
        _animateTimer.frameInterval=1;
        [_animateTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

-(void)updateConstraintsAnimation:(id)sender{
    [_root update];
}

@end

#pragma mark UIView (Constraint)

@implementation UIView (Constraint)

+(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay constraint:(void (^)(void))animations completion:(void (^)(BOOL))completion{
    if (![NSThread isMainThread]) {
        return;
    }
    animationDuration = duration;
    currentAnimateElement = [[AnimateLayoutElementGroup alloc]init];
    animations();
    animationDuration = 0;
    if (!renderer) {
        renderer = [[AnimateLayoutRenderer alloc]init];
    }
    [renderer pushAnimation:currentAnimateElement];
    currentAnimateElement = nil;
    
    [renderer commit];
}

-(UILayout*)layout{
    char *key = animationDuration>0?&animateLayoutKey:&layoutKey;
    UILayout *layout = objc_getAssociatedObject(self, key);
    if (layout) {
        return layout;
    }
    layout = [[animationDuration>0?[AnimateLayout class]:[UILayout class] alloc]initWithView:self];
    objc_setAssociatedObject(self, key, layout, OBJC_ASSOCIATION_RETAIN);
    return layout;
}

-(void)removeAllSubviews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
