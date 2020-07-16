//
//  GooeyCircle.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "GooeyCircle.h"
#import <QuartzCore/QuartzCore.h>
#import "SpringLayerAnimation.h"
#import "AnimatedPageControl.h"

@interface GooeyCircle ()

@property (nonatomic, assign) CGFloat fator;

@end

@implementation GooeyCircle{
    
     BOOL beginGooeyAnim;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (instancetype)initWithLayer:(GooeyCircle *)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        
        self.indicatorSize = layer.indicatorSize;
        self.indicatorColor = layer.indicatorColor;
        self.currentRect = layer.currentRect;
        self.lastContentOffSet = layer.lastContentOffSet;
        self.scrollDirection = layer.scrollDirection;
        self.fator = layer.fator;
        
    }
    return self;
}

+(BOOL)needsDisplayForKey:(NSString *)key{
    
    if ([key isEqualToString:@"fator"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx{
    
    CGFloat offset = self.currentRect.size.width / 3.6;
    CGPoint rectCenter = CGPointMake(self.currentRect.origin.x + self.currentRect.size.width / 2, self.currentRect.origin.y + self.currentRect.size.height / 2);
    
    //8个控制点
    CGFloat extra = (self.currentRect.size.width * 2 / 5) * _fator;
    CGPoint pointA = CGPointMake(rectCenter.x, self.currentRect.origin.y + extra);
    CGPoint pointB = CGPointMake(
                                 self.scrollDirection == ScrollDirectionLeft
                                 ? rectCenter.x + self.currentRect.size.width / 2
                                 : rectCenter.x + self.currentRect.size.width / 2 + extra * 2,
                                 rectCenter.y);
    CGPoint pointC = CGPointMake(
                                 rectCenter.x, rectCenter.y + self.currentRect.size.height / 2 - extra);
    CGPoint pointD = CGPointMake(self.scrollDirection == ScrollDirectionLeft
                                 ? self.currentRect.origin.x - extra * 2
                                 : self.currentRect.origin.x,
                                 rectCenter.y);
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
    
    CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    // 更新界面
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor);
    CGContextFillPath(ctx);

}

-(void)animatedIndicatorScrollView:(UIScrollView *)scrollView andIndicator:(AnimatedPageControl *)pageControl{
    
    if ((scrollView.contentOffset.x - self.lastContentOffSet) >= 0 &&
        (scrollView.contentOffset.x - self.lastContentOffSet) <=
        (scrollView.frame.size.width) / 2) {
        self.scrollDirection = ScrollDirectionLeft;
    } else if ((scrollView.contentOffset.x - self.lastContentOffSet) <= 0 &&
               (scrollView.contentOffset.x - self.lastContentOffSet) >=
               -(scrollView.frame.size.width) / 2) {
        self.scrollDirection = ScrollDirectionRight;
    }
    
    if (!beginGooeyAnim) {
        _fator = MIN(
                      1, MAX(0, (ABS(scrollView.contentOffset.x - self.lastContentOffSet) /
                                 scrollView.frame.size.width)));
    }
    CGFloat originX = (scrollView.contentOffset.x / scrollView.frame.size.width) *
    (pageControl.frame.size.width / (pageControl.pageCount - 1));
    if (originX - self.indicatorSize / 2 <= 0) {
        self.currentRect =
        CGRectMake(0, self.frame.size.height / 2 - self.indicatorSize / 2,
                   self.indicatorSize, self.indicatorSize);
    } else if ((originX - self.indicatorSize / 2) >=
               self.frame.size.width - self.indicatorSize) {
        self.currentRect =
        CGRectMake(self.frame.size.width - self.indicatorSize,
                   self.frame.size.height / 2 - self.indicatorSize / 2,
                   self.indicatorSize, self.indicatorSize);
    } else {
        self.currentRect =
        CGRectMake(originX - self.indicatorSize / 2,
                   self.frame.size.height / 2 - self.indicatorSize / 2,
                   self.indicatorSize, self.indicatorSize);
    }
    [self setNeedsDisplay];

}

- (void)restoreAnimation:(id)howmanydistance{
    
    CAKeyframeAnimation *anim = [[SpringLayerAnimation shareAnimManager] 
                                 createSpringAnima:@"fator"
                                 duration:0.8
                                 usingSpringWithDamping:0.5
                                 initialSpringVelocity:3
                                 fromValue:@(0.5 + [howmanydistance floatValue] * 1.5)
                                 toValue:@(0)];
    anim.delegate = self;
    self.fator = 0;
    [self addAnimation:anim forKey:@"restoreAnimation"];
    
}

#pragma mark - CAAnimation Delegate

-(void)animationDidStart:(CAAnimation *)anim{
 
    beginGooeyAnim = YES;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
 
    if (flag) {
        beginGooeyAnim =NO;
        [self removeAllAnimations];
    }
    
}


@end

