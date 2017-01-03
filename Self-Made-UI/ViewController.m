//
//  ViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ViewController.h"
#import "DownloadProgressView.h"
#import "PieChartView.h"
#import "SwitchScrollViewViewController.h"
#import "RoundIconView.h"
#import "RopinessPointView.h"
#import "Screenshot.h"
#import "FlyPoint.h"
@interface ViewController ()<UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView4Btn;


//进度条
- (IBAction)progressBtn:(id)sender;
@property(nonatomic,strong)DownloadProgressView *progressView;

//饼图
- (IBAction)pieChartBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *percentTextField;
@property (weak, nonatomic) IBOutlet UILabel *remainPercentLbl;
@property (assign,nonatomic) int remainPercent;
- (IBAction)addBtn:(id)sender;
@property(nonatomic,strong)PieChartView *pieView;

//粘性按钮
- (IBAction)ropinessBtn:(id)sender;

//截图按钮
- (IBAction)screenshotBtn:(id)sender;
@property(nonatomic,strong)UIView *clipView;//截图的那个框
@property(nonatomic,assign)CGPoint startP;//记录最开始的位置，用来画截图的矩形框的左上
@property(nonatomic,assign)CGPoint currP;//记录pan当前的位置，用来画截图的矩形框的右下
@property (weak, nonatomic) IBOutlet UIView *clipResultView;//显示截图结果的view，里面放一个imageView

//毛玻璃按钮
- (IBAction)frostedGlassBtn:(id)sender;
@property(nonatomic,strong)UIToolbar *toolbar;//搞个全局是为了给他加响应手势tap，让它消失


//随机动画
- (IBAction)flyPointBtn:(id)sender;
@property(nonatomic,strong)UIView *AnimationView;//手动创建。 看不见了？？？
@property(nonatomic,assign)int judge4flyPoint;//判断按钮点击此时从而开关动画
@property(nonatomic,assign)int count4flyPoint;//判断按钮点击多少次，从而决定是在哪个周期里面，是要加时间还是减时间
@property (weak, nonatomic) IBOutlet UIView *RandomAnimationView;//手动创建的好像看不见，靠
@property(nonatomic,assign)float timeAdd;//周期性的改变动画持续时间，增9次减9次，周期18，每次0.1


//歌词过度色
@property(nonatomic,strong)UILabel *lyric1;
@property(nonatomic,strong)UILabel *lyric2;
@property(nonatomic,strong)UILabel *lyric3;

@property(nonatomic,strong)CALayer *layer4lyric;//给lyric2做的，lyric2在1上面
@property(nonatomic,strong)CALayer *layer;//给lyric3做的
- (IBAction)lyricBtn:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //进度条
    _progressView = [[NSBundle mainBundle]loadNibNamed:@"DownloadProgressView" owner:nil options:nil][0];
    _progressView.frame = CGRectMake(50, 50, 80, 80);
    [self.scrollView addSubview:_progressView];

    //饼图
    _remainPercent = 100; //不用管
    _pieView = [[NSBundle mainBundle]loadNibNamed:@"PieChartView" owner:nil options:nil][0];
    _pieView.frame = CGRectMake(40, 180, 100, 100);
    [self.scrollView addSubview:_pieView];
    

    //圆形头像
    UIImage *roundIcon = [RoundIconView getRoundIconWithImage:[UIImage imageNamed:@"999"] circleBorder:2 circleColor:[UIColor blackColor]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame: CGRectMake(40,330,100,100)];
    imageView.image = roundIcon;
    [self.scrollView addSubview:imageView];
    
    
    //粘性按钮写在按钮的响应函数里，每点击一次就会出来一个
//    RopinessPointView *pointView = [[RopinessPointView alloc]initWithFrame:CGRectMake(40, 500, 20, 20)];
//    pointView.backgroundColor = [UIColor redColor];
//    [self.scrollView addSubview:pointView];
    
    //截图按钮写在按钮里了
    
    //随机动画，初始化一下这个view
    _AnimationView = [[UIView alloc]init];
    _AnimationView.backgroundColor = [UIColor cyanColor];
    _AnimationView.frame = CGRectMake(100, 940, 50, 50);
    [self.view addSubview:_AnimationView];
    
    _RandomAnimationView.backgroundColor = [UIColor cyanColor];
    
    //990开始，歌词过渡色
    _lyric1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 1090, 100, 100)];
    _lyric1.textColor = [UIColor blueColor];
    _lyric1.text = @"歌词一歌词一歌词一歌词一";
    [_lyric1 sizeToFit];
    _lyric2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 1090, 100, 100)];
    _lyric2.textColor = [UIColor redColor];
    _lyric2.text = @"歌词一歌词一歌词一歌词一";
    [_lyric2 sizeToFit];
    
    _lyric2.hidden = YES; //查了网上的倒是没有看到设置这个的

    
    _lyric3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 1170, 100, 100)];
    _lyric3.textColor = [UIColor redColor];
    _lyric3.text = @"歌词一歌词一歌词一歌词一";
    [_lyric3 sizeToFit];
    
    
    
    [self.scrollView addSubview:_lyric1];
    [self.scrollView addSubview:_lyric2];
    [self.scrollView addSubview:_lyric3];

    
    //跳转到小UI界面（首页）
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn0 addTarget:self action:@selector(clickbtn0) forControlEvents:UIControlEventTouchUpInside];
    [btn0 setTitle:@"UIView" forState:UIControlStateNormal];
