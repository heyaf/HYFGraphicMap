//
//  HYFMapViewController.m
//  HYFGraphicMap
//
//  Created by iOS on 2020/9/9.
//  Copyright © 2020 heyafei. All rights reserved.
//

#import "HYFMapViewController.h"
#import "LJKPinAnnotationMapView.h"
#import "JXPCMapBottomView.h"

@interface HYFMapViewController ()

@property (nonatomic,strong) LJKPinAnnotationMapView *mapView;

@property (nonatomic,strong) UIImageView *placeHolderImageV;

@property (nonatomic,strong) UIView *MainForgView;
@property (nonatomic,assign) NSInteger Mapindex;

@property (nonatomic, assign) CGSize imagesize;

@property (nonatomic,assign) BOOL isDrawline;  //是否是绘制路线(涉及到需要c切换语音包和路线时是否需要重新绘制)
@property (nonatomic,assign) NSInteger voiceId; //选择的语音id
@property (nonatomic,strong) NSDictionary *voiceDic; //选择的语音包订单信息数组
@property (nonatomic,assign) NSInteger maptype; //1表示路线 2表示语音包

/// 底部导航视图
@property (nonatomic,strong) JXPCMapBottomView *mapbottomView;
/// 导航栏弹窗
@property (nonatomic,strong) UIView *NavpopView;
@property (nonatomic,strong) UIButton *navBtn;


@property (nonatomic,strong) NSArray *ScenicPointArray; //景点详情数组
@property (nonatomic,strong) NSArray *VoiceListArray; //语音列表数组
@property (nonatomic,strong) NSArray *VoiceDetailArray; //语音详情数组
@property (nonatomic,strong) NSArray *lineVoiceArray; //路线语音详情数组

@property (nonatomic,strong) NSMutableArray *ScenicPinAniMutArray;  //景点数组（LJKPinAnnotation类型）
@property (nonatomic,strong) NSArray *facilityArray; //设施数组

@end

@implementation HYFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeHolderImageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 555)];
    _placeHolderImageV.image = kIMAGE_Name(@"jrdt_jzz");
    [self.view addSubview:_placeHolderImageV];
    
    [self creatMapView];
    
    [self CreatUI];
}
- (void)creatMapView{
    if (!_mapView) {
        
        _mapView = [[LJKPinAnnotationMapView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.bounds.size.width, kScreenH-kNavBarHeight-48-kSafeAreaBottom)];
        _mapView.showsVerticalScrollIndicator = NO;
        _mapView.showsHorizontalScrollIndicator = NO;
        _mapView.backgroundColor  = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:214/255.0];
        [self.view addSubview:_mapView];
//        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
        [self.view addSubview:imageV];

        
        [imageV sd_setImageWithURL:[NSURL URLWithString:@"http://qn-collect-test.jxpapp.com/map_1.png"] placeholderImage:kIMAGE_Name(@"map_1") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.placeHolderImageV removeFromSuperview];
            [self.MainForgView removeFromSuperview];
            self->_mapView.minimumZoomScale = 0.1f;
            self->_mapView.maximumZoomScale = 1.0f;
            self.imagesize = image.size;
            [self->_mapView displayMap:image];
            self->_mapView.zoomScale = (self->_mapView.bounds.size.height + 1)/ image.size.height;//[[UIScreen mainScreen] bounds].size.width / image.size.width;//mapView.bounds.size.height / image.size.height
            self->_mapView.minimumZoomScale = self->_mapView.minimumZoomScale < self->_mapView.zoomScale ? self->_mapView.zoomScale : self->_mapView.minimumZoomScale;
            [self.view addSubview:self->_mapView];
            [self.view sendSubviewToBack:self->_mapView];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            });

            
        }];
        

    }
}

