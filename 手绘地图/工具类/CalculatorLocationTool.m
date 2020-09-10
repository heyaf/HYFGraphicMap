//
//  CalculatorLocationTool.m
//  TextDemo
//
//  Created by iOS on 2019/9/6.
//  Copyright © 2019 jiaxiangpai. All rights reserved.
//

#import "CalculatorLocationTool.h"
#import <UIKit/UIKit.h>

@implementation CalculatorLocationTool
- (CLLocationCoordinate2D)getLocationWithImage:(NSString *)imageNam location:(CLLocationCoordinate2D) locationNow{
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNam]]];
    CGSize size = image.size;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0, 0);
    //纬度= （左上纬度-现在纬度）/（左上高纬度-坐下）*image高度
    location.latitude = (self.leftToplocation.latitude-locationNow.latitude)/(self.leftToplocation.latitude-self.leftBottomLocation.latitude)*size.height;
    //经度=(现在经度-左上经度)/(右上经度-左上经度)*image宽度
    location.longitude = (locationNow.longitude-self.leftToplocation.longitude)/(self.rightTopLocation.longitude-self.leftToplocation.longitude)*size.width;
    
//    CGFloat f =(locationNow.longitude-self.leftToplocation.longitude);
//    CGFloat m =(self.rightTopLocation.longitude-self.rightTopLocation.longitude);
//    
//    CGFloat f1 =(self.leftToplocation.latitude-locationNow.latitude);
//    CGFloat f2 =(self.leftToplocation.latitude-self.leftBottomLocation.latitude);
//
    
    return location;
}
- (CLLocationCoordinate2D)getLocationWithsize:(CGSize)imageSize location:(CLLocationCoordinate2D) locationNow{
    
    CGSize size = imageSize;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0, 0);
    //纬度= （左上纬度-现在纬度）/（左上高纬度-坐下）*image高度
    location.latitude = (self.leftToplocation.latitude-locationNow.latitude)/(self.leftToplocation.latitude-self.leftBottomLocation.latitude)*size.height;
    //经度=(现在经度-左上经度)/(右上经度-左上经度)*image宽度
    location.longitude = (locationNow.longitude-self.leftToplocation.longitude)/(self.rightTopLocation.longitude-self.leftToplocation.longitude)*size.width;
    
//    CGFloat f =(locationNow.longitude-self.leftToplocation.longitude);
//    CGFloat m =(self.rightTopLocation.longitude-self.rightTopLocation.longitude);
//
//    CGFloat f1 =(self.leftToplocation.latitude-locationNow.latitude);
//    CGFloat f2 =(self.leftToplocation.latitude-self.leftBottomLocation.latitude);
//
    
    return location;
}
- (CLLocationCoordinate2D )getLocationWithString:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@","];
    if (arr.count==2) {		
        NSString *str1 = arr[0];
        NSString *str2 = [str1 substringToIndex:str1.length];
        CGFloat f1 = [str2 doubleValue];
        CGFloat f2 = [arr[1] doubleValue];
 
        return CLLocationCoordinate2DMake(f1, f2);
        
    }else{
        NSLog(@"坐标格式不对");
    }
    return CLLocationCoordinate2DMake(0, 0);
}


+ (CLLocationCoordinate2D )getLocationWithData:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@","];
    if (arr.count==2) {
        NSString *str1 = arr[0];
        NSString *str2 = [str1 substringToIndex:str1.length];
        CGFloat f1 = [str2 doubleValue];
        CGFloat f2 = [arr[1] doubleValue];
 
        return CLLocationCoordinate2DMake(f1, f2);
        
    }else{
        NSLog(@"坐标格式不对");
    }
    return CLLocationCoordinate2DMake(0, 0);
}

@end
