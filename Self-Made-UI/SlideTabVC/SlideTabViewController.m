//
//  SlideTabViewController.m
//  Self-Made-UI
//
//  Created by Zac on 2017/2/14.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "SlideTabViewController.h"
#import "Masonry.h"

@interface SlideTabViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pagesViewWrapper;
@property (nonatomic, strong) UIView *firstPageView;
@property (nonatomic, strong) UIView *secondPageView;
@property (nonatomic, strong) UIView *thirdPageView;

@property (nonatomic, strong) UIView *tabsViewWrapper;
@property (nonatomic, strong) UIButton *firstTabBtn;
@property (nonatomic, strong) UIButton *secondTabBtn;
@property (nonatomic, strong) UIButton *thirdTabBtn;

@property (nonatomic, strong) UIView *shadowTabsViewWrapper;
@property (nonatomic, strong) UIButton *shadowFirstTabBtn;
@property (nonatomic, strong) UIButton *shadowSecondTabBtn;
@property (nonatomic, strong) UIButton *shadowThirdTabBtn;

@property (nonatomic, strong) CALayer *layer;


@property (nonatomic, assign) CGFloat pagesWidth;
@property (nonatomic, assign) CGFloat tabsWidth;
@property (nonatomic, assign) CGFloat tabsViewWrapperHeight;
@property (nonatomic, assign) CGFloat tabsBtnHorizontalInset;
@property (nonatomic, assign) CGFloat pagesViewHorizontalInset;
@property (nonatomic, strong) UIColor *firstC;
@property (nonatomic, strong) UIColor *secondC;
@property (nonatomic, strong) UIColor *thirdC;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *shadowColor;

@end

@implementation SlideTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UILabel *a = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, 270, 30)];
//    a.text = @"------------------------------------ ------------------------------ ------------------------------ ------------------------------ ------------------------------ ------------------------------ ------------------------------";
//    [self.view addSubview:a];
    
    [self setUpParams];
    
    [self createAllViews];
    
    [self setUpLayout];
    
    self.pagesViewWrapper.delegate = self;
    
    

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLayoutSubviews
{
    self.layer = [self createMaskLayerFor:self.tabsViewWrapper
                               withBounds:CGRectMake(0, 0, self.tabsWidth, self.firstTabBtn.frame.size.height)
                              AnchorPoint:CGPointMake(0, 0)
                                 Position:CGPointMake(self.tabsBtnHorizontalInset, self.firstTabBtn.frame.origin.y)];
    self.tabsViewWrapper.layer.mask = self.layer;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double k = 1.0*(self.secondTabBtn.frame.origin.x - self.firstTabBtn.frame.origin.x)/scrollView.frame.size.width;
    NSLog(@"position is %lf",self.tabsBtnHorizontalInset+scrollView.contentOffset.x*k);
    self.layer.position = CGPointMake(self.tabsBtnHorizontalInset+scrollView.contentOffset.x*k, self.layer.position.y);
}

#pragma mark - Layer动画
/*
 * 这里想法是给整个tabViewWrapper加上maskLayer
 * 然后初始情况下这个maskLayer长度只够显示firstTabBtn
 */
- (CALayer *)createMaskLayerFor:(UIView *)aView withBounds:(CGRect)bounds AnchorPoint:(CGPoint)anchorPoint Position:(CGPoint)position
{
    CALayer *aLayer = [[CALayer alloc]init];
    aLayer.anchorPoint = anchorPoint; //layer自己的锚点在左上角
    aLayer.position = position;  //layer的锚点在view的左上角
    aLayer.bounds = bounds;
#warning 这里还是必须要给一个颜色，虽然不会照这个颜色来，但是不给颜色会是透明的
    aLayer.backgroundColor = [UIColor cyanColor].CGColor;
    aLayer.cornerRadius = 6;
    return aLayer;
}

- (CABasicAnimation *)layerAnimationWithKeyPath:(NSString *)keyPath toValue:(NSNumber*)value duration:(NSUInteger)duration
{
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = keyPath;
    animation2.toValue = value;
    animation2.duration = duration;
    //动画完成时不移除
    animation2.removedOnCompletion = NO;
    //动画执行完成要保持最新的动画效果
    animation2.fillMode = kCAFillModeForwards;
    
    return animation2;
}


