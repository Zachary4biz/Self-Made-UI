//
//  AutoHeightTextView.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/2.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoHeightTextView : UIView
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *wrapperView;
- (instancetype)initWithFrame:(CGRect)aFrame andWrapperColor:(UIColor *)aColor;
@end
