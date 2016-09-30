//
//  PieChartView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSMutableArray *)pieAttrArr
{
    if (_pieAttrArr == nil) {
        _pieAttrArr = [NSMutableArray array];
    }
    return _pieAttrArr;
}

-(void)DoActions
{
    [self setNeedsDisplay];
//    NSInteger count = self.pieAttrArr.count;
//    for (int i =0; i<count; i++) {
//        NSString *percent = self.pieAttrArr[i][0];//占比
//        UIColor *color = self.pieAttrArr[i][1];//外面传进来的UIColor
//        [self dataHandleWithPercent:percent Color:color];
//    }
}
//-(void)dataHandleWithPercent:(NSString *)percent Color:(UIColor *)color
//{
//    
//}
-(void)drawRect:(CGRect)rect
{
    //设置半径、圆心
    CGFloat radius = rect.size.width *0.5;
    CGPoint center = CGPointMake(radius, radius);
    //初始化每个小扇形开始、结束的角度，中间值--扇形角度多大
    CGFloat startAngle = 0;
    CGFloat endAngle = 0;
    CGFloat angle = 0;//??
    
    //循环绘制
    for (int i=0;i<self.pieAttrArr.count;i++)
    {
        startAngle = endAngle;//从上一个结束的位置开始画
        angle = ([self.pieAttrArr[i][0] doubleValue]/100) *2*M_PI;
        endAngle = startAngle + angle;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //向中心连线
        [path addLineToPoint:center];
        //设置填充色
        UIColor *fillColor = (UIColor *)self.pieAttrArr[i][1];
        [fillColor set];
        //填充
        [path fill];
        
    }
}

@end
