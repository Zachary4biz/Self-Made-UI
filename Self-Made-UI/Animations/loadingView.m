//
//  loadingView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "loadingView.h"

@implementation loadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    CGRect frame4scrollView = [UIScreen mainScreen].bounds;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame4scrollView];

//     _factor = MIN(1, MAX(0, (ABS(scrollView.contentOffset.x - self.lastContentOffset) / scrollView.frame.size.width)));
}

@end
