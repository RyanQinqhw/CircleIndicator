//
//  RotateRect.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "RotateRect.h"
#import "AnimatedPageControl.h"

@interface RotateRect ()

@property(nonatomic, assign) CGFloat index;

@end

@implementation RotateRect
static CGPathRef createPathRotatedAroundBoundingBoxCenter(CGPathRef path,
                                                          CGFloat radians) {
    CGRect bounds =
    CGPathGetBoundingBox(path); // might want to use CGPathGetPathBoundingBox
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, radians);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}

- (id)initWithLayer:(RotateRect *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        self.indicatorSize = layer.indicatorSize;
        self.indicatorColor = layer.indicatorColor;
        self.currentRect = layer.currentRect;
        self.lastContentOffSet = layer.lastContentOffSet;
        self.index = layer.index;
        
    }
    return self;
}

#pragma mark-- override  class func
- (void)drawInContext:(CGContextRef)ctx {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.currentRect];
    CGPathRef path = createPathRotatedAroundBoundingBoxCenter(rectPath.CGPath,
                                                              _index * M_PI_2);
    rectPath.CGPath = path;
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, self.indicatorColor.CGColor);
    CGContextFillPath(ctx);
    CGPathRelease(path);
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqual:@"index"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

#pragma mark-- override superclass method

- (void)animatedIndicatorScrollView:(UIScrollView *)scrollView andIndicator:(AnimatedPageControl *)pageControl {
    
    CGFloat originX = (scrollView.contentOffset.x / scrollView.frame.size.width) *
    (pageControl.frame.size.width / (pageControl.pageCount - 1));
    _index = (scrollView.contentOffset.x / scrollView.frame.size.width);
    
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

- (void)restoreAnimation:(id)howmanydistance {
}

@end
