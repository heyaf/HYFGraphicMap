//
//  UIView+ViewLayer.m
//  LocationPointApp
//
//  Created by iOS on 2019/9/23.
//  Copyright © 2019 jiaxiangpai. All rights reserved.
//

#import "UIView+ViewLayer.h"
#import "CalculatorLocationTool.h"

@implementation UIView (ViewLayer)
-(void)drawCurvewithImage:(NSString *)image Array:(NSArray *)lineArr ishu:(NSInteger) ishu TopLeftPoint:(CLLocationCoordinate2D)topleftPoint TopRightPoint:(CLLocationCoordinate2D)topright LeftBottom:(CLLocationCoordinate2D)leftBottom linewidth:(CGFloat)width color:(UIColor*)color{
    
    CalculatorLocationTool *calculatorTool = [[CalculatorLocationTool alloc] init];
    calculatorTool.leftToplocation = topleftPoint;
    calculatorTool.leftBottomLocation = leftBottom;
    calculatorTool.rightTopLocation = topright;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (int i=0; i<lineArr.count; i++) {
        CLLocationCoordinate2D coor;
        NSValue *value = lineArr[i];
        [value getValue:&coor];
        
        CLLocationCoordinate2D coor1 = [calculatorTool getLocationWithImage:image location:coor];
        if (i==0) {
            // 起点
            [linePath moveToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }else if(ishu&&i<lineArr.count-2){
            
            CGPoint p0 = [self GetPointWithvalue:lineArr[i-1] Tool:calculatorTool image:image];
            CGPoint p1 = [self GetPointWithvalue:lineArr[i] Tool:calculatorTool image:image];
            CGPoint p2 = [self GetPointWithvalue:lineArr[i+1] Tool:calculatorTool image:image];
            CGPoint p3 = [self GetPointWithvalue:lineArr[i+2] Tool:calculatorTool image:image];
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < 50; i++) {
                
                float t = (float) i * (1.0f / (float) 50);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                [linePath addLineToPoint:pi];
            }
            
            // Now add p2
            [linePath addLineToPoint:p2];
            // 其他点
            
            //
        }else{
            [linePath addLineToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }
        
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = width;
    lineLayer.lineJoin = kCALineJoinRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
    
}
- (CGPoint)GetPointWithvalue:(NSValue *)value1 Tool:(CalculatorLocationTool *)calculatorTool image:(NSString *)image{
    CLLocationCoordinate2D coor;
    NSValue *value = value1;
    [value getValue:&coor];
    CLLocationCoordinate2D coor1 = [calculatorTool getLocationWithImage:image location:coor];
    
    return CGPointMake(coor1.longitude,coor1.latitude);
    
}

-(void)drawCurvewithImageSize:(CGSize)imagesize Array:(NSArray *)lineArr ishu:(NSInteger) ishu TopLeftPoint:(CLLocationCoordinate2D)topleftPoint TopRightPoint:(CLLocationCoordinate2D)topright LeftBottom:(CLLocationCoordinate2D)leftBottom linewidth:(CGFloat)width color:(UIColor*)color{
    
    CalculatorLocationTool *calculatorTool = [[CalculatorLocationTool alloc] init];
    calculatorTool.leftToplocation = topleftPoint;
    calculatorTool.leftBottomLocation = leftBottom;
    calculatorTool.rightTopLocation = topright;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (int i=0; i<lineArr.count; i++) {
        CLLocationCoordinate2D coor;
        NSValue *value = lineArr[i];
        [value getValue:&coor];
        
        CLLocationCoordinate2D coor1 = [calculatorTool getLocationWithsize:imagesize location:coor];
        if (i==0) {
            // 起点
            [linePath moveToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }else if(ishu&&i<lineArr.count-2){
            
            CGPoint p0 = [self GetPointWithvalue:lineArr[i-1] Tool:calculatorTool imagesize:imagesize];
            CGPoint p1 = [self GetPointWithvalue:lineArr[i] Tool:calculatorTool imagesize:imagesize];
            CGPoint p2 = [self GetPointWithvalue:lineArr[i+1] Tool:calculatorTool imagesize:imagesize];
            CGPoint p3 = [self GetPointWithvalue:lineArr[i+2] Tool:calculatorTool imagesize:imagesize];
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < 50; i++) {
                
                float t = (float) i * (1.0f / (float) 50);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                [linePath addLineToPoint:pi];
            }
            
            // Now add p2
            [linePath addLineToPoint:p2];
            // 其他点
            
            //
        }else{
            [linePath addLineToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }
        
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = width;
    lineLayer.lineJoin = kCALineJoinRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
    
}
- (CGPoint)GetPointWithvalue:(NSValue *)value1 Tool:(CalculatorLocationTool *)calculatorTool imagesize:(CGSize)imagesize{
    CLLocationCoordinate2D coor;
    NSValue *value = value1;
    [value getValue:&coor];
    CLLocationCoordinate2D coor1 = [calculatorTool getLocationWithsize:imagesize location:coor];
    
    return CGPointMake(coor1.longitude,coor1.latitude);
    
}
@end
