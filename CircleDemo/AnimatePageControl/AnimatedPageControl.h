//
//  AnimatedPageControl.h
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Indicator.h"
#import "Line.h"

typedef enum : NSUInteger{

    IndicatorStyleGooeyCircle, // 0
    IndicatorStyleRotateRect,  // 1

} IndicatorStyle;

@interface AnimatedPageControl : UIView


//----READWRITE----
//page的个数 The count of all pages
@property(nonatomic, assign) NSInteger pageCount;

//第一次显示的page 第一页为1,类推 2,3,4...  The default selected page ,if you
//wanna show fourth page, set 4
@property(nonatomic, assign) NSInteger selectedPage;

//未选中的颜色
@property(nonatomic, strong) UIColor *unSelectedColor;

//选中的颜色
@property(nonatomic, strong) UIColor *selectedColor;

//是否显示填充进度条
@property(nonatomic, assign) BOOL shouldShowProgressLine;

//绑定的滚动视图
@property(nonatomic, strong) UIScrollView *bindScrollView;


//indicator 的样式
@property (nonatomic, assign) IndicatorStyle indicatorStyle;

//indicator 大小
@property (nonatomic, assign) CGFloat indicatorSize;

//只读
@property (nonatomic, strong) Indicator *indicator;

//直线layer line
@property (nonatomic, readonly) Line *pageControlLine;

- (void)animateToIndex:(NSInteger)index;
@property (nonatomic, copy) void(^didSelectedIndexBlock) (NSInteger index);

@end
