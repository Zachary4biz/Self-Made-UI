//
//  DownloadProgressView.h
//  DownloadXib
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

//使用时，读取到xib，实例化之后，直接在主线程赋值.progress=xxx就行了
@interface DownloadProgressView : UIView
@property (weak, nonatomic) IBOutlet UILabel *downloadProgressLbl;
@property(assign,nonatomic)float progress;
-(void)changeLbl;
@end
