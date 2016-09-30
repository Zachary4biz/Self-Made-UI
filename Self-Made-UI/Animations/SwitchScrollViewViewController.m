//
//  SwitchScrollViewViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SwitchScrollViewViewController.h"

@interface SwitchScrollViewViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign)CGFloat factor;
@end

@implementation SwitchScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView = [[UIScrollView alloc]init];
    

    
}

-(void)viewDidLayoutSubviews
{
    _scrollView.frame = self.view.frame;
    _scrollView.contentSize = CGSizeMake(4 * self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    _factor = MIN(1, MAX(0, (ABS(_scrollView.contentOffset.x - self.lastContentOffset) / _scrollView.frame.size.width)));
//    CGPoint pointA = CGPointMake(rectCenter.x ,self.currentRect.origin.y + extra);
//    CGPoint pointB = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? rectCenter.x + self.currentRect.size.width/2 : rectCenter.x + self.currentRect.size.width/2 + extra*2 ,rectCenter.y);
//    CGPoint pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.currentRect.size.height/2 - extra);
//    CGPoint pointD = CGPointMake(self.scrollDirection == ScrollDirectionLeft ? self.currentRect.origin.x - extra*2 : self.currentRect.origin.x, rectCenter.y);

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