- (void)CreatUI{
    [self addMapViewSubViews];
    [self setNavigationView];

    _mapbottomView = [[JXPCMapBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kNavBarHeight-320-kSafeAreaBottom, kScreenW, 320+kSafeAreaBottom)];
    _mapbottomView.superVC = self;
    [self.view addSubview:_mapbottomView];
  

    __weak typeof(self) weakself = self;
    _mapbottomView.ScenicBtnblock = ^(NSInteger spId){
        [weakself clearMapImageView];

//        [weakself setScenicPoint];
        weakself.isDrawline = NO;
        if (spId>0) {
            for (LJKPinAnnotation *annotation in weakself.ScenicPinAniMutArray) {
//                if (annotation.linePointId==spId) {
//                    [weakself.mapView showCalloutForAnnotation:annotation animated:NO];
//                    [weakself.mapView centerOnPoint:annotation.point animated:YES];
//                }
            }
            
            
        }


    };
    _mapbottomView.lineBtnblock = ^(NSInteger lineNameid, NSInteger voiceId,NSDictionary *orderDic) {
        [weakself clearMapImageView];
        weakself.maptype = 1;
//        [weakself getLineDeatilDataWithLineID:lineNameid voiceId:voiceId voiceDic:orderDic];
        weakself.isDrawline = YES;
    };

    _mapbottomView.voiceBtnblock = ^(NSInteger voiceId,NSDictionary * _Nonnull orderDic) {
        [weakself clearMapImageView];
        weakself.isDrawline = NO;
        weakself.maptype = 2;
//        [weakself getVoiceDetailDataWithvoiceId:kStringFormat(@"%li",(long)voiceId) dic:orderDic];
        weakself.voiceId = voiceId;
        weakself.voiceDic = orderDic;
        
//        [weakself getscenicPointData];
    };

    _mapbottomView.SSBtnblock = ^(NSString * _Nonnull ssName) {
        [weakself clearMapImageView];
        weakself.isDrawline = NO;
//        [weakself setFacilityPointWithName:ssName];
//        [player stop];
//        KPostNotification(KNotificationCallOurViewBtnChange, nil, @{@"state":@"0"});

    };
    
    
    _mapbottomView.ReloadVoiceListDataBlock = ^{
//        [weakself getVoiceData];
//        [player stop];

    };
    _mapbottomView.useOrderDataBlock = ^(NSDictionary * _Nonnull orderdic) {
//        [weakself usermyOrder1:orderdic];
    };

}
#pragma mark ---视图-----
- (void)addMapViewSubViews{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 44, 44)];
    imageV.image = kIMAGE_Name(@"jrdt_znz");
    [self.view addSubview:imageV];
    
    UIButton *userbtn = [UIButton buttonWithType:0];
    userbtn.frame = CGRectMake(10, kScreenH-kNavBarHeight-48-kSafeAreaBottom-57, 42, 42);
    [userbtn setImage:kIMAGE_Name(@"jrdt_positioning") forState:0];
    
    [self.view addSubview:userbtn];
    [userbtn addTarget:self action:@selector(userPoint) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setNavigationView{
    
    UIButton *navBtn = [UIButton buttonWithType:0];
    navBtn.frame = CGRectMake(0, 0, kScreenW-100, 27);
    NSString *name = @"地图详情";
    [navBtn setTitle:name forState:0];
    [navBtn setTitleColor:kMainBlackColor forState:0];
    navBtn.titleLabel.font = kNormalFont(18);
    [navBtn setImage:kIMAGE_Name(@"nav arrow_up") forState:0];
    [navBtn setImage:kIMAGE_Name(@"nav arrow_down") forState:UIControlStateSelected];
    navBtn.titleLabel.frame = CGRectMake(0, 0, navBtn.width, 18);
    [navBtn setImagePositionWithType:SSImagePositionTypeBottom spacing:0];
    [navBtn addTarget:self action:@selector(navGationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _navBtn = navBtn;
    self.navigationItem.titleView = navBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:0];
    rightBtn.frame = CGRectMake(0, 0, 50, 13);
    [rightBtn setTitle:@"反馈" forState:0];
    [rightBtn setTitleColor:kMainBlackColor forState:0];
    rightBtn.titleLabel.font = kNormalFont(13);
    [rightBtn addTarget:self action:@selector(Suggest) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIView *naVpopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kNavBarHeight)];
    naVpopView.backgroundColor = kClearColor;
    _NavpopView = naVpopView;
    [self.view addSubview:naVpopView];
    naVpopView.hidden = YES;
    __weak typeof(naVpopView) weakpopView = naVpopView;
//    [naVpopView addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
//        navBtn.selected = NO;
//        weakpopView.hidden = YES;
//    }];
    
    
    
    UIImageView *jiantouView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 14, 8)];
    jiantouView.image = kIMAGE_Name(@"jrdt_triangle");
    jiantouView.centerX = naVpopView.centerX;
    [naVpopView addSubview:jiantouView];
    
    UIView *popBGView = [[UIView alloc] initWithFrame:CGRectMake(15, 18, kScreenW-30, 90)];
    popBGView.backgroundColor = kWhiteColor;
    kViewRadius(popBGView, 5);
    [naVpopView addSubview:popBGView];
    
    CGFloat leftMargin = 50.0;
    CGFloat marginW = (kScreenW-30-36*3-leftMargin*2)/2;
    UIButton *autioplayBtn = [UIButton buttonWithType:0];
    autioplayBtn.frame = CGRectMake(leftMargin, 16.5, 36, 56);
    [autioplayBtn setImage:kIMAGE_Name(@"automatic_open") forState:0];
    [autioplayBtn setImage:kIMAGE_Name(@"automatic_close") forState:UIControlStateSelected];
    [autioplayBtn setTitle:@"自动" forState:0];
    autioplayBtn.titleLabel.font = kNormalFont(14);
    [autioplayBtn setTitleColor:kMainBlackColor forState:0];
    [autioplayBtn setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    [popBGView addSubview:autioplayBtn];
    [autioplayBtn addTarget:self action:@selector(autioPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    NSDictionary* autoint = GetUserInfo;
//    if ([autoint[@"isAutoplay"] integerValue]==0) {
//        autioplayBtn.selected = YES;
//    }
//    if (!autoint) {
//        autioplayBtn.selected = NO;
//    }
    
    UIButton *downBtn = [UIButton buttonWithType:0];
    downBtn.frame = CGRectMake(leftMargin+36+marginW, 16.5, 36, 56);
    [downBtn setImage:kIMAGE_Name(@"jrdt_offline") forState:0];
    [downBtn setTitle:@"离线" forState:0];
    downBtn.titleLabel.font = kNormalFont(14);
    [downBtn setTitleColor:kMainBlackColor forState:0];
    [downBtn setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    [popBGView addSubview:downBtn];
    [downBtn addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rescueBtn = [UIButton buttonWithType:0];
    rescueBtn.frame = CGRectMake(leftMargin+(36+marginW)*2, 16.5, 36, 56);
    [rescueBtn setImage:kIMAGE_Name(@"jrdt_rescue") forState:0];
    [rescueBtn setTitle:@"救援" forState:0];
    rescueBtn.titleLabel.font = kNormalFont(14);
    [rescueBtn setTitleColor:kMainBlackColor forState:0];
    [rescueBtn setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    [popBGView addSubview:rescueBtn];
    [rescueBtn addTarget:self action:@selector(rescue) forControlEvents:UIControlEventTouchUpInside];
}
/// 清空路线和图标显示
- (void)clearMapImageView{
    if (self.isDrawline) {
        [self cancleImageLine];
    }
    [self.mapView removeAllAnnotaions];
}
// 清空路线
-(void)cancleImageLine{
    CGRect rect = _mapView.imageView.frame;
    [_mapView.imageView removeFromSuperview];
    _mapView.imageView = [[UIImageView alloc] initWithFrame:rect];
    [_mapView addSubview:_mapView.imageView];
    self->_mapView.minimumZoomScale = 0.1f;
    self->_mapView.maximumZoomScale = 1.0f;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kIMAGE_Name(@"jrdt_jzz") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self->_mapView displayMap:image];
        self->_mapView.zoomScale = (self->_mapView.bounds.size.height + 49)/ image.size.height;
        self->_mapView.minimumZoomScale = self->_mapView.minimumZoomScale < self->_mapView.zoomScale ? self->_mapView.zoomScale : self->_mapView.minimumZoomScale;
    }];
}
@end
