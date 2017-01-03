//
//  SecondViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/11/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SecondViewController.h"
#import "TransitionManager.h"
@interface SecondViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
- (IBAction)dismissBtn:(id)sender;

@end

@implementation SecondViewController
#pragma mark 重写init方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    TransitionManager *manager = [[TransitionManager alloc]init];
    manager.type = TransitionTypePresent;
    return manager;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TransitionManager *manager = [[TransitionManager alloc]init];
    manager.type = TransitionTypeDismiss;
    return manager;
}
- (IBAction)dismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
