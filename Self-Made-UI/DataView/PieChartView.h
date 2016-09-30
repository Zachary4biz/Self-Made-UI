//
//  PieChartView.h
//  Self-Made-UI
//
//  Created by 周桐 on 16/9/23.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
@property(nonatomic,strong)NSMutableArray *pieAttrArr; //最后是[[20,UIColor],[40,UIColor],[30,UIColor]]这种，表示20度，40度的扇形

-(void)DoActions;
@end
