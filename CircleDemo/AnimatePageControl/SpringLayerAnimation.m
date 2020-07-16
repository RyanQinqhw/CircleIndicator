//
//  SpringLayerAnimation.m
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import "SpringLayerAnimation.h"

@implementation SpringLayerAnimation

+(instancetype)shareAnimManager{
    
    static SpringLayerAnimation *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SpringLayerAnimation alloc]init];
    });
    return instance;
}

-(CAKeyframeAnimation *)createHalfCurveAnmation:(NSString *)keyPath
                                        duration:(CFTimeInterval)duration
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue{
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    anim.values = [self halfCurveAnmationValues:fromValue toValues:toValue duration:duration];
    
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    
    return anim;
}



-(NSMutableArray *) halfCurveAnmationValues:(id)fromValue
                                   toValues:(id)toValue
                                   duration:(CFTimeInterval)duration{
    
    NSInteger numOfFrames = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfFrames];
    for (NSInteger i = 0; i < numOfFrames; i++) {
        [values addObject:@(0.0)];
    }
    CGFloat diff = [toValue floatValue] - [fromValue floatValue];
    for (NSInteger frame = 0; frame < numOfFrames; frame++) {
        
        CGFloat x = (CGFloat)frame / (CGFloat)numOfFrames;
        CGFloat value = [fromValue floatValue] + diff * (-x * (x - 2));
        values[frame] = @(value);
    }
    return values;
}



- (CAKeyframeAnimation *)createSpringAnima:(NSString *)keypath
                                  duration:(CFTimeInterval)duration
                    usingSpringWithDamping:(CGFloat)damping
                     initialSpringVelocity:(CGFloat)velocity
                                 fromValue:(id)fromValue
                                   toValue:(id)toValue {
    
    CGFloat dampingFactor = 10.0;
    CGFloat velocityFactor = 10.0;
    NSMutableArray *values = [self springAnimationValues:fromValue
                                                 toValue:toValue
                                  usingSpringWithDamping:damping * dampingFactor
                                   initialSpringVelocity:velocity * velocityFactor
                                                duration:duration];
    CAKeyframeAnimation *anim =
    [CAKeyframeAnimation animationWithKeyPath:keypath];
    anim.values = values;
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}
- (NSMutableArray *)springAnimationValues:(id)fromValue
                                  toValue:(id)toValue
                   usingSpringWithDamping:(CGFloat)damping
                    initialSpringVelocity:(CGFloat)velocity
                                 duration:(CGFloat)duration {
    // 60个关键帧
    NSInteger numOfFrames = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfFrames];
    for (NSInteger i = 0; i < numOfFrames; i++) {
        [values addObject:@(0.0)];
    }
    
    //差值
    CGFloat diff = [toValue floatValue] - [fromValue floatValue];
    for (NSInteger frame = 0; frame < numOfFrames; frame++) {
        CGFloat x = (CGFloat)frame / (CGFloat)numOfFrames;
        CGFloat value = [toValue floatValue] -
        diff * (pow(M_E, -damping * x) *
                cos(velocity * x)); // y = 1-e^{-5x} * cos(30x)
        values[frame] = @(value);
    }
    return values;
}


@end
