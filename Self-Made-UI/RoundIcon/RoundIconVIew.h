//
//  RoundIconVIew.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundIconView : UIView
@property(nonatomic,strong) UIImage * icon;
+(UIImage *)getRoundIconWithImage:(UIImage *)image circleBorder:(CGFloat) border circleColor:(UIColor *)color;
@end
