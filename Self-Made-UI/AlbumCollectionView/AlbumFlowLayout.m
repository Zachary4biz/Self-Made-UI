//
//  AlbumFlowLayout.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/10/13.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AlbumFlowLayout.h"
@interface AlbumFlowLayout()
@property(nonatomic,strong)NSArray *arr;

@end

@implementation AlbumFlowLayout

-(instancetype)init
{
    if (self = [super init]) {
//        UICollectionViewLayoutAttributes *attrs;
        //一个cell对应一个UICollectionViewLayoutAttributes对象

    }
    return self;
}

//用来做布局的初始化操作
-(void)prepareLayout
{
    [super prepareLayout];
    
    //设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

//只要bounds改变就刷新layout，意思就是滑动了就刷新layout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//决定布局属性，RECT参数意思是，算这个rect内的所有cell的layout属性
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //获得super按默认大小计算的布局
    NSArray *original =[super layoutAttributesForElementsInRect:rect];
    _arr = [[NSArray alloc]initWithArray:original copyItems:YES];
    
    //计算collectionView的中心X值--首先是移动到哪里了（可以理解为屏幕左侧在哪里）contentOffset，然后是一半的宽度
    CGFloat centerX4collectionView = self.collectionView.contentOffset.x+self.collectionView.frame.size.width*0.5;
    
    // 在原有布局属性的基础上，调整
    for (UICollectionViewLayoutAttributes *attrs in _arr)
    {
        //调整一下大小
        attrs.size = CGSizeMake(100, 150);
        NSLog(@"w,h is %f,%f",attrs.size.width,attrs.size.height);
        //cell的中心点x和collectionView的中心点的距离，并按比例算缩放
        //1.间距
        CGFloat delta = ABS(attrs.center.x - centerX4collectionView);
        //2.缩放比例
        CGFloat scale = 1 - delta/(self.collectionView.frame.size.width);
        //设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
//    NSLog(@"%@",arr);
//    return original;
    return _arr;
}
//这个返回值控制了collec停止滚动时的偏移量
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //参数proposedContentOffset是停止时的位移，表示本应该停在哪里
    //找到停止滚动时的rect，然后算这个rect里面cell的layout
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    CGFloat centerX4collectionView = self.collectionView.contentOffset.x+self.collectionView.frame.size.width*0.5;
    
    //判断哪个cell里当前的中心点最近，就返回这个cell的中心点，就是找出最小的delta
    CGFloat minDelta = MAXFLOAT;
    for(UICollectionViewLayoutAttributes *attrs in _arr)
    {
        if (ABS(minDelta) > ABS(centerX4collectionView - attrs.center.x)) {
            minDelta = centerX4collectionView - attrs.center.x;
        }
    }
    //修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}
@end
