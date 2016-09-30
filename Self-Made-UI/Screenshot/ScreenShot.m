//
//  ScreenShotView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ScreenShot.h"
typedef UIImage * (^completionBlock4Img)(id object);

@interface ScreenShot()

@property(nonatomic,strong)UIView *baseView;//用来截图的view
@property(nonatomic,strong)UIView *clipView;//截图框那个view
@property(nonatomic,strong)UIImage *resultImage;//截取好的图片


@end

@implementation ScreenShot


-(UIView *)clipView
{
    //懒加载clipView，避免在pan响应中一直重复生成
    if (_clipView == nil) {
        _clipView = [[UIView alloc]init];
        _clipView.backgroundColor = [UIColor blackColor];
        _clipView.alpha = 0.5;
    }
    return _clipView;
}

+(UIImage *)screenshotWithView:(UIView *)view
{
    return nil;
}

-(void)screenshotFromPanWithView:(UIView *)view
{


}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    
    
}

@end
