//
//  BarGraphView.m
//  UWeChat
//
//  Created by yc on 2018/4/26.
//  Copyright © 2018年 jemmy. All rights reserved.
//

#import "BarGraphView.h"


@interface BarGraphView()

/// 背景网格
@property (nonatomic,strong) UIView *gridView;
///
@property (nonatomic,strong) NSMutableArray <UIBezierPath *> *paths;
/// 圆柱宽度
@property (nonatomic,assign) CGFloat width;
/// 圆柱间隔
@property (nonatomic,assign) CGFloat space;
/// 最大数值（总和）
@property (nonatomic,assign) CGFloat sum;

@end


@implementation BarGraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.space = 20;
    }
    return self;
}
- (void)setData:(NSArray <NSNumber *>*)numbers colors:(NSArray <UIColor *>*)colors
{
    [self.layer removeAllSublayers];
    [self.paths removeAllObjects];
    self.width = (self.frame.size.width - (self.space * (numbers.count + 1)))/numbers.count ;
    self.sum = 0;
    for (NSNumber *number in numbers) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        self.sum += [number doubleValue];
        [self.layer addSublayer:layer];
    }
    for(int i = 0; i < self.layer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer *)self.layer.sublayers[i];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGFloat pointX = self.space * i +  i * self.width + self.space + self.width/2;
        CGPoint point = CGPointMake(pointX, CGRectGetMaxY(self.bounds));
        [path moveToPoint:point];
        CGFloat pointY = self.self.bounds.size.height -  self.bounds.size.height/self.sum * [numbers[i] doubleValue];
        [path addLineToPoint:CGPointMake(pointX, pointY)];
        layer.lineCap = kCALineJoinMiter ;
        layer.strokeColor = colors[i].CGColor;
        layer.fillColor = colors[i].CGColor;
        layer.lineWidth = self.width;
        layer.path = path.CGPath;
        UIGraphicsBeginImageContext(self.bounds.size);
        [path stroke];
        [path fill];
        UIGraphicsEndImageContext();
    }
       [self stroke];
}
- (void)stroke{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = NO;
    //让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    for (CAShapeLayer *layer in self.layer.sublayers) {
         [layer addAnimation:animation forKey:@"strokeEnd"];
    }
}

@end
