//
//  CalculatorLocationTool.h
//  TextDemo
//
//  Created by iOS on 2019/9/6.
//  Copyright © 2019 jiaxiangpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorLocationTool : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D leftToplocation;
@property (nonatomic,assign) CLLocationCoordinate2D leftBottomLocation;
@property (nonatomic,assign) CLLocationCoordinate2D rightTopLocation;

/**
 计算当前纬度再底图中的位置

 @param locationNow 当前纬度
 @return 位置
 */

- (CLLocationCoordinate2D )getLocationWithImage:(NSString *)imageName location:(CLLocationCoordinate2D) locationNow;

- (CLLocationCoordinate2D)getLocationWithsize:(CGSize)imageSize location:(CLLocationCoordinate2D) locationNow;


- (CLLocationCoordinate2D )getLocationWithString:(NSString *)str;


+ (CLLocationCoordinate2D )getLocationWithData:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
