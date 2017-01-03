//
//  RopinessPointView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "RopinessPointView.h"

@interface RopinessPointView()
@property (nonatomic,strong) UIView *pointView;//绘制初始位置的点，随距离变大半径变小，是self的子view不然没法显示，子view不能用fram只能用bounds不然x，y到处飞了。但这又导致不能用pointView.frame = self.frame来记录self的初始位置值。
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign)NSInteger originalRadius;
@property (nonatomic,assign) CGFloat x4translation;//累计translation的x，用来算移动距离，替代distanceWithPoint函数
@property (nonatomic,assign) CGFloat y4translation;//累计translation的y
@end
@implementation RopinessPointView
/**
 *  这里pointView为源码的smallCir，self还是源码的self
 *
 */
//懒加载点
-(UIView *)pointView
{
    if (!_pointView) {
        UIView *pointView = [[UIView alloc]init];
        pointView.backgroundColor = self.backgroundColor;
        pointView.frame = self.frame;
        _pointView = pointView;
    }
    return _pointView;
}
//懒加载layer
-(CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
#warning DIffrence ??__birdge  ownership....//shapeLayer.fillColor = self.backgroundColor;
        shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:shapeLayer below:self.layer];
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;
}

#pragma mark 系统初始化
-(id)initWithFrame:(CGRect)frame Color:(UIColor *)color SuperView:(UIView *)superView
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = color;
        [superView addSubview:self];
        [superView insertSubview:self.pointView belowSubview:self];
        [self setUp];
    }
    return self;
}

//-(void)awakeFromNib{
//    [self setUp:color];
//}

#pragma mark 初始化视图
-(void)setUp
{
    //设置点pointView的半径就是整个self这个view的宽（高）
    CGFloat w = self.bounds.size.width;
    self.layer.cornerRadius = w/2;
    self.pointView.layer.cornerRadius = w/2;
    //记录原始半径originalRadius
    _originalRadius = w/2;

//懒加载里_pointView是在self.superView里插入的,below:self
    //给整个self添加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];

}

#pragma mark 手势触发方法
#define MaxDistance 90
-(void)pan:(UIPanGestureRecognizer *)pan
{
//跟随手势移动
    //获取偏移量
    CGPoint translation = [pan translationInView:self];
    
    //改变中心点实现位移
    CGPoint center = self.center;
    center.x += translation.x;
    center.y += translation.y;
    self.center = center;
    
//#warning 可以用另一个变量记录translation，代替distanceWithPointA: andPointB:吗？
//不可以，因为如果拖了两次，但两次都没有超出MaxDistance，那会把前一次的累加到第二次上
//    _x4translation += translation.x;
//    _y4translation += translation.y;
//    CGFloat d = sqrt(_x4translation*_x4translation+_y4translation*_y4translation);
//    NSLog(@"translationGetDis - %f",d);
    //每次pan结束后要归零，因为上面这个center.x使用的是直接累加pan的位移
    [pan setTranslation:CGPointZero inView:self];

//设置拖动的圆的变化值
    //获取拖动的圆距离初始圆心的距离

    CGFloat pointDistance = [self distanceWithPointA:self.center andPointB:_pointView.center];
    NSLog(@"pointDistance--%f",pointDistance);
    CGFloat currentRadius = _originalRadius - pointDistance/10.0;
    if (currentRadius<0) {
        currentRadius = 0;
    }
    _pointView.bounds = CGRectMake(0, 0, currentRadius*2, currentRadius*2);

    _pointView.layer.cornerRadius = currentRadius;
    //绘图
    if (pointDistance > MaxDistance) {
        self.pointView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];//??代码到这里还没用到这个shapeLayer
        self.shapeLayer = nil;
    }
    else if(self.pointView.hidden == NO && pointDistance>0)
    {
        //开始用shapelayer了

        //解释：这个函数里面有一个if判断、换值，保证了参数bigCir就是大的那个，smallCir就是小的那个
        self.shapeLayer.path = [self getBezierPathWithPointView:self andBigCir:_pointView].CGPath;;
    }
    //爆炸或还原
    if (pan.state == UIGestureRecognizerStateBegan) {
        NSLog(@"pan Began-%@",NSStringFromCGRect(self.frame));
    }
