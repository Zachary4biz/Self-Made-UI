//
//  TestViewControllerOnSlide2ControlTextField.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TestViewControllerOnSlide2ControlTextField.h"
#import "SlideControllerView.h"
#import <WebKit/WebKit.h>
@interface TestViewControllerOnSlide2ControlTextField ()<UIScrollViewDelegate>

@end

@implementation TestViewControllerOnSlide2ControlTextField

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITextField *aTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 200, 30)];
    aTextField.text = @"开始--as;dlkfjasova;ls大；厉害；看看几率爱对方感到父kjadls;fjiofqwet看几率爱对方感到父kjadls;fjiof看几率爱对方感到父kjadls;fjiof看几率爱对方感到父kjadls;fjiof看几率爱对方感到父kjadls;fjiof看几率爱对方感到父kjadls;fjiof看几率爱对方感到父kjadls;fjiof--结束";
    [aTextField setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:aTextField];
    SlideControllerView *theControlView = [[SlideControllerView alloc]initWithFrame:CGRectMake(30, 200, 300, 25) andTheTargetTextField:aTextField];
    [self.view addSubview:theControlView];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",(NSStringFromCGPoint(scrollView.contentOffset)));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
