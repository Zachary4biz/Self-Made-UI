//
//  RoundIconVIew.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "RoundIconView.h"

@implementation RoundIconView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)setIcon:(UIImage *)icon
//{
//    UIImage *image = icon;
//
//    //设置外部的圆环
//    //圆环的粗
//    CGFloat border = 1;
//    //圆环的半径
//    CGFloat oval = image.size.width + 2*border;
//    //绘制外部的圆环
//    //开启上下文
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//    //设置外部圆环的路径（实际就是一个圆，中间部分被图片占据）
//    UIBezierPath *path4circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, oval,oval)];
//    //设置圆环颜色
//    [[UIColor greenColor]set];
//    [path4circle fill];
//    
//    //绘制圆形图片
//    //2.设置圆形裁剪区域
//    //2.1设置圆形路径——正切于图片
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, image.size.width, image.size.height)];
//    
//    //2.2把路径设置为裁剪区域
//    [path addClip];
//    
//    //4.在图形上下文中，从(0,0)开始绘制图片
//    [image drawAtPoint:CGPointZero];//zero一般在左上角
//    
//    //5.从上下文中获取图片
//    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //5.关闭上下文
//    UIGraphicsEndImageContext();
//    
//    //显示图片
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
//    
//    imgView.image = clipImage;
//    [self addSubview:imgView];
//    
//    
//}

+(UIImage *)getRoundIconWithImage:(UIImage *)image circleBorder:(CGFloat) border circleColor:(UIColor *)color
{
    
    //设置外部的圆环
    //圆环的粗
    CGFloat temp_border = border;
    //圆环的半径
    CGFloat oval = image.size.width + 2*temp_border;
    //绘制外部的圆环
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(oval, oval), NO, 0);
    //设置外部圆环的路径（实际就是一个圆，中间部分被图片占据）
    UIBezierPath *path4circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, oval,oval)];
    //设置圆环颜色
    [color set];
    [path4circle fill];
    
    //绘制圆形图片
    //2.设置圆形裁剪区域
    //2.1设置圆形路径——正切于图片
    UIBezierPath *path4pic = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(temp_border, temp_border, image.size.width, image.size.height)];
    
    //2.2把路径设置为裁剪区域
    [path4pic addClip];
    
    //4.在图形上下文中，从(0,0)开始绘制图片
    [image drawAtPoint:CGPointMake(temp_border, temp_border)];//zero在当前路径的左上角
    
    //5.从上下文中获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.关闭上下文
    UIGraphicsEndImageContext();
    return  clipImage;
}

@end
