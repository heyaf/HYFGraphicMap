//
//  LJKPinAnnotationView.m
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "LJKPinAnnotationView.h"
#import "JXPCEdgeInsets.h"
const CGFloat LJKMapViewAnnotationPinWidth = 85.0f;//自己的控件宽
const CGFloat LJKMapViewAnnotationPinHeight = 45.0f;//自己的控件高
const CGFloat LJKMapViewAnnotationPinPointX = 18.0f;//减少会向左偏移
const CGFloat LJKMapViewAnnotationPinPointY = 33.0f;//减少会向上偏移  向下偏移= 高度-（图片高度/2）即45-(24/2)

@interface LJKPinAnnotationView()
@property (nonatomic, weak) NAMapView *mapView;
@property (nonatomic,strong) JXPCEdgeInsets *titlelabel;
@property (nonatomic,strong) UIView *titleBgView;

@property (nonatomic,strong) NSString *pinImageName;
@end

@implementation LJKPinAnnotationView

- (id)initWithAnnotation:(LJKPinAnnotation *)annotation onMapView:(NAMapView *)mapView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.mapView = mapView;
        self.annotation = annotation;
        [self addSubViews];

    }
    return self;
}
- (void)addSubViews{
    
    JXPCEdgeInsets *titlelabel = [[JXPCEdgeInsets alloc] initWithFrame:CGRectMake(0, 0, LJKMapViewAnnotationPinWidth, 16)];
    titlelabel.backgroundColor = kWhiteColor;
    UIColor *radiusColor = kRGB(10, 234, 254);
    titlelabel.textColor = kMainBlackColor;
    titlelabel.font = kNormalFont(11);
    titlelabel.text = self.annotation.title;
    [titlelabel sizeToFit];
    titlelabel.width = titlelabel.width+16;
    titlelabel.preferredMaxLayoutWidth = 85;
    titlelabel.numberOfLines = 0;
    titlelabel.height = 16;
    _titlelabel = titlelabel;
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(30.5, 21, 24, 24)];
    
    NSString *pinImageName;
    switch (self.annotation.type) {

        case Scene:
            pinImageName = @"jrdt_jd";
            break;
        case line:
            pinImageName = @"lx_xh";
            radiusColor = kRGB(255, 88, 95);
            break;
        case Voice:
            pinImageName = @"yy_can play";
            radiusColor = kRGB(0, 215, 101);
            break;
        case spcType:
            pinImageName = @"spc_icon";
            radiusColor = kRGB(255, 229, 51);

            break;
        case ykzxType:
            pinImageName = @"ykzx_icon";
            radiusColor = kRGB(255, 91, 55);

            break;
        case crkType:
            pinImageName = @"crk_icon";
            radiusColor = kRGB(0, 215, 101);

            break;
        case cyType:
            pinImageName = @"cy_icon";
            radiusColor = kRGB(255, 229, 51);

            break;
        case gwType:
            pinImageName = @"gw_icon";
            radiusColor = kRGB(255, 94, 58);

            break;
        case wcType:
            pinImageName = @"cs_icon";
            radiusColor = kRGB(172, 99, 255);

            break;
        case tccType:
            pinImageName = @"tcc_icon";
            radiusColor = kRGB(0, 204, 255);
            break;
        case rsfType:
            pinImageName = @"rsf_icon";
            radiusColor = kRGB(255, 229, 51);

            break;
        case bycType:
            pinImageName = @"byc_icon";
            radiusColor = kRGB(140, 132, 248);

            break;
        case ywsType:
            pinImageName = @"yws_icon";
            radiusColor = kRGB(0, 204, 255);

            break;
        case zsType:
            pinImageName = @"zs_icon";
            radiusColor = kRGB(0, 215, 101);

            break;
        case Location:
            pinImageName = @"yhdw_head";
            break;
        default:
            break;
        
    }
    if (self.annotation.type == Voice&&self.annotation.scenicType==0) {
        pinImageName = @"yy_the lock";
    }
    if (self.annotation.type == Voice&&self.annotation.canTrial) {
        pinImageName = @"yy_can play";
    }
    iconImage.image = kIMAGE_Name(pinImageName);
    self.iconImageV = iconImage;
    self.pinImageName = pinImageName;
    [self addSubview:iconImage];

    if (self.annotation.type == line&&self.annotation.canTrial) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titlelabel.width+32, 16)];
        bgView.backgroundColor = kWhiteColor;
        kViewBorderRadius(bgView, 3, 1, radiusColor);
        _titleBgView = bgView;
        
        UIImageView *tryImageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 16)];
        tryImageV.image = kIMAGE_Name(@"lx_st");
        [bgView addSubview:tryImageV];
        [bgView addSubview:titlelabel];
        
        titlelabel.x = 32;
        [self addSubview:bgView];
        bgView.centerX = LJKMapViewAnnotationPinWidth/2;
        
    }else if (self.annotation.type ==Voice&&self.annotation.canTrial){
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titlelabel.width+32, 16)];
        bgView.backgroundColor = kWhiteColor;
        kViewBorderRadius(bgView, 3, 1, radiusColor);
        _titleBgView = bgView;
        UIImageView *tryImageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 16)];
        tryImageV.image = kIMAGE_Name(@"yy_audition label");
        [bgView addSubview:tryImageV];
        [bgView addSubview:titlelabel];
        titlelabel.x = 32;
        [self addSubview:bgView];
        bgView.centerX = LJKMapViewAnnotationPinWidth/2;
    }else if (self.annotation.type ==Scene&&self.annotation.canTrial){
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titlelabel.width+32, 16)];
            bgView.backgroundColor = kWhiteColor;
            kViewBorderRadius(bgView, 3, 1, radiusColor);
            _titleBgView = bgView;
            UIImageView *tryImageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 16)];
            tryImageV.image = kIMAGE_Name(@"jd_st");
            [bgView addSubview:tryImageV];
            [bgView addSubview:titlelabel];
            titlelabel.x = 32;
            [self addSubview:bgView];
            bgView.centerX = LJKMapViewAnnotationPinWidth/2;
    }else{
            kViewBorderRadius(titlelabel, 3, 1, radiusColor);
            [self addSubview:titlelabel];
            titlelabel.centerX = LJKMapViewAnnotationPinWidth/2;

    }
    
    if (self.annotation.type == line) {
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iconImage.width, iconImage.height)];
        numLabel.text = kStringFormat(@"%li",self.annotation.linenum);
        numLabel.textColor = kWhiteColor;
        numLabel.font = kNormalFont(11);
        numLabel.textAlignment = NSTextAlignmentCenter;
        [iconImage addSubview:numLabel];
    }
    iconImage.centerX = LJKMapViewAnnotationPinWidth/2;
    
    if (self.annotation.type ==Location) {
        [titlelabel removeFromSuperview];
        self.userInteractionEnabled = NO;
        iconImage.frame = CGRectMake(26.5, 17, 32, 32);
//        iconImage.image = nil;
        
    }

