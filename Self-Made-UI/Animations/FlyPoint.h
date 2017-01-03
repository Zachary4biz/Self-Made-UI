//
//  FlyPoint.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FlyPoint : NSObject

+(CAAnimationGroup *)getRandomAnimationWithRectView:(UIView *)view andMaxofscale:(int)scaleMax rotation:(int)rotationMax x:(int)xMax y:(int)yMax color:(UIColor*)color;
@end
