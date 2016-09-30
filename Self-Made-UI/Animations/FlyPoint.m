//
//  FlyPoint.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "FlyPoint.h"

@interface FlyPoint()
@property(assign,nonatomic) int count;
@property(assign,nonatomic) int judge;
@property(assign,nonatomic) float timeAdd;
@property(strong,nonatomic) CALayer *layer;
@property(strong,nonatomic) NSTimer *timer;
@end
@implementation FlyPoint

/*
//添加layer
-(void)setFlyPointWithView:(UIView *)view
{
    _layer.bounds = CGRectMake(0, 0, 180, 180);
    _layer.position = CGPointMake(150,300);
    _layer.anchorPoint = CGPointMake(0.5,0.5);
    _layer.backgroundColor = [[UIColor redColor] CGColor];
    [view.layer addSublayer:_layer];
    _timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(layerChange) userInfo:nil repeats:YES];
    
}

-(void)startAnimation
{
    [_timer setFireDate:[NSDate date]];
}
-(void)suspendAnimation
{
    [_timer setFireDate:[NSDate distantFuture]];
}
*/
+(CAAnimationGroup *)getRandomAnimationWithRectView:(UIView *)view
{
//scale动画容易让这个view变小到消失，还是不用了

        float scaleRandom  =((1.0 * arc4random_uniform(200)+10)/100);
//    NSLog(@"%f",scaleRandom);
    scaleRandom =  [[NSString stringWithFormat:@"%.3f",scaleRandom] floatValue];
    int rotationRandom = (arc4random_uniform(M_PI*2)+M_PI_2);
    CGPoint positionRandom = CGPointMake((arc4random_uniform(80)+view.frame.origin.x), (arc4random_uniform(200)+view.frame.origin.y));
    int cornerRadiusRandom = scaleRandom*view.frame.size.width;
//    int cornerRadiusRandom = (arc4random_uniform(view.frame.size.width)+1);
    CGColorRef colorRandom = [[UIColor colorWithRed:arc4random_uniform(255)/256.0 green:arc4random_uniform(255)/256.0 blue:arc4random_uniform(255)/256.0 alpha:(arc4random_uniform(1)/1.0 + 0.3)] CGColor];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @(scaleRandom);
    
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @(rotationRandom);
    
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:positionRandom];
    
    CABasicAnimation *cornerRadius = [CABasicAnimation animation];
    cornerRadius.keyPath = @"cornerRadius";
    cornerRadius.toValue = @(cornerRadiusRandom);
    
    CABasicAnimation *color = [CABasicAnimation animation];
    color.keyPath = @"backgroudColor";
    color.toValue =  (__bridge id _Nullable)(colorRandom);
    
    animationGroup.animations = @[scale,rotation,position,cornerRadius,color];

    //写在这里无效，要写在addAnimation前面
//    //动画完成时不移除
//    animationGroup.removedOnCompletion = NO;
//    //动画执行完成要保持最新的动画效果
//    animationGroup.fillMode = kCAFillModeForwards;
#pragma mark 设置代理
    //设置代理
//    animationGroup.delegate = self;//设置接受这个方法的那个类里面吧
    
    return animationGroup;
}


@end
