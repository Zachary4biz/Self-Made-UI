
//
//  DownloadProgressView.m
//  DownloadXib
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "DownloadProgressView.h"

@implementation DownloadProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写set方法，每次给progress赋值就会进入下面
-(void)setProgress:(float)progress
{
    _progress = progress;
    [self changeLbl];
    [self setNeedsDisplay];
    
}

//修改数字LBL
-(void)changeLbl
{
    self.downloadProgressLbl.text = [NSString stringWithFormat:@"%.2f%%", _progress*100];
}
//绘制圆进度条
-(void)drawRect:(CGRect)rect
{
    //创建贝塞尔路径圆的中心和半径
    CGFloat radius = rect.size.width*0.5;
    CGPoint center = CGPointMake(radius, radius);
    //起始角度是-90，结束角度是-90开始加上进度乘以2PI，进度为1就是2PI
    CGFloat endAngle = -M_PI_2 + _progress*2*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius-5 startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    
    //绘制
    [path stroke];
}
@end
