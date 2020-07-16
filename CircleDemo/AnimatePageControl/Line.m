//
//  Line.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "Line.h"
#import "SpringLayerAnimation.h"
#define width_2 self.frame.size.width / 2
#define height_2 self.frame.size.height / 2
//相邻小球之间的距离
#define DISTANCE ((self.frame.size.width - self.ballDiameter) / (self.pageCount - 1))
@implementation Line{
    //记录上一次选中的长度
    CGFloat initialSelectedLineLength;
    // 记录上一次的contentOffSet.x
    CGFloat lastContentOffSetX;
}


//初始化,提供默认值
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.selectedPage = 1;
        self.pageCount = 5;
        self.lineHeight = 2.0;
        self.ballDiameter = 10.0;
        self.shouldShowProgressLine = YES;
        self.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.SelectedColor = [UIColor redColor];
    }
    return self;
}

- (instancetype)initWithLayer:(Line *)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        
        self.selectedPage = layer.selectedPage;
        self.pageCount = layer.pageCount;
        self.lineHeight = layer.lineHeight;
        self.ballDiameter = layer.ballDiameter;
        self.shouldShowProgressLine = layer.shouldShowProgressLine;
        self.unSelectedColor = layer.unSelectedColor;
        self.SelectedColor = layer.SelectedColor;
        self.bindScrollView = layer.bindScrollView;
        self.selectedLineLength = layer.selectedLineLength;
        self.masksToBounds = layer.masksToBounds;
    }
    return self;
}

-(void)setSelectedPage:(NSUInteger)selectedPage{
    
    _selectedPage = selectedPage;
    initialSelectedLineLength = _selectedLineLength;
}

//layer首次加载时会调用 ,方法来判断当前指定的属性key改变是否需要重新绘制
//当 key 发生改变会自动调用 setNeedsDisplay 方法 重新绘制
+(BOOL)needsDisplayForKey:(NSString *)key{
    
    if ([key isEqualToString:@"selectedLineLength"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx{
    
    
    if (self.pageCount == 1) {
        
        CGMutablePathRef linePath = CGPathCreateMutable();
        
        CGPathMoveToPoint(linePath, nil, width_2 , height_2 );
        
        CGRect circle = CGRectMake(width_2 - self.ballDiameter / 2,height_2 - self.ballDiameter / 2 , self.ballDiameter, self.ballDiameter);
        
        CGPathAddEllipseInRect(linePath, nil, circle);
        
        //把线添加到图像上下文中
        CGContextAddPath(ctx, linePath);
        //设置上下文的颜色
        CGContextSetFillColorWithColor(ctx, self.SelectedColor.CGColor);
        //填充上下文
        CGContextFillPath(ctx);
        
        CGPathRelease(linePath);
        return ;
    }
    
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(linePath, nil, self.ballDiameter / 2, height_2);
    
    
    //画默认颜色的背景线
    
    CGPathAddRoundedRect(linePath, nil, CGRectMake(self.ballDiameter / 2, height_2 - self.lineHeight / 2, width_2 * 2 - self.ballDiameter , self.lineHeight), 0, 0);
    
    //画小圆圈
    
    for (NSUInteger i = 0; i < self.pageCount; i++) {
        
        CGRect cicleRect = CGRectMake(0 + i * DISTANCE, height_2 - self.ballDiameter / 2, self.ballDiameter, self.ballDiameter);
        CGPathAddEllipseInRect(linePath, nil, cicleRect);
    }
    
    //把线添加到图像上下文中
    CGContextAddPath(ctx, linePath);
    //设置上下文的颜色
    CGContextSetFillColorWithColor(ctx, self.unSelectedColor.CGColor);
    //填充上下文
    CGContextFillPath(ctx);
    
    
    if (self.shouldShowProgressLine == YES) {
        
        CGContextBeginPath(ctx);
        
        linePath = CGPathCreateMutable();
        
        //画带线的颜色
        CGPathAddRoundedRect(linePath, nil, CGRectMake(self.ballDiameter / 2, height_2 - self.lineHeight / 2, self.selectedLineLength, self.lineHeight), 0, 0);
        
        //画小圆
        for (NSUInteger i = 0; i < self.pageCount; i++) {
            
            
            if (i * DISTANCE <= self.selectedLineLength + 0.1) {
                CGRect cicleRect = CGRectMake(0 + i * DISTANCE, height_2 - self.ballDiameter / 2, self.ballDiameter, self.ballDiameter);
                CGPathAddEllipseInRect(linePath, nil, cicleRect);
            }
            
            
        }
        
        CGContextAddPath(ctx, linePath);
        CGContextSetFillColorWithColor(ctx, self.SelectedColor.CGColor);
        CGContextFillPath(ctx);
        
        //CF 框架的要释放掉
        CGPathRelease(linePath);
    }
    

    
}

- (void)animateSelectedLineToNewIndex:(NSInteger)newIndex{
    
    
    CGFloat newLineLength =(newIndex - 1)   * DISTANCE;
    
    CAKeyframeAnimation *anim = [[SpringLayerAnimation shareAnimManager] createHalfCurveAnmation:@"selectedLineLength" duration:1.0 fromValue:@(self.selectedLineLength) toValue:@(newLineLength)];
    
    self.selectedLineLength = newLineLength;
    anim.delegate = self;
    anim.removedOnCompletion = YES;
    
    [self addAnimation:anim forKey:@"lineAnimation"];
    
    self.selectedPage = newIndex;
    
}

- (void)animateSelectedLineWithScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0) {
        return;
    }
    
    CGFloat offSetX = scrollView.contentOffset.x - lastContentOffSetX;
    self.selectedLineLength = initialSelectedLineLength +
    (offSetX / scrollView.frame.size.width) * DISTANCE;
    [self setNeedsDisplay];
}

#pragma maek --  Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        initialSelectedLineLength = self.selectedLineLength;
        lastContentOffSetX = (self.selectedLineLength / DISTANCE) *
        self.bindScrollView.frame.size.width;
    }
}

@end
