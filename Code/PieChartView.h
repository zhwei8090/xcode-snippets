//
//  PieChartView.h
//  UWeChat
//
//  Created by yc on 2018/4/26.
//  Copyright © 2018年 jemmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView
- (void)setData:(NSArray <NSNumber *>*)numbers colors:(NSArray <UIColor *>*)colors;
- (void)stroke;
@end