//    btn0.backgroundColor = [UIColor cyanColor];
    btn0.frame = CGRectMake(10, 0, 60, 30);
    
    [self.topScrollView4Btn addSubview:btn0];
//
//    
    //跳转到scrollView的页面
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 addTarget:self action:@selector(clickbtn1) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"scrollView" forState:UIControlStateNormal];

    btn1.frame = CGRectMake(90 , 0, 60, 30);
    btn1.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.topScrollView4Btn addSubview:btn1];
    
    
}


//进度条
- (IBAction)progressBtn:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (float i = 0; i <=1; i+=0.001) {
            NSLog(@"%.2f",i);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
#pragma mark 进度条
                _progressView.progress = i;
//done
            }];
            sleep(0.01);
        }
    });
}

//饼图
- (IBAction)pieChartBtn:(id)sender {
    [_pieView DoActions];
}
- (IBAction)addBtn:(id)sender {
    UIColor *color =[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
#pragma mark 饼图
    NSArray *tempArr = [NSArray arrayWithObjects:_percentTextField.text, color,nil];
    [_pieView.pieAttrArr addObject:tempArr];
//done
    _remainPercent -=[self.percentTextField.text intValue];
    NSString *tempStr = [NSString stringWithFormat: @"剩余--%d",_remainPercent];
    self.remainPercentLbl.text =tempStr;
    if (_remainPercent == 0) {
        self.percentTextField.text = nil;
        self.percentTextField.enabled = NO;
    }
}

//粘性按钮
- (IBAction)ropinessBtn:(id)sender {
#pragma mark 粘性按钮
//由于封装不熟练，这里对内置的_pointView搞懒加载，使用了self.superView来把这个代表初始点的pointView放到这里的scrollView里面，导致必须先把这里的ropniessPoint加到scrollView才能取到它的superView，才能设置_pointView，感觉挺不好的，所以直接把addSubview放到了这个initWith...函数里面当superView。
    RopinessPointView *ropniessPoint = [[RopinessPointView alloc] initWithFrame:CGRectMake(70, 450, 30, 30) Color:[UIColor redColor] SuperView:self.scrollView];
//    [self.scrollView addSubview:pointView];
//done
    
}

//截图按钮
- (IBAction)screenshotBtn:(id)sender {
    _clipView = [[UIView alloc]init];
    _clipView.backgroundColor = [UIColor blackColor];
    _clipView.alpha = 0.5;
    [_scrollView addSubview:_clipView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.scrollView addGestureRecognizer:pan];
    
}
//截图按钮
-(void)pan:(UIPanGestureRecognizer *)pan
{
#pragma mark 截图按钮
//    CGPoint startP = CGPointZero;//pan会不停地被调用，导致不停地初始化startP，不能写在这里
//    CGPoint curP = CGPointZero;这个也是，当前点不能被不停地初始化
    if (pan.state == UIGestureRecognizerStateBegan) {
        _startP = [pan locationInView:self.scrollView];
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        //一直拖动
        _currP = [pan locationInView:_scrollView];
        NSLog(@"%@",NSStringFromCGPoint(_currP));
        //生成截取矩形范围
        CGFloat width = _currP.x - _startP.x;
        CGFloat height = _currP.y - _startP.y;
        CGRect clipRect = CGRectMake(_startP.x, _startP.y, width, height);
        //修改clipView的frame
        _clipView.frame = clipRect;
    }
    else if (pan.state == UIGestureRecognizerStateEnded){
        //----------------裁剪部分
        //开启上下文，并把view的内容渲染出来
        UIGraphicsBeginImageContextWithOptions(_scrollView.contentSize, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_scrollView.layer renderInContext:context];
        //获取渲染好的图像
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //平移绘制后的图像resultImg，开启clipView大小的上下文
        UIGraphicsBeginImageContextWithOptions(_clipView.frame.size, NO, 0);
        [image drawAtPoint:CGPointMake(-_clipView.frame.origin.x,-_clipView.frame.origin.y)];
        UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //-----------------裁剪部分
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:_clipResultView.bounds];
        imgView.image = resultImg;
        [_clipResultView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_clipResultView addSubview:imgView];
        _clipResultView.clipsToBounds = YES;
        //触摸结束了就移除clipView
        [_clipView removeFromSuperview];
        _clipView = nil;
        //移除手势?
        [_scrollView removeGestureRecognizer:pan];
    }
}

