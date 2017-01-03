//
//  TransitionManager.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/11/8.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//枚举，分别管理present和dismiss的转场动画
typedef enum {
    TransitionTypePresent = 0,
    TransitionTypeDismiss
}TransitionType;

@interface TransitionManager : NSObject
@property (nonatomic, assign) TransitionType type;
@end
