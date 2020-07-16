//
//  AnimatedPageControl.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "AnimatedPageControl.h"
#import "GooeyCircle.h"
#import "RotateRect.h"

@interface AnimatedPageControl()

@property (nonatomic, strong) Line *line;
@property (nonatomic, strong) GooeyCircle *gooeyCircle;
@property (nonatomic, strong) RotateRect *rotateRect;

@end


@implementation AnimatedPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //给当前view 添加pan手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        
        [self addGestureRecognizer:pan];
        
        //添加tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark 当父视图改变的时候 ,自动调用
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    [self.layer addSublayer:self.line];
    [self.layer insertSublayer:self.indicator above:self.line];
    [self.line setNeedsDisplay];
}

-(void)tapAction:(UITapGestureRecognizer *)tapGesture{
    
   
    CGPoint location = [tapGesture locationInView:self];
    
    if (CGRectContainsPoint(self.line.frame, location)) {
        
        CGFloat ballDistance = self.frame.size.width / (self.pageCount - 1);
        
        NSInteger index = location.x / ballDistance;
        
        if ((location.x - index * ballDistance) >= ballDistance / 2) {
            
            index += 1;
        }
        
        CGFloat HOWMANYDISTANCE =
        ABS((self.line.selectedLineLength -
             index * ((self.line.frame.size.width - self.line.ballDiameter) /
                      (self.line.pageCount - 1)))) /
        ((self.line.frame.size.width - self.line.ballDiameter) /
         (self.line.pageCount - 1));
        
        [self.line animateSelectedLineToNewIndex:index + 1];
        
        [self.bindScrollView
         setContentOffset:CGPointMake(
                                      self.bindScrollView.frame.size.width * index, 0)
         animated:YES];
        
        
        
        //恢复动画
        [self.indicator performSelector:@selector(restoreAnimation:)
                             withObject:@(HOWMANYDISTANCE / self.pageCount)
                             afterDelay:0.2];
        
        if (self.didSelectedIndexBlock) {
            self.didSelectedIndexBlock(index + 1);
        }
    }
    
    
}


- (void)animateToIndex:(NSInteger)index {
    NSAssert(self.bindScrollView != nil,
             @"You can not scroll without assigning bindScrollView");
    CGFloat HOWMANYDISTANCE =
    ABS((self.line.selectedLineLength -
         index * ((self.line.frame.size.width - self.line.ballDiameter) /
                  (self.line.pageCount - 1)))) /
    ((self.line.frame.size.width - self.line.ballDiameter) /
     (self.line.pageCount - 1));
    
    //背景线条动画
    [self.line animateSelectedLineToNewIndex:index + 1];
    
    // scrollview 滑动
    [self.bindScrollView
     setContentOffset:CGPointMake(self.bindScrollView.frame.size.width * index,
                                  0)
     animated:YES];
    
    //恢复动画
    [self.indicator performSelector:@selector(restoreAnimation:)
                         withObject:@(HOWMANYDISTANCE / self.pageCount)
                         afterDelay:0.2];
}


-(void)panAction:(UIPanGestureRecognizer *)panGesture{
    NSLog(@"pan手势");
    
    
    
    
}

- (Line *)pageControlLine {
    return self.line;
}

//懒加载line
-(Line *)line{
    
    if (!_line) {
        _line = [Line layer];
        _line.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        //和屏幕的像素点一样
        _line.contentsScale = [UIScreen mainScreen].scale;
        
        _line.pageCount = self.pageCount;
        _line.selectedPage = self.selectedPage;
        _line.SelectedColor = self.selectedColor;
        _line.unSelectedColor = self.unSelectedColor;
        _line.bindScrollView = self.bindScrollView;
        _line.shouldShowProgressLine = self.shouldShowProgressLine;

}

    return _line;
}

-(Indicator *)indicator{
    
    if (!_indicator) {
        
        switch (self.indicatorStyle) {
            case IndicatorStyleGooeyCircle:
                _indicator = self.gooeyCircle;
                break;
            case IndicatorStyleRotateRect:
                _indicator = self.rotateRect;
            default:
                break;
        }
        
        [_indicator animatedIndicatorScrollView:self.bindScrollView andIndicator:self];
        
    }
    return _indicator;
}


-(GooeyCircle *)gooeyCircle{
    
    if (!_gooeyCircle) {
        _gooeyCircle = [GooeyCircle layer];
        _gooeyCircle.indicatorColor = self.selectedColor;
        _gooeyCircle.indicatorSize = self.indicatorSize;
        _gooeyCircle.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _gooeyCircle.contentsScale = [UIScreen mainScreen].scale;
    }
    
    
    return _gooeyCircle;
}
-(RotateRect *)rotateRect{
    
    if (!_rotateRect) {
        _rotateRect = [RotateRect layer];
        _rotateRect.indicatorColor = self.selectedColor;
        _rotateRect.frame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _rotateRect.indicatorSize = self.indicatorSize;
        _rotateRect.contentsScale = [UIScreen mainScreen].scale;
    }

    
    return _rotateRect;
}
@end
