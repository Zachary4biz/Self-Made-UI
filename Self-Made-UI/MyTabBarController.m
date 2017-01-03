//
//  MyTabBarController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "MyTabBarController.h"
#import "ViewController.h"
#import "SwitchScrollViewViewController.h"
#import "AlbumCollectionViewController.h"
#import "FirstViewController.h"
@interface MyTabBarController ()<UIScrollViewDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //2.1添加子VC
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *VC4UIAnimation = [storyboard instantiateInitialViewController];
    [self createChildVC:VC4UIAnimation title:@"UIAnimation" imageName:@"1_gray" selectedImageName:@"1"];
    [self createChildVC:[[SwitchScrollViewViewController alloc]init] title:@"Transition" imageName:@"2_gray" selectedImageName:@"2"];
    [self createChildVC:[[AlbumCollectionViewController alloc]init] title:@"Album" imageName:@"2_gray" selectedImageName:@"2"];
    [self createChildVC:[[FirstViewController alloc]init] title:@"Transition2" imageName:@"2_gray" selectedImageName:@"2"];
    //设置attributes
    [self setUpAttributes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
#warning 如何用代码让childViewCOntroller下部距离TabBar49？？ vc.view -- self.view -- bottomconstraint报错
    
    vc.tabBarItem.title = title;
    UIImage *image = [UIImage imageNamed:imageName];
    [image imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    [self addChildViewController:vc];
}

-(void)setUpAttributes
{
    //通过appearance获取
    UITabBarItem *item = [UITabBarItem appearance];
    //normal状态的item属性字典
    NSMutableDictionary *attributes4normal = [NSMutableDictionary dictionary];
    attributes4normal[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attributes4normal[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    //selected状态的item的属性字典
    NSMutableDictionary *attributes4selected = [NSMutableDictionary dictionary];
    attributes4selected[NSFontAttributeName] = attributes4normal[NSFontAttributeName];
    attributes4selected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    //统一设置所有item的属性
    [item setTitleTextAttributes:attributes4normal forState:UIControlStateNormal];
    [item setTitleTextAttributes:attributes4selected forState:UIControlStateSelected];
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
