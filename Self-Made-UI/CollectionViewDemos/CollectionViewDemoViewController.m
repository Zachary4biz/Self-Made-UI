//
//  CollectionViewDemoViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 17/1/5.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "CollectionViewDemoViewController.h"
#import "VerticalCollectionView.h"
@interface CollectionViewDemoViewController ()

@end

@implementation CollectionViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    NSMutableArray *aDataArr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"1"],
                                [UIImage imageNamed:@"2"],
                                [UIImage imageNamed:@"3"],
                                [UIImage imageNamed:@"4"], nil];
    NSString *aCellIdentifier = @"cellIdentifier";
    
    VerticalCollectionView *verticalCollectionView = [[VerticalCollectionView alloc]initWithFrame:CGRectMake(40, 20, 300, 500)
                                                                                          dataArr:aDataArr
                                                                                   cellIdentifier:aCellIdentifier
                                                                                         cellSize:CGSizeMake(240, 460)
                                                                                   configureBlock:^(id data, __kindof UICollectionViewCell *cell) {
                                                                                       UIImageView *IMGView = [[UIImageView alloc]initWithImage:data];
                                                                                       IMGView.frame = cell.bounds;
                                                                                       [cell.contentView addSubview:IMGView];
                                                                                   }];
//    verticalCollectionView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    [self.view addSubview:verticalCollectionView];
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
