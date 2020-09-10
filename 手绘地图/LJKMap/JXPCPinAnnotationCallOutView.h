//
//  JXPCPinAnnotationCallOutView.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/25.
//  Copyright © 2020 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJKPinAnnotationMapView.h"
#import "LJKPinAnnotation.h"
NS_ASSUME_NONNULL_BEGIN

@interface JXPCPinAnnotationCallOutView : UIView

@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowsImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowsX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrawsY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainBgViewY;
// 在地图上创建气泡
- (id)initOnMapView:(LJKPinAnnotationMapView *)mapView;

// 更新气泡位置
- (void)updatePosition;

@property(readwrite, nonatomic, weak) LJKPinAnnotation *annotation;
- (IBAction)cancleBtnclicked:(id)sender;
- (IBAction)TryBtnclicked:(id)sender;
- (IBAction)DetailBtnclicked:(id)sender;

- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END
