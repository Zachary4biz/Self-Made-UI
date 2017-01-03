//
//  TransitionManager.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/11/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TransitionManager.h"

@interface TransitionManager ()<UIViewControllerAnimatedTransitioning>

@end
@implementation TransitionManager

#pragma mark present和dismiss动画逻辑
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //通过viewControllerForKey取出转场前后的两个控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //截图，然后对截图做动画
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    tempView.frame = fromVC.view.frame;
    //截图后隐藏
    fromVC.view.hidden = YES;
    //containerView，如果要对VC做转场动画，就要把视图加入containerView,它管理着所有转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和vc2的view都加入containerView中
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    //设置vc2的frame，因为这里vc2 present出来不是全屏，初始在底部，如果不设置frame默认会是整个屏幕
    toVC.view.frame = CGRectMake(0, containerView.frame.size.height, containerView.frame.size.width, 400);
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         //VC2上移
                         toVC.view.transform = CGAffineTransformMakeTranslation(0, -400);
                         //截图视图缩小
                         tempView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                     }
                     completion:^(BOOL finished) {
                         //表示完成转场，通知transitionContext
                         [transitionContext completeTransition:YES];
                         //移除截图，因为之后再转场会重新截图
                         [tempView removeFromSuperview];
                     }];
}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //dismiss时fromVC和toVC就反过来了
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //参照present的逻辑，present成功后，containerView的最后一个子视图就是“截图视图”，将其取出准备动画
    UIView *tempView = [transitionContext containerView].subviews[0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         //因为present用的是transform，这里只需要恢复transform就可以了
                         fromVC.view.transform = CGAffineTransformIdentity;
                         tempView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         //标记转场成功，通知transitionContext
                         [transitionContext completeTransition:YES];
                         //显示vc1
                         toVC.view.hidden = NO;
                         //移除“截图视图”
                         [tempView removeFromSuperview];
                     }];
}
#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //将present和dismiss两种动画逻辑分开写
    switch (_type) {
        case TransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case TransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

@end
