//
//  Line.h
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface Line : CALayer

//page 个数
@property (nonatomic, assign) NSUInteger pageCount;

//选中的页数
@property (nonatomic, assign) NSUInteger selectedPage;

//是否开启进度显示
@property (nonatomic, assign) BOOL shouldShowProgressLine;

//线高
@property (nonatomic, assign) CGFloat lineHeight;

//小球直径
@property (nonatomic, assign) CGFloat ballDiameter;

//未选中颜色
@property (nonatomic, strong) UIColor *unSelectedColor;

//选中颜色
@property (nonatomic, strong) UIColor *SelectedColor;

//选中的长度
@property(nonatomic, assign) CGFloat selectedLineLength;

//绑定的滚动视图
@property(nonatomic, strong) UIScrollView *bindScrollView;


- (void)animateSelectedLineWithScrollView:(UIScrollView *)scrollView;

- (void)animateSelectedLineToNewIndex:(NSInteger)newIndex;

@end