//毛玻璃按钮
- (IBAction)frostedGlassBtn:(id)sender {
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,_scrollView.contentSize.width,_scrollView.contentSize.height)];
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:_toolbar];
    
    //toolbar加一个tap消失的效果
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_toolbar addGestureRecognizer:tap];
    
}

//毛玻璃是用toolbar做的，要tap后消失
-(void)tap:(UITapGestureRecognizer *)tap
{
    [_toolbar removeFromSuperview];
    _toolbar = nil;
}
////转到UI页面（主页面）
-(void)clickbtn0
{
    
}
//
////转到scrollView页面
-(void)clickbtn1
{

}

//随机动画
- (IBAction)flyPointBtn:(id)sender {
    _count4flyPoint += 1;
    int temp = _count4flyPoint/9;//判断是第几个9，如0，2，4，6都是在前半周期，递增
    if (temp%2==0) {
        //如果是偶数个9，递增，逐渐变慢
        _timeAdd += 0.05;
    }else{
        _timeAdd -= 0.05;
    }
    UIColor *randomColor = [UIColor colorWithRed:arc4random_uniform(255)/256.0 green:arc4random_uniform(255)/256.0 blue:arc4random_uniform(255)/256.0 alpha:(arc4random_uniform(1)/1.0 + 0.3)];
    CAAnimationGroup *animationGroup = [FlyPoint getRandomAnimationWithRectView:_AnimationView andMaxofscale:2 rotation:2 x:100 y:400 color:randomColor];
    animationGroup.delegate = self;
    
    animationGroup.duration = _timeAdd;
    //设置锚点
    _RandomAnimationView.layer.anchorPoint = CGPointMake(0.5,0.5);
    
//    [_RandomAnimationView.layer addAnimation:animationGroup forKey:@"randomGroupAnimation"];
    [_RandomAnimationView.layer addAnimation:animationGroup forKey:nil];


}
#pragma mark 随机动画的animationGroup代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_count4flyPoint <18 ) {
        [self flyPointBtn:nil];
    }
    else{
        _count4flyPoint = 0;
        _timeAdd = 0;
    }
}
//歌词变色
- (IBAction)lyricBtn:(id)sender {
    _lyric2.hidden = NO; //查了网上的倒是没有设置这个的
    
    _layer4lyric = [CALayer layer];
    _layer4lyric.anchorPoint = CGPointMake(0, 0.5);
    _layer4lyric.position = CGPointMake(0, _lyric1.frame.size.height/2);
    
    _layer4lyric.bounds = CGRectMake(0, 0, 0, _lyric1.frame.size.height);
    _layer4lyric.backgroundColor = [UIColor redColor].CGColor;
    
    _lyric2.layer.mask = _layer4lyric;


    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"bounds.size.width";
    animation.toValue = @(_lyric2.bounds.size.width);
    animation.duration = 1.5;
    //动画完成时不移除
    animation.removedOnCompletion = NO;
    //动画执行完成要保持最新的动画效果
    animation.fillMode = kCAFillModeForwards;
    
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
//    animation.values = @[@(0),@(355)];
//    animation.keyTimes = @[@(0),@(1)];
//    animation.duration = 3.5;
//    animation.calculationMode = kCAAnimationLinear;
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
    //关键帧加在sub上
    [_layer4lyric addAnimation:animation forKey:@"Animation"];
    
    //添加一个指示针
    _layer = [CALayer layer];
    _layer.anchorPoint = CGPointMake(0, 0);
    _layer.position = CGPointMake(-10, 0);
    _layer.bounds = CGRectMake(0, 0, 20, _lyric1.bounds.size.height);
    _layer.backgroundColor = [UIColor cyanColor].CGColor;
    _layer.cornerRadius = _layer.bounds.size.width*0.5;
    _lyric3.layer.mask = _layer;
//    [_lyric1.layer addSublayer:_layer];
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"position.x";
    animation2.toValue = @(_lyric2.bounds.size.width);
    animation2.duration = 1.5;
    //动画完成时不移除
    animation2.removedOnCompletion = NO;
    //动画执行完成要保持最新的动画效果
    animation2.fillMode = kCAFillModeForwards;
    [_layer addAnimation:animation2 forKey:nil];
}
@end
