//
//  VerticalFlowLayout.h
//  Self-Made-UI
//
//  Created by 周桐 on 17/1/5.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalFlowLayout : UICollectionViewFlowLayout
- (instancetype)initWithItemSize:(CGSize)anItemSize;
- (instancetype)initWithItemSize:(CGSize)anItemSize andScaleParam:(NSInteger)aScaleParam;
@end
