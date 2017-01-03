//
//  AutoHeightTextView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/2.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AutoHeightTextView.h"

@implementation AutoHeightTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)aFrame andWrapperColor:(UIColor *)aColor
{
    AutoHeightTextView *textViewWithWrapper = [[AutoHeightTextView alloc]initWithFrame:aFrame];
    self.wrapperView = [[UIView alloc]initWithFrame:aFrame];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(aFrame.origin.x+18,
                                                               aFrame.origin.y+4,
                                                               aFrame.size.width - 18*2,
                                                               aFrame.size.height - 4*2)];
    [self.wrapperView addSubview:self.textView];
    return textViewWithWrapper;
}
@end
