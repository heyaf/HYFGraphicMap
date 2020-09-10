//
//  LJKPinAnnotationView.h
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJKPinAnnotation.h"
#import "LJKPinAnnotationMapView.h"
//仿照NAPinAnnotationView 写的 在点上显示的view
@interface LJKPinAnnotationView : UIButton

@property (readwrite, nonatomic, weak)LJKPinAnnotation *annotation;

@property (nonatomic,strong) UIImageView *iconImageV;
@property (nonatomic,assign) NSInteger statues;  //1是正常状态 0是播放状态
- (id)initWithAnnotation:(LJKPinAnnotation *)annotation onMapView:(NAMapView *)mapView;
//地图缩放的时候更新位置
- (void)updatePosition;


@end
