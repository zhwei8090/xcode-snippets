//
//  PieChartView.m
//  UWeChat
//
//  Created by yc on 2018/4/26.
//  Copyright © 2018年 jemmy. All rights reserved.
//

#import "PieChartView.h"


#define SelfWidth self.frame.size.width
#define Sum 100
#define ZWOffsetRadius 10 //便宜距离

@interface ZWShapeLayer:CAShapeLayer
@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;
@end

@implementation ZWShapeLayer
@end
@interface PieChartView()
{
    CAShapeLayer *_maskLayer;
    /// 半径
    CGFloat _radius;
    /// 圆心
    CGPoint _center;
}
@end

@implementation PieChartView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _radius = SelfWidth/4;
        _center = self.center;
        _maskLayer = [CAShapeLayer layer];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
        _maskLayer.strokeColor = [UIColor greenColor].CGColor;
        _maskLayer.lineWidth = self.bounds.size.width/2;
        //设置填充颜色为透明，可以通过设置半径来设置中心透明范围
        _maskLayer.fillColor = [UIColor clearColor].CGColor;
        _maskLayer.path = maskPath.CGPath;
        self.layer.mask = _maskLayer;
    }
    return self;
}
- (void)setData:(NSArray<NSNumber *> *)numbers colors:(NSArray<UIColor *> *)colors
{
    [self.layer removeAllSublayers];
    CGFloat start = -M_PI_2;
    CGFloat end = start;
    double sum = 0;
    for (NSNumber *number in numbers) {
        ZWShapeLayer *layer = [ZWShapeLayer layer];
        [self.layer addSublayer:layer];
        sum += [number doubleValue];
    }
    double _sectorSpace = 0;
    for (int i = 0; i < self.layer.sublayers.count; i++) {
            ZWShapeLayer *pieLayer = (ZWShapeLayer *)self.layer.sublayers[i];
            end =  start + (2*M_PI/sum*[numbers[i] doubleValue]);
            UIBezierPath *piePath = [UIBezierPath bezierPath];
            [piePath moveToPoint:_center];
            [piePath addArcWithCenter:_center radius:_radius*2 startAngle:start endAngle:end clockwise:YES];
            pieLayer.fillColor = colors[i].CGColor;
            pieLayer.lineCap = kCALineJoinRound ;
            pieLayer.startAngle = start;
            pieLayer.endAngle = end;
            pieLayer.path = piePath.CGPath;
            start = end + _sectorSpace;
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
    [_maskLayer addAnimation:animation forKey:@"strokeEnd"];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [touches.anyObject locationInView:self];
//    [self upDateLayersWithPoint:point];
//}
//- (void)upDateLayersWithPoint:(CGPoint)point{
//
//    for (ZWShapeLayer *layer in self.layer.sublayers) {
//        if (CGPathContainsPoint(layer.path, &CGAffineTransformIdentity, point, 0)) {
//            CGPoint currPos = layer.position;
//            double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
//            CGPoint newPos = CGPointMake(currPos.x + ZWOffsetRadius*cos(middleAngle), currPos.y + ZWOffsetRadius*sin(middleAngle));
//            layer.position = newPos;
//        }else{
//            layer.position = CGPointMake(0, 0);
//        }
//    }
//}

@end
