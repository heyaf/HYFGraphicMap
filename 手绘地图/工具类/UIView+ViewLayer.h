//
//  UIView+ViewLayer.h
//  LocationPointApp
//
//  Created by iOS on 2019/9/23.
//  Copyright © 2019 jiaxiangpai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ViewLayer)
-(void)drawCurvewithImage:(NSString *)image Array:(NSArray *)lineArr ishu:(NSInteger) ishu TopLeftPoint:(CLLocationCoordinate2D)topleftPoint TopRightPoint:(CLLocationCoordinate2D)topright LeftBottom:(CLLocationCoordinate2D)leftBottom linewidth:(CGFloat)width color:(UIColor*)color;

-(void)drawCurvewithImageSize:(CGSize)imagesize Array:(NSArray *)lineArr ishu:(NSInteger) ishu TopLeftPoint:(CLLocationCoordinate2D)topleftPoint TopRightPoint:(CLLocationCoordinate2D)topright LeftBottom:(CLLocationCoordinate2D)leftBottom linewidth:(CGFloat)width color:(UIColor*)color;
@end

NS_ASSUME_NONNULL_END
