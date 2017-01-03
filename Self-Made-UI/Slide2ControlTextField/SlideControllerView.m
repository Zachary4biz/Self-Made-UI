//
//  SlideControllerView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SlideControllerView.h"

@implementation SlideControllerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andTheTargetTextField:(UITextField *)aTextField
{
    if (self = [super initWithFrame:frame]) {
        CGRect frame4SlideBar = CGRectMake(0, 2, frame.size.width, frame.size.height-2*2);
        CGRect frame4Square = CGRectMake(0.5*frame.size.width-0.5*frame.size.height, 0, frame.size.height, frame.size.height);
        _aSquare = [[UIView alloc]initWithFrame:frame4Square];
        _aSquare.backgroundColor = [UIColor cyanColor];
        _aSlideBar = [[UIView alloc]initWithFrame:frame4SlideBar];
        _aSlideBar.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        [self addSubview:_aSlideBar];
        [self addSubview:_aSquare];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [_aSquare addGestureRecognizer:panGestureRecognizer];
        
        self.targetTextField = aTextField;
//        self.targetTextField caretRectForPosition:<#(nonnull UITextPosition *)#>
        
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)aPanGestureRecognizer
{
    //这里的sender就是_aSquare
    CGPoint gesturePoint = [aPanGestureRecognizer translationInView:self.aSlideBar];
    NSLog(@"%@",(NSStringFromCGPoint(gesturePoint)));
    self.aSquare.transform = CGAffineTransformMakeTranslation(gesturePoint.x, 0);
//    self.aSquare.transform = CGAffineTransformTranslate(self.aSquare.transform, gesturePoint.x, 0);
//    [aPanGestureRecognizer setTranslation:CGPointZero inView:self.aSlideBar];
    NSLog(@"%@",(NSStringFromCGAffineTransform( self.aSquare.transform)));
    NSLog(@"%@",(NSStringFromCGPoint(self.aSquare.center)));
    if (aPanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.aSquare.transform = CGAffineTransformIdentity;
    }
}
@end