#pragma mark - 封装
#pragma mark  Params
- (void)setUpParams
{
    self.pagesWidth = self.view.frame.size.width - 16;
    self.tabsWidth = 90;
    self.tabsViewWrapperHeight = 40;
    self.tabsBtnHorizontalInset = 8;
    self.pagesViewHorizontalInset = 8;
    
    self.firstC = [UIColor cyanColor];
    self.secondC = [UIColor magentaColor];
    self.thirdC = [UIColor orangeColor];
    self.sliderColor = [UIColor blueColor];
    self.shadowColor = [UIColor colorWithWhite:0.94 alpha:1.0];
}
#pragma mark  Create
- (void)createAllViews
{
    //pagesView
    self.pagesViewWrapper = [[UIScrollView alloc]init];
    self.pagesViewWrapper.pagingEnabled = YES;
    
    self.firstPageView = [self createNewPageView];
    self.secondPageView = [self createNewPageView];
    self.thirdPageView = [self createNewPageView];
    
    //tabsView
    self.tabsViewWrapper = [[UIView alloc]init];
    
    self.firstTabBtn = [self createNewTabBtnWithTitle:@"first"
                                           andHandler:@selector(firstTabBtnHandler:)];
    self.secondTabBtn = [self createNewTabBtnWithTitle:@"second"
                                            andHandler:@selector(secondTabBtnHandler:)];
    self.thirdTabBtn = [self createNewTabBtnWithTitle:@"third"
                                           andHandler:@selector(thirdTabBtnHandler:)];
    
    [self.firstTabBtn setTitleColor:self.firstC forState:UIControlStateNormal];
    [self.secondTabBtn setTitleColor:self.secondC forState:UIControlStateNormal];
    [self.thirdTabBtn setTitleColor:self.thirdC forState:UIControlStateNormal];
    
    //shadowTabsView
    self.shadowTabsViewWrapper = [[UIView alloc]init];
    self.shadowFirstTabBtn = [self createNewShadowTabBtnWithTitle:@"first"];
    self.shadowSecondTabBtn = [self createNewShadowTabBtnWithTitle:@"second"];
    self.shadowThirdTabBtn = [self createNewShadowTabBtnWithTitle:@"third"];
    
    self.shadowFirstTabBtn.enabled = NO;
    self.shadowSecondTabBtn.enabled = NO;
    self.shadowThirdTabBtn.enabled = NO;
    [self.shadowFirstTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shadowSecondTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shadowThirdTabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    //self.view addSubView
    [self.view addSubview:self.pagesViewWrapper];
    [self.view addSubview:self.shadowTabsViewWrapper];
    [self.view addSubview:self.tabsViewWrapper];
    
}

- (UIView *)createNewPageView
{
    UIView *aPageView = [[UIView alloc]init];
    aPageView.layer.cornerRadius = 10;
    [self.pagesViewWrapper addSubview:aPageView];
    return aPageView;
}
- (UIButton *)createNewTabBtnWithTitle:(NSString *)title andHandler:(SEL)handler
{
    UIButton *aTabBtn = [[UIButton alloc]init];
    aTabBtn.layer.cornerRadius = 5;
    [aTabBtn setTitle:title forState:UIControlStateNormal];
    [aTabBtn addTarget:self action:handler forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabsViewWrapper addSubview:aTabBtn];
    return aTabBtn;
}
- (UIButton *)createNewShadowTabBtnWithTitle:(NSString *)title
{
    UIButton *aTabBtn = [[UIButton alloc]init];
    aTabBtn.layer.cornerRadius = 5;
    [aTabBtn setTitle:title forState:UIControlStateNormal];
    [aTabBtn setBackgroundColor:self.shadowColor];
    [self.shadowTabsViewWrapper addSubview:aTabBtn];
    return aTabBtn;
}

#pragma mark - 响应
- (void)firstTabBtnHandler:(id)sender
{
    [self.pagesViewWrapper setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)secondTabBtnHandler:(id)sender
{
    [self.pagesViewWrapper setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

- (void)thirdTabBtnHandler:(id)sender
{
    [self.pagesViewWrapper setContentOffset:CGPointMake(2*self.view.frame.size.width, 0) animated:YES];
}
#pragma mark - Layout
/*
 *   -----------------------------
 *  |      tabsViewWrapper        |
 *  |     ------------------      |
 *  |    |  tabsView *3     |     |
 *  |     ------------------      |
 *   -----------------------------
 *  |      pagesViewWrapper       |
 *  |     ------------------      |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |   pagesView *3   |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |    |                  |     |
 *  |     ------------------      |
 *  |                             |
 *   -----------------------------
 */

//pagesViewWrapper和tabsViewWrapper相对self.view的约束
- (void)setUpLayout
{
    //tabsViewWrapper
    [self.tabsViewWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.tabsViewWrapperHeight);
    }];
    
    //SHADOW
    [self.shadowTabsViewWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.tabsViewWrapperHeight);
    }];
    
    
    //pagesViewWrapper
    [self.pagesViewWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabsViewWrapper.mas_bottom).offset(6);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-8);
    }];
    
    
    //color
    self.tabsViewWrapper.backgroundColor = self.sliderColor;
    
    //tabs&pages
    [self setUpTabsViewLayout];
    [self setUpPagesViewLayout];
}
//pageView相对pagesViewWrapper的约束
- (void)setUpPagesViewLayout
{
    [self.firstPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pagesViewWrapper.mas_top);
        make.left.mas_equalTo(self.pagesViewWrapper.mas_left).offset(self.pagesViewHorizontalInset);
        make.right.mas_equalTo(self.secondPageView.mas_left).offset(-2*self.pagesViewHorizontalInset);
        make.height.mas_equalTo(self.pagesViewWrapper.mas_height);
        make.width.mas_equalTo(self.pagesWidth);
    }];
    
    
    [self.secondPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstPageView.mas_top);
        make.left.mas_equalTo(self.firstPageView.mas_right).offset(2*self.pagesViewHorizontalInset);
        make.right.mas_equalTo(self.thirdPageView.mas_left).offset(-2*self.pagesViewHorizontalInset);
        make.height.mas_equalTo(self.firstPageView.mas_height);
        make.width.mas_equalTo(self.pagesWidth);
    }];
    
    
    [self.thirdPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstPageView.mas_top);
        make.left.mas_equalTo(self.secondPageView.mas_right).offset(2*self.pagesViewHorizontalInset);
        make.right.mas_equalTo(self.pagesViewWrapper.mas_right).offset(-self.pagesViewHorizontalInset);
        make.height.mas_equalTo(self.firstPageView.mas_height);
        make.width.mas_equalTo(self.pagesWidth);
    }];
    
    
    self.firstPageView.backgroundColor = [UIColor cyanColor];
    self.secondPageView.backgroundColor = [UIColor magentaColor];
    self.thirdPageView.backgroundColor = [UIColor orangeColor];
}
//tabs相对tabsViewWrapper的约束
- (void)setUpTabsViewLayout
{
    //以中间的为准
    [self.secondTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabsViewWrapper.mas_top).offset(6);
        make.bottom.mas_equalTo(self.tabsViewWrapper.mas_bottom);
        make.centerX.mas_equalTo(self.tabsViewWrapper.mas_centerX);
        make.width.mas_equalTo(self.tabsWidth);
    }];
    
    [self.firstTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondTabBtn.mas_top);
        make.bottom.mas_equalTo(self.secondTabBtn.mas_bottom);
        make.left.mas_equalTo(self.tabsViewWrapper.mas_left).offset(self.tabsBtnHorizontalInset);
        make.width.mas_equalTo(self.secondTabBtn);
    }];
    
    [self.thirdTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondTabBtn.mas_top);
        make.bottom.mas_equalTo(self.secondTabBtn.mas_bottom);
        make.width.mas_equalTo(self.secondTabBtn);
        make.right.mas_equalTo(self.tabsViewWrapper.mas_right).offset(-self.tabsBtnHorizontalInset);
    }];
    
    
    //shadow
    [self.shadowSecondTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shadowTabsViewWrapper.mas_top).offset(6);
        make.bottom.mas_equalTo(self.shadowTabsViewWrapper.mas_bottom);
        make.centerX.mas_equalTo(self.shadowTabsViewWrapper.mas_centerX);
        make.width.mas_equalTo(self.tabsWidth);
    }];
    
    [self.shadowFirstTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shadowSecondTabBtn.mas_top);
        make.bottom.mas_equalTo(self.shadowSecondTabBtn.mas_bottom);
        make.left.mas_equalTo(self.shadowTabsViewWrapper.mas_left).offset(self.tabsBtnHorizontalInset);
        make.width.mas_equalTo(self.shadowSecondTabBtn);
    }];
    
    [self.shadowThirdTabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shadowSecondTabBtn.mas_top);
        make.bottom.mas_equalTo(self.shadowSecondTabBtn.mas_bottom);
        make.width.mas_equalTo(self.shadowSecondTabBtn);
        make.right.mas_equalTo(self.shadowTabsViewWrapper.mas_right).offset(-self.tabsBtnHorizontalInset);
    }];

    
//    self.secondTabBtn.backgroundColor = [UIColor magentaColor];
//    self.firstTabBtn.backgroundColor = [UIColor cyanColor];
//    self.thirdTabBtn.backgroundColor = [UIColor orangeColor];
}


@end
