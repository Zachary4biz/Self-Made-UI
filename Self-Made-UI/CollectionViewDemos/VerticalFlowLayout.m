//
//  VerticalFlowLayout.m
//  Self-Made-UI
//
//  Created by 周桐 on 17/1/5.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "VerticalFlowLayout.h"

@implementation VerticalFlowLayout
static NSInteger scaleParam = 0.3;
- (instancetype)initWithItemSize:(CGSize)anItemSize
{
    if (self = [super init]) {
        self.itemSize = anItemSize;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        NSLog(@"使用的缩放参数是%ld",(long)scaleParam);
    }
    return self;
}

- (instancetype)initWithItemSize:(CGSize)anItemSize andScaleParam:(NSInteger)aScaleParam
{
    scaleParam = aScaleParam;
    return [self initWithItemSize:anItemSize];
}

//自定义布局
//初始化
- (void)prepareLayout
{
    [super prepareLayout];
    
    //...
    self.sectionInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
}

//滑动后使layout失效，效果就是会更新
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//返回layout需要的属性
static CGFloat inset = 0.0;
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"\n\n");
    NSLog(@"当前的rect是 %@",NSStringFromCGRect(rect));
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *target = [[NSArray alloc]initWithArray:original copyItems:YES];
    //计算collectionView的顶部那个叠放各个Tab的地方 -- 即 contentOffset.y+staticInset
    CGFloat topY = self.collectionView.contentOffset.y + inset;
    NSLog(@"topY应该是 %lf",topY);
    for (UICollectionViewLayoutAttributes *attr in target)
    {
        //当前这个Elements的Y距离topY有多少
        NSLog(@"\n");
        NSLog(@"当前这个element的属性地址是 %p",attr);
        NSLog(@"当前这个element的origin.y 是 %lf",attr.frame.origin.y);
        CGFloat delta = attr.frame.origin.y - topY;
        NSLog(@"当前这个element距离topY有 %lf",delta);
        if (delta >=0) {
            //大于0时，意味着还在topY下面，根据这个delta计算缩放
            CGFloat scale = (delta/60)>=1?1:(delta/60);
            attr.transform = CGAffineTransformMakeScale(scale, 1);
        }else{
            //小于0时，意味着已经超过topY了，直接缩放到0
            CGFloat scale = 0;
            attr.transform = CGAffineTransformMakeScale(scale, 1);
        }
    }
    
    return target;
}

@end
