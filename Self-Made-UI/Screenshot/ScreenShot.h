//
//  ScreenShotView.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/26.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenShot : NSObject
-(void)screenshotFromPanWithView:(UIView *)view;
@property(nonatomic,strong)void(^imgBlock)(UIImage *img); //搞一个用来在pan结束后传图片回来的block
@end
