//
//  SpringLayerAnimation.h
//  CircleDemo
//
//  Created by 明镜止水 on 16/10/18.
//  Copyright © 2016年 明镜止水. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SpringLayerAnimation : NSObject

+(instancetype)shareAnimManager;


-(CAKeyframeAnimation *)createHalfCurveAnmation:(NSString *)keyPath
                                       duration:(CFTimeInterval)duration
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue;

- (CAKeyframeAnimation *)createSpringAnima:(NSString *)keypath
                                  duration:(CFTimeInterval)duration
                    usingSpringWithDamping:(CGFloat)damping
                     initialSpringVelocity:(CGFloat)velocity
                                 fromValue:(id)fromValue
                                   toValue:(id)toValue;
@end
