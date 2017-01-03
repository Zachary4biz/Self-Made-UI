//
//  SwitchScrollViewViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

typedef enum {
    left,
    right
} MoveDirection;

#import "SwitchScrollViewViewController.h"

@interface SwitchScrollViewViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign)CGFloat factor;
@property(nonatomic,assign)CGFloat lastContentOffsetX;
@property(nonatomic,assign)CGRect lastRect;//didScroll结束时
@property (nonatomic,assign)CGRect currentRect;//didScroll开始时
@property (nonatomic,assign)MoveDirection moveDirection;//枚举滑动方向
@property (nonatomic,assign)CGFloat recorder4offsetInPage;//每一页中，滑动了多远，用取余
//抽出来
@property(nonatomic,strong)UIView *pageView;
@property(nonatomic,strong)UIView *view4TestPointA;
@property(nonatomic,strong)UIView *view4B;
@property(nonatomic,strong)UIView *view4C;
@property(nonatomic,strong)UIView *view4D;
@property(nonatomic,strong)UIView *pageIndicatorView;

@end

@implementation SwitchScrollViewViewController
#warning 算控制点时，offset = 直径/3.6效果最佳，尚未计算
#warning CGFloat不能简单地取余？
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = self.view.frame;
    _scrollView.contentSize = CGSizeMake(4 * self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.backgroundColor = [UIColor cyanColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
//抽出来
    _pageIndicatorView = [[UIView alloc]initWithFrame:CGRectMake(10,15,self.view.frame.size.width-20,40)];
    _pageIndicatorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageIndicatorView];
    _pageView = [[UIView alloc]init];
    _pageView.frame = CGRectMake(0, 5, 20, 20);
    _pageView.backgroundColor = [UIColor blueColor];
    [_pageIndicatorView addSubview:_pageView];
    
    //测试下A点是不是正确的
    _view4TestPointA = [[UIView alloc]init];
    _view4TestPointA.backgroundColor = [UIColor redColor];
    [_pageIndicatorView addSubview:_view4TestPointA];
    _view4B = [[UIView alloc]init];
    _view4B.backgroundColor = [UIColor yellowColor];
    [_pageIndicatorView addSubview:_view4B];
    
}

-(void)viewDidLayoutSubviews
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSLog(@"offsetX:%f,offsetY:%f",_scrollView.contentOffset.x,_scrollView.contentOffset.y);

//确定形变的比例，形变等于比例*形变最大值，假设形变最大为直径的2/5把，比例用 已滑动距离/一页距离
    //确定在哪一页
    int page =_scrollView.contentOffset.x/_scrollView.frame.size.width;
    //在该页滑动了多少
        //判断移动方向
    if (_currentRect.origin.x > _lastRect.origin.x) {
        _moveDirection = left;
        NSLog(@"Moving left");
        //page*..表示的是当前页的起始位置，所以如果往回移动，相当于？？
        _recorder4offsetInPage =_scrollView.frame.size.width-(_scrollView.contentOffset.x - page*_scrollView.frame.size.width);
    }
    else{
        NSLog(@"Moving right");
        _moveDirection = right;
        //指示器右移时
        _recorder4offsetInPage = _scrollView.contentOffset.x - page*_scrollView.frame.size.width;
    }
    
    NSLog(@"recorder4offsetInPage is %f",_recorder4offsetInPage);
    //滑动比例是ratio，最大为1
    CGFloat ratio = MIN(1, _recorder4offsetInPage/_scrollView.frame.size.width);
    NSLog(@"ratio is %f",ratio);
    //形变是直径的2/5乘以比例factor（效果大概就是B点往前，D点没有动，AC都往中间来，达到翻页的距离时，B点往前增加直径2/5）
    CGFloat shapeChange = _pageView.frame.size.width*2/5*ratio;
    NSLog(@"shapeChange 真实变化距离：%f",shapeChange);
