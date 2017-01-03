//
//  SlideControllerView.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideControllerView : UIView
@property (nonatomic, strong)UIView *aSquare;
@property (nonatomic, strong)UIView *aSlideBar;
@property (nonatomic, strong)UITextField *targetTextField;
- (instancetype)initWithFrame:(CGRect)frame andTheTargetTextField:(UITextField *)aTextField;
@end
