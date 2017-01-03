//
//  FixChineseCharacterOffsetTextField.m
//  Self-Made-UI
//
//  Created by 周桐 on 17/1/3.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "FixChineseCharacterOffsetTextField.h"

@implementation FixChineseCharacterOffsetTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 0, 3);
//}
#pragma mark 不推荐用这个方法，首先这个数字是一点点调试出来，是写死的，另外这个方法因为会调用很多次，绘制多了会有很明显的类似阴影的东西在后面。最后这个方法可能会影响渲染。
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 7, 2);
//}
@end
