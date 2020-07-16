//
//  Indicator.h
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class AnimatedPageControl;
typedef enum {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
}ScrollDirection;


@interface Indicator : CALayer

@property (nonatomic, assign) CGFloat indicatorSize;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGRect currentRect;
@property (nonatomic, assign) CGFloat lastContentOffSet;
@property (nonatomic, assign) ScrollDirection scrollDirection;


-(void)animatedIndicatorScrollView:(UIScrollView *)scrollView andIndicator:(AnimatedPageControl *)pageControl;

- (void)restoreAnimation:(id)howmanydistance;
@end
