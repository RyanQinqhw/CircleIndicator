//
//  ViewController.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "ViewController.h"
#import "DemoCell.h"
#import "AnimatedPageControl.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) AnimatedPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.segmentedControl addTarget:self action:@selector(changeIndicatorStyle) forControlEvents:UIControlEventValueChanged];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    

    [self setupUI];
     [self.view addSubview:self.pageControl];
}

-(void)setupUI{
    
    self.pageControl = [[AnimatedPageControl alloc]initWithFrame:CGRectMake(20, 450, 280, 45)];
    
    self.pageControl.pageCount = 8;
    self.pageControl.selectedPage = 1;
    self.pageControl.selectedColor = [UIColor redColor];
    self.pageControl.unSelectedColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.pageControl.shouldShowProgressLine = YES;
    
    self.pageControl.bindScrollView = self.collectionView;
    
//    self.pageControl.indicatorStyle = IndicatorStyleRotateRect;
    self.pageControl.indicatorSize = 20;
    
    
    __weak typeof(self) WeakSelf = self;
    [self.pageControl setDidSelectedIndexBlock:^(NSInteger index) {
        NSLog(@"选中的是== %ld ==",(long)index + 1);
    }];
    
   
    
}


#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.pageControl.indicator animatedIndicatorScrollView:scrollView andIndicator:self.pageControl];
    if (scrollView.dragging || scrollView.isDecelerating || scrollView.tracking) {
        //背景线条动画
    
        [self.pageControl.pageControlLine animateSelectedLineWithScrollView:scrollView];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.indicator.lastContentOffSet = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.pageControl.indicator
     restoreAnimation:@(1.0 / self.pageControl.pageCount)];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.pageControl.indicator.lastContentOffSet = scrollView.contentOffset.x;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pageControl.pageCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoCell *cell = (DemoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCell" forIndexPath:indexPath];
    cell.NumCell.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item + 1];
    
    return cell;
    
}

-(void)changeIndicatorStyle{
    
   
    if (self.pageControl.indicatorStyle == IndicatorStyleGooeyCircle) {
        
        [self.pageControl removeFromSuperview];
        [self setupUI];
        self.pageControl.indicatorStyle = IndicatorStyleRotateRect;
        [self.view addSubview:self.pageControl];
        NSLog(@"矩形");
    }
    else{
        [self.pageControl removeFromSuperview];
        [self setupUI];
        
        self.pageControl.indicatorStyle = IndicatorStyleGooeyCircle;
         [self.view addSubview:self.pageControl];
        NSLog(@"圆形");
    }
    
    
}

@end