//    if (pointDistance < MaxDistance-4 && pointDistance >MaxDistance-20) {
//        //想通过这种距离来，判断一下到底怎么在实现的
//        self.backgroundColor = [UIColor greenColor];
//    }
    if (pointDistance < MaxDistance && pointDistance >MaxDistance-15) {
        
        //自己想实现在这个距离变色
        self.layer.backgroundColor = [UIColor cyanColor].CGColor;
        self.backgroundColor=[UIColor cyanColor];
        
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (pointDistance>MaxDistance) {
            //超过最大距离，爆炸
            NSLog(@"爆炸--------------");
            NSLog(@"pan End-%@",NSStringFromCGRect(self.frame));
            //暂时没有这组动态图片
//            UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
//            NSMutableArray *imgArr = [NSMutableArray array];
//            for (int i=1; i<9; i++) {
//                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
//                [imgArr addObject:image];
//            }
//            imgView.animationImages = imgArr;
//            imgView.animationDuration = 0.5;
//            imgView.animationRepeatCount = 1;
//            [imgView startAnimating];
//            [self addSubview:imgView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //移除控件
                [self removeFromSuperview];
            });
        }
        else
        {
            //没超过最大距离，回弹
            _pointView.hidden = YES;
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer=nil;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = self.pointView.center;
            } completion:^(BOOL finished) {
                self.pointView.hidden = NO;
            }];
        }
    }
}
#pragma mark 获取距离原始图像圆心的距离
-(CGFloat)distanceWithPointA:(CGPoint)pointA andPointB:(CGPoint)pointB
{
    CGFloat offSetX = pointA.x - pointB.x;
    CGFloat offSetY = pointA.y - pointB.y;
    return sqrt(offSetX*offSetX + offSetY*offSetY);
}
#pragma mark 获取贝塞尔曲线
-(UIBezierPath *)getBezierPathWithPointView:(UIView *)smallCir andBigCir:(UIView *)bigCir
{
    //获取最小圆，这样不论调用本函数时传参怎么传的，bigCir就是大的smallCir就是小的
    if (bigCir.frame.size.width < smallCir.frame.size.width) {
        //大圆小于小圆（原位置的，小于拖动出来的），交换
        UIView *view = bigCir;
        bigCir = smallCir;
        smallCir = view;
    }
    //	获取小圆的信息
    CGFloat d = [self distanceWithPointA:smallCir.center andPointB:bigCir.center];
    CGFloat x1 = smallCir.center.x;
    CGFloat y1 = smallCir.center.y;
    CGFloat r1 = smallCir.bounds.size.width/2;
    //	获取大圆的信息
    CGFloat x2 = bigCir.center.x;
    CGFloat y2 = bigCir.center.y;
    CGFloat r2 = bigCir.bounds.size.width/2;
    //	获取三角函数
    CGFloat sinA = (y2 - y1)/d;
    CGFloat cosA = (x2 - x1)/d;
    //	获取矩形四个点
    CGPoint pointA = CGPointMake(x1 - sinA*r1, y1 + cosA * r1);
    CGPoint pointB = CGPointMake(x1 + sinA*r1, y1 - cosA * r1);
    CGPoint pointC = CGPointMake(x2 + sinA*r2, y2 - cosA * r2);
    CGPoint pointD = CGPointMake(x2 - sinA*r2, y2 + cosA * r2);
    //	获取控制点，以便画出曲线
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * cosA , pointA.y + d / 2 * sinA);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * cosA , pointB.y + d / 2 * sinA);
    //	创建路径
    UIBezierPath *path =[UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
    
}
@end