//移动_pageView
    //指示器页码pageView的滑动距离应该是？
    //用比例，scrollView上滑动的距离contentOffset 比上 总长度contentSize 等于 指示页码滑动距离 比上 指示器长度
    CGFloat translation = (_scrollView.contentOffset.x/_scrollView.contentSize.width)*_pageIndicatorView.frame.size.width;
    NSLog(@"pageView 移动：%f",translation);
    _currentRect = _pageView.frame;
    CGPoint center = _pageView.center;
    center.x = translation;
    center.y = (_pageView.frame.origin.y+_pageView.frame.size.height/2)+_scrollView.contentOffset.y;
    _pageView.center = center;
    

//确定ABCD基准点,BD要根据移动方向判断加还是不加offsetX*比例
    CGPoint pointA = CGPointMake(_pageView.center.x, _pageView.frame.origin.y+shapeChange);
    _view4TestPointA.frame = CGRectMake(pointA.x, pointA.y, 2, 2);
    CGPoint pointB = CGPointZero;
    CGPoint pointD = CGPointZero;
    if (_moveDirection == right) {
        //B往前（往右），D正常
        pointB = CGPointMake(_pageView.center.x+_pageView.frame.size.width/2+shapeChange, _pageView.center.y);
        pointD = CGPointMake(_pageView.frame.origin.x, _pageView.center.y);
    }else{
        //B正常，D往后（往左）
        pointB = CGPointMake(_pageView.center.x+_pageView.frame.size.width/2, _pageView.center.y);
        pointD = CGPointMake(_pageView.frame.origin.x-shapeChange, _pageView.center.y);
    }
    _view4B.frame = CGRectMake(pointB.x, pointB.y, 2, 2);
    CGPoint pointC = CGPointMake(_pageView.center.x, _pageView.center.y+_pageView.frame.size.height/2-shapeChange);
    
//确定8个控制点
    //作者估计的是这个偏移offset为直径/3.6，效果最佳，尚未计算
    CGFloat offset = _pageView.frame.size.width/3.6;
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
    CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
    CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
//layer绘图
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [[UIColor blueColor] CGColor];
    [self.pageIndicatorView.layer addSublayer:shapeLayer];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: pointA];
    [path addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [path addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [path addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [path addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [path closePath];
    shapeLayer.path = path.CGPath;
    
    //每次调用didScroll结束就更新一下lastRect;
    _lastRect = _pageView.frame;
    
    
//抽出来
/*
#warning transform无效？？？
//    _pageView.transform = CGAffineTransformMakeTranslation(_scrollView.contentOffset.x, _scrollView.contentOffset.y);
    CGPoint center = _pageView.center;
    center.x = 5+ _scrollView.contentOffset.x;//5是初始化的X
    center.y = 15+ _scrollView.contentOffset.y;//15是初始化的y
    _pageView.center = center;
    
    NSLog(@"pageView's Center X:%f, Y:%f",_pageView.center.x,_pageView.center.y);
    NSLog(@"pageView's frame X:%f, Y:%f",_pageView.frame.origin.x,_pageView.frame.origin.y);
    
    //factor是一个比例，最大为1，表示滑动了一整个屏幕_scrollView.frame.size.width
    _factor = MIN(1, MAX(0, (ABS(_scrollView.contentOffset.x - self.lastContentOffsetX) / _scrollView.frame.size.width)));
    //假设四个点最大形变的距离是小球直径2/5，那么乘以直径，记录为pointOffset
    CGFloat pointOffset = _pageView.frame.size.width*(2/5);
    //获取这个矩形的中点，并以此确定abcd四点，最后通过abcd四点画出形变的点
    CGPoint rectCenter = _pageView.center;
    CGPoint pointA = CGPointMake(rectCenter.x ,self.currentRect.origin.y + pointOffset);
    NSLog(@"pointA's x:%f y:%f",pointA.x,pointA.y);
//    CGPoint pointB = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? rectCenter.x + self.currentRect.size.width/2 : rectCenter.x + self.currentRect.size.width/2 + pointOffset*2 ,rectCenter.y);
//    CGPoint pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.currentRect.size.height/2 - pointOffset);
//    CGPoint pointD = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? self.currentRect.origin.x - pointOffset*2 : self.currentRect.origin.x, rectCenter.y);
    
    //didscroll调用一次后，更新这些last开头的玩意
    _lastContentOffsetX = _scrollView.contentOffset.x;
    _currentRect = _pageView.frame;
 */
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
