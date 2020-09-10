//
//  LJKPinAnnotationMapView.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotationMapView.h"
#import "LJKPinAnnotationCallOutView.h"
#import "LJKPinAnnotation.h"
#import "LJKPinAnnotationView.h"
#import "JXPCPinAnnotationCallOutView.h"

@interface LJKPinAnnotationMapView ()
@property (nonatomic, strong) LJKPinAnnotationCallOutView *calloutView;
@property (nonatomic,strong) JXPCPinAnnotationCallOutView *calloutView1;
@property (nonatomic, strong) UIView *calloutViewBackView;
@property (nonatomic, strong) UIView *calloutViewBackView1;

@property (nonatomic, readonly) NSMutableArray *annotations;
- (void)showCallOut:(id)sender;
- (void)hideCallOut;

@end

@implementation LJKPinAnnotationMapView

- (void)setupMap
{
    [super setupMap];
    
//    _calloutView = [[LJKPinAnnotationCallOutView alloc] initOnMapView:self];
//    _calloutViewBackView = [[UIView alloc] initWithFrame:_calloutView.frame];
//    [_calloutViewBackView addSubview:_calloutView];
//    _calloutView.userInteractionEnabled = YES;
//    _calloutViewBackView.userInteractionEnabled = YES;
//    [self addSubview:self.calloutViewBackView];
    
    self.annoViewArr = [NSMutableArray arrayWithCapacity:0];
    
    _calloutView1 = [[JXPCPinAnnotationCallOutView alloc] initOnMapView:self];
//    _calloutView1.frame = CGRectMake(0, 0, 188, 106);
    _calloutViewBackView1 = [[UIView alloc] initWithFrame:_calloutView1.frame];
    [_calloutViewBackView1 addSubview:_calloutView1];
    _calloutView1.userInteractionEnabled = YES;
    _calloutViewBackView1.userInteractionEnabled = YES;
    _calloutViewBackView1.hidden = YES;
    [self addSubview:self.calloutViewBackView1];
    _annotations = @[].mutableCopy;
    
}

- (void)addAnnotation:(LJKPinAnnotation *)annotation animated:(BOOL)animate
{
    

    [annotation addToMapView:self animated:animate];
    [self.annotations addObject:annotation];
    if ([annotation.view isKindOfClass:NSClassFromString(@"LJKPinAnnotationView")]) {
        LJKPinAnnotation *annot = (LJKPinAnnotation *)annotation;
        [self.annoViewArr addObject:annotation.view];

        if (annot.type == Voice||annot.type ==Scene||annot.type ==line) {//我这里只有点击景点别针才显示气泡 根据需求修改
            LJKPinAnnotationView *annotationView = (LJKPinAnnotationView *) annotation.view;
            [annotationView addTarget:self action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        }
//        if (annot.type==Scene) {
//            _calloutView1.audioBtn.hidden = YES;
//            _calloutView1.frame = CGRectMake(0, 0, 188, 106);
//        }else{
//            _calloutView1.audioBtn.hidden = NO;
//            _calloutView1.frame = CGRectMake(0, 0, 257, 106);
//        }
    }
    
    [self bringSubviewToFront:self.calloutViewBackView];
    [self bringSubviewToFront:self.calloutViewBackView1];
}

- (void)selectAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate
{
    [self hideCallOut];
    if([annotation isKindOfClass:NSClassFromString(@"LJKAnnotation")]) {
        [self showCalloutForAnnotation:(LJKPinAnnotation *)annotation animated:animate];
    }
}

- (void)removeAnnotation:(NAAnnotation *)annotation
{
    [self hideCallOut];
    [annotation removeFromMapView];
    [self.annotations removeObject:annotation];
}

- (void)removeAllAnnotaions{
    
    [self hideCallOut];
    [self.annoViewArr removeAllObjects];
    
    [self.annotations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJKPinAnnotation *annot = obj;
        [annot removeFromMapView];
        [self.annotations removeObject:annot];
    }];
    
}

- (void)showCallOut:(id)sender
{
    if([sender isKindOfClass:[LJKPinAnnotationView class]]) {
        LJKPinAnnotationView *annontationView = (LJKPinAnnotationView *)sender;
        
        if ([self.mapViewDelegate respondsToSelector:@selector(mapView:tappedOnAnnotation:)]) {
            [self.mapViewDelegate mapView:self tappedOnAnnotation:annontationView.annotation];
        }
        
        [self showCalloutForAnnotation:annontationView.annotation animated:YES];
    }
}
- (void)removeUserLocationAnnotation{
//    [self hideCallOut];
    
    [self.annotations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LJKPinAnnotation *annot = obj;
        
        if (annot.type == Location) {
            [annot removeFromMapView];
            [self.annotations removeObject:annot];
        }
        
    }];
}
- (void)showCalloutForAnnotation:(LJKPinAnnotation *)annotation animated:(BOOL)animated
{
    [self hideCallOut];
    
    self.calloutView1.annotation = annotation;
    
//    [self centerOnPoint:annotation.point animated:animated];
//    CGPoint point = [self.mapView zoomRelativePoint:self.position];
    CGFloat animationDuration = animated ? 0.1f : 0.0f;
    
    self.calloutView1.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4f, 0.4f);
    self.calloutView1.hidden = NO;
    _calloutViewBackView1.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        weakSelf.calloutView1.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideCallOut
{
    self.calloutView1.hidden = YES;
    _calloutViewBackView1.hidden = YES;
    [self.calloutView stopPlay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.superview endEditing:YES];
    
    UITouch *touch =  [touches anyObject];
    
    if (touch.view != self) {
        return;
    }
    
    if (!self.dragging) {
        [self hideCallOut];
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)updatePositions
{
//    [self hideCallOut];
    [super updatePositions];

    [self.calloutView1 updatePosition];
}
-(void)displayMap:(UIImage *)map{
    [super displayMap:map];
    
}
- (void)stopPlayAudio{
    [self.calloutView stopPlay];
}

@end
