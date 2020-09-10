//
//  LJKPinAnnotationMapView.h
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "NAMapView.h"
@class LJKPinAnnotation;
@interface LJKPinAnnotationMapView : NAMapView
//@property (nonatomic, assign) CGSize imagesize;
@property (nonatomic,strong) NSMutableArray *annotationArray;
- (void)showCalloutForAnnotation:(LJKPinAnnotation *)annotation animated:(BOOL)animated;
- (void)removeAllAnnotaions;
- (void)stopPlayAudio;
- (void)hideCallOut;
- (void)removeUserLocationAnnotation;
@property (nonatomic,strong) NSMutableArray *annoViewArr;
@end