//    [self setImage:kIMAGE_Name(pinImageName) forState:UIControlStateNormal];
//    [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
}
- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
 
    point.x = point.x - (self.annotation.type == Location ? 28 : LJKMapViewAnnotationPinWidth/2);
    point.y = point.y - LJKMapViewAnnotationPinPointY;
    self.frame = CGRectMake(point.x, point.y, LJKMapViewAnnotationPinWidth, LJKMapViewAnnotationPinHeight);
    if ((self.annotation.type==line||self.annotation.type==Voice||self.annotation.type== Scene)&&self.annotation.canTrial) {
        _titleBgView.x = self.width/2-_titleBgView.width/2;
    }else{
        _titlelabel.x = self.width/2-_titlelabel.width/2;
    }
}
-(void)setStatues:(NSInteger)statues{
    UIView *subView;
    if (self.iconImageV.subviews.count>0) {
        subView = self.iconImageV.subviews[0];
    }
    if (statues==1) {
        [self.iconImageV stopAnimating];
        self.iconImageV.image = kIMAGE_Name(self.pinImageName);
        subView.hidden = NO;
    }else{
        [self setanimalGif];
        subView.hidden = YES;
    }
}
- (void)setanimalGif{
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"yy_play@3x" withExtension:@"gif"];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    //获取Gif图有多少帧
    size_t gifcount = CGImageSourceGetCount(gifSource);
    NSMutableArray* voiceImages = [NSMutableArray array];
    for (NSInteger i = 0; i < gifcount; i++) {
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [voiceImages addObject:image];
        CGImageRelease(imageRef);
    }
    self.iconImageV.image = voiceImages[0];
    self.iconImageV.animationImages = voiceImages;
    //animationDuration值越小，运动速度越快
    self.iconImageV.animationDuration = 0.7;
    //animationRepeatCount代表循环次数，默认是0，表示无限循环
    self.iconImageV.animationRepeatCount = 0;
    //这句话一定要记得加，启动动画；页面消失时别忘了stopAnimating
     [self.iconImageV startAnimating];
}
@end
