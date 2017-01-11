//
//  VerticalCollectionView.m
//  Self-Made-UI
//
//  Created by 周桐 on 17/1/5.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "VerticalCollectionView.h"

@interface VerticalCollectionView () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *cellDataArr;
@property (nonatomic, strong) NSString *cellIdentifier;
//@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) CollectionViewcellConfigureBlock cellConfigureBlock;
@end

@implementation VerticalCollectionView
//使用默认的VerticalLayout
- (instancetype)initWithFrame:(CGRect)aFrame
                      dataArr:(NSMutableArray *)aDataArr
               cellIdentifier:(NSString *)aCellIdentifier
                     cellSize:(CGSize)aCellSize
               configureBlock:(CollectionViewcellConfigureBlock)aConfigureBlock;
{
    VerticalFlowLayout *aFlowLayout = [[VerticalFlowLayout alloc]init];
    aFlowLayout.itemSize = aCellSize;
    aFlowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    return [self initWithFrame:aFrame
                       dataArr:aDataArr
                cellIdentifier:aCellIdentifier
                verticalLayout:aFlowLayout
                configureBlock:aConfigureBlock];
}

//自定义layout来创建
- (instancetype)initWithFrame:(CGRect)aFrame
                      dataArr:(NSMutableArray *)aDataArr
               cellIdentifier:(NSString *)aCellIdentifier
               verticalLayout:(VerticalFlowLayout *)aVerticalLayout
               configureBlock:(CollectionViewcellConfigureBlock)aConfigureBlock;
{
    if (self = [super initWithFrame:aFrame collectionViewLayout:aVerticalLayout]) {
        self.dataSource = self;
        self.cellDataArr = aDataArr;
        self.cellIdentifier = aCellIdentifier;
        self.cellConfigureBlock = aConfigureBlock;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:aCellIdentifier];
    }
    return self;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellDataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id data = self.cellDataArr[indexPath.row];
    if (self.cellConfigureBlock) {
        self.cellConfigureBlock(data,aCell);
    }else{
        NSLog(@"WARNING--没有实现传出数据和cell的block");
    }
    return aCell;
}

#pragma mark UICollectionViewDelegateFlowLayout

@end
