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
#import "JXPCScenicPointModel.h"
#import "JXPCFacilityModel.h"
#import "CalculatorLocationTool.h"
#import "LJKPinAnnotation.h"
#import "JXPCVoiceListModel.h"


@interface HYFMapViewController ()

@property (nonatomic,strong) LJKPinAnnotationMapView *mapView;
@property (nonatomic,strong) CalculatorLocationTool *calTool;

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
@property (nonatomic,strong) NSArray *linePointArray;

@property (nonatomic,strong) NSMutableArray *ScenicPinAniMutArray;  //景点数组（LJKPinAnnotation类型）
@property (nonatomic,strong) NSArray *facilityArray; //设施数组

@end

@implementation HYFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeHolderImageV= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 555)];
    _placeHolderImageV.image = kIMAGE_Name(@"jrdt_jzz");
    [self.view addSubview:_placeHolderImageV];
    [self baseSet];
    [self creatMapView];
    [self CreatUI];
    [self setData];

}
//初始化计算工具类
- (void)baseSet{
    _calTool = [[CalculatorLocationTool alloc] init];
    _calTool.leftToplocation = [_calTool getLocationWithString:@"34.811889,114.345857"];
    _calTool.rightTopLocation = [_calTool getLocationWithString:@"34.811889,114.348685"];
    _calTool.leftBottomLocation = [_calTool getLocationWithString:@"34.809242,114.345857"];
    
}
//初始化地图视图
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

    _mapbottomView = [[JXPCMapBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-320-kSafeAreaBottom, kScreenW, 320+kSafeAreaBottom)];
    _mapbottomView.superVC = self;
    [self.view addSubview:_mapbottomView];
  
    __weak typeof(self) weakself = self;
    //景点点击的回调
    _mapbottomView.ScenicBtnblock = ^(NSInteger spId){
        [weakself clearMapImageView];

        [weakself setScenicPoint];
        weakself.isDrawline = NO;

    };
    //路线点击的回调
    _mapbottomView.lineBtnblock = ^{
                [weakself clearMapImageView];
                weakself.maptype = 1;
                weakself.isDrawline = YES;
        [weakself drawLineWithLineArr:weakself.linePointArray lineID:1];
    };

    //语音包点击的回调
    _mapbottomView.voiceBtnblock = ^(NSInteger voiceId,NSDictionary * _Nonnull orderDic) {
        [weakself clearMapImageView];
        weakself.isDrawline = NO;
        weakself.maptype = 2;
        [weakself drawVoicePointWithArray:weakself.VoiceDetailArray andOrdertype:1];
        weakself.voiceId = voiceId;
        weakself.voiceDic = orderDic;
        
    };
    //设施点击的回调
    _mapbottomView.SSBtnblock = ^(NSString * _Nonnull ssName) {
        [weakself clearMapImageView];
        weakself.isDrawline = NO;
        [weakself setFacilityPointWithName:ssName];
    };

}
#pragma mark ---视图-----
- (void)addMapViewSubViews{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 44, 44)];
    imageV.image = kIMAGE_Name(@"jrdt_znz");
    [self.view addSubview:imageV];
    
    UIButton *userbtn = [UIButton buttonWithType:0];
    userbtn.frame = CGRectMake(10, kScreenH-48-kSafeAreaBottom-57, 42, 42);
    [userbtn setImage:kIMAGE_Name(@"jrdt_positioning") forState:0];
    
    [self.view addSubview:userbtn];
    [userbtn addTarget:self action:@selector(userLoction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)userLoction{
    [SVProgressHUD showErrorWithStatus:@"定位失败，请稍后重试"];
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
    [rightBtn addTarget:self action:@selector(backActionSuggest) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:0];
    leftBtn.frame = CGRectMake(0, 0, 50, 13);
    [leftBtn setTitleColor:kMainBlackColor forState:0];
    leftBtn.titleLabel.font = kNormalFont(13);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIView *naVpopView = [[UIView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kScreenW, kScreenH-kNavBarHeight)];
    naVpopView.backgroundColor = kClearColor;
    _NavpopView = naVpopView;
    [self.view addSubview:naVpopView];
    naVpopView.hidden = YES;
    
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

-(void)backActionSuggest{
    [SVProgressHUD showWithStatus:@"暂未开放，敬请期待"];
}
-(void)down{
    
}
-(void)autioPlayBtnClicked:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        [SVProgressHUD showSuccessWithStatus:@"自动播放已开启"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"自动播放已关闭"];
    }
}
#pragma mark --救援点击事件---
- (void)rescue{

    NSString *telPhone = kStringFormat(@"tel://110");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telPhone] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

/// 绘制景点
- (void)setScenicPoint{
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0;i<self.ScenicPointArray.count;i++) {
        JXPCScenicPointModel *spModel = self.ScenicPointArray[i];
        CLLocationCoordinate2D coor1 = [_calTool getLocationWithsize:self.imagesize location:[_calTool getLocationWithString:spModel.ssaLongitudeLatitude]];
        LJKPinAnnotation *dot = [LJKPinAnnotation annotationWithPoint:CGPointMake(coor1.longitude, coor1.latitude)];
        dot.title = spModel.ssaName;
        dot.imageUrl = spModel.definiteImage;
        dot.type = Scene;
        if ([spModel.clientVoicePacketDetails[@"isEffective"] integerValue]==1||[spModel.clientVoicePacketDetails[@"isFree"] integerValue]==1) {
            dot.scenicType =1;
        }
        dot.linePointId = spModel.spId;
        dot.canTrial = [spModel.clientVoicePacketDetails[@"isAudition"] integerValue]==1?YES:NO;
        [mutArr addObject:dot];
    }
    self.ScenicPinAniMutArray = mutArr;
    [_mapView addAnnotations:mutArr animated:YES];
    
//    //如果存在正在播放的语音包，则更改地图语音包状态
//    if ([YGAudioPlayer sharedInstance].playStatus == YGAudioPlayerPlayStatusPlaying) {
//        for (LJKPinAnnotationView *mapView in _mapView.annoViewArr) {
//            [mapView setStatues:1];
//            if (mapView.annotation.linePointId ==[[kUserDefaults objectForKey:@"playeringId"] integerValue]) {
//                [mapView setStatues:0];
//            }
//        }
//    }
}

/// 绘制设施点
/// @param SSname 设施name
- (void)setFacilityPointWithName:(NSString *)SSname{
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];

    JXPCFacilityModel *facilityModel;
    for (JXPCFacilityModel *facilityModel1 in self.facilityArray) {
        if ([facilityModel1.ssfnFacilitiesName isEqualToString:SSname]) {
            facilityModel = facilityModel1;
        }
    }
    for (NSDictionary *dic in facilityModel.clientFacilitiesDetailsList) {
        NSString *str =dic[@"ssfLongitudeLatitude"];
        CLLocationCoordinate2D coor1 = [_calTool getLocationWithsize:self.imagesize location:[_calTool getLocationWithString:str]];
        LJKPinAnnotation *dot = [LJKPinAnnotation annotationWithPoint:CGPointMake(coor1.longitude, coor1.latitude)];
        dot.title = facilityModel.ssfnFacilitiesName;
        [mutArr addObject:dot];
        if ([facilityModel.ssfnFacilitiesName isEqualToString:@"售票处"]) {
            dot.type = spcType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"游客中心"]) {
            dot.type = ykzxType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"出入口"]) {
            dot.type = crkType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"餐饮"]) {
            dot.type = cyType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"购物"]) {
            dot.type = gwType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"卫生间"]) {
            dot.type = wcType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"停车场"]) {
            dot.type = tccType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"热水房"]) {
            dot.type = rsfType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"表演场"]) {
            dot.type = bycType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"医务室"]) {
            dot.type = ywsType;
        }else if ([facilityModel.ssfnFacilitiesName isEqualToString:@"住宿"]) {
            dot.type = zsType;
        }else{
            dot.type = tccType;
        }
        
    }
    
    [_mapView addAnnotations:mutArr animated:YES];
    
    NSDictionary *dic = facilityModel.clientFacilitiesDetailsList[0];
    NSString *str =dic[@"ssfLongitudeLatitude"];
    CLLocationCoordinate2D coor1 = [_calTool getLocationWithsize:self.imagesize location:[_calTool getLocationWithString:str]];
    [self.mapView centerOnPoint:CGPointMake(coor1.longitude, coor1.latitude) animated:NO];

}
#pragma mark ---导航栏弹窗弹起事件---
- (void)navGationBtnClicked:(UIButton *)btn{
    btn.selected = !btn.isSelected;

    _NavpopView.hidden = btn.selected?NO:YES;
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
    [imageV sd_setImageWithURL:[NSURL URLWithString:@"http://qn-collect-test.jxpapp.com/map_1.png"] placeholderImage:kIMAGE_Name(@"jrdt_jzz") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self->_mapView displayMap:image];
        self->_mapView.zoomScale = (self->_mapView.bounds.size.height + 49)/ image.size.height;
        self->_mapView.minimumZoomScale = self->_mapView.minimumZoomScale < self->_mapView.zoomScale ? self->_mapView.zoomScale : self->_mapView.minimumZoomScale;
    }];
}
//绘制语音包景点
- (void)drawVoicePointWithArray:(NSArray *)pointArray andOrdertype:(NSInteger)orderType{
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0;i<pointArray.count;i++) {
        NSDictionary *dic = pointArray[i];
        NSString *str = dic[@"ssaLongitudeLatitude"];
        CLLocationCoordinate2D coor1 = [_calTool getLocationWithsize:self.imagesize location:[_calTool getLocationWithString:str]];
        LJKPinAnnotation *dot = [LJKPinAnnotation annotationWithPoint:CGPointMake(coor1.longitude, coor1.latitude)];
        dot.title = dic[@"ssaName"];
        dot.imageUrl = dic[@"definiteImage"];
        dot.linePointId = [dic[@"id"] integerValue];
        dot.type = Voice;
        dot.linenum = i+1;
        dot.scenicType = orderType;
            dot.scenicType =1;
        dot.canTrial = [dic[@"clientVoicePacketDetails"][@"isAudition"] integerValue]==1?YES:NO;
        [mutArr addObject:dot];
    }

    [_mapView addAnnotations:mutArr animated:YES];
    
}
/// 绘制路线
/// @param linePointArray 路线点数组
/// @param lineid 路线id
- (void)drawLineWithLineArr:(NSArray *)linePointArray lineID:(NSInteger) lineid{
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];

    NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *lineDic in linePointArray) {
        [pointArray addObject:lineDic[@"ssrsLongitudeLatitude"]];
    }
    CalculatorLocationTool *tool = [[CalculatorLocationTool alloc] init];
    UIColor *lineColor = kRGB(79, 172, 254);
//    switch (lineid) {
//        case 1:  //一日游
//            lineColor = kRGB(255, 162, 0);
//            break;
//        case 2:  //半日游
//            lineColor = kRGB(79, 172, 254);
//
//            break;
//        case 3:  //快速游
//            lineColor = kRGB(255, 88, 95);
//            break;
//
//        default:
//            break;
//    }

    for (NSString *str in pointArray) {
        CLLocationCoordinate2D coor = [tool getLocationWithString:str];

        NSValue *value = [NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)];
        [mutArr addObject:value];
    }
    [self DrawLinelineArray:mutArr arcLine:0 color:lineColor];
}
-(void)DrawLinelineArray:(NSArray*)pointArray arcLine:(NSInteger)arcline color:(UIColor *)color{

    CalculatorLocationTool *tool = [[CalculatorLocationTool alloc] init];
    [_mapView.imageView drawCurvewithImageSize:self.imagesize Array:pointArray ishu:arcline TopLeftPoint:[tool getLocationWithString:@"34.811889,114.345857"] TopRightPoint:[tool getLocationWithString:@"34.811889,114.348685"] LeftBottom:[tool getLocationWithString:@"34.809242,114.345857"] linewidth:15.0 color:color];

}
-(void)setData{
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"scenicData" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:videoPath];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    self.ScenicPointArray = [JXPCScenicPointModel arrayOfModelsFromDictionaries:arr error:nil];
    self.mapbottomView.scenicPointListArr = self.ScenicPointArray;
    
    NSString *videoPath1 = [[NSBundle mainBundle] pathForResource:@"facility" ofType:@"json"];
    NSData *jsonData1 = [NSData dataWithContentsOfFile:videoPath1];
    NSArray *arr1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingAllowFragments error:nil];
    self.facilityArray = [JXPCFacilityModel arrayOfModelsFromDictionaries:arr1 error:nil];
    self.mapbottomView.facilityArray = self.facilityArray;
    
    
    NSString *voicePath = [[NSBundle mainBundle] pathForResource:@"VoiceData" ofType:@"json"];
    NSData *VoiceJsonData = [NSData dataWithContentsOfFile:voicePath];
    NSArray *voicearr = [NSJSONSerialization JSONObjectWithData:VoiceJsonData options:NSJSONReadingAllowFragments error:nil];
    self.VoiceDetailArray = voicearr;
    [self drawVoicePointWithArray:voicearr andOrdertype:1];

    NSString *voicelistPath = [[NSBundle mainBundle] pathForResource:@"VoiceListData1" ofType:@"json"];
    NSData *VoiceListJsonData = [NSData dataWithContentsOfFile:voicelistPath];
    NSArray *voicearr1 = [NSJSONSerialization JSONObjectWithData:VoiceListJsonData options:NSJSONReadingAllowFragments error:nil];
    self.VoiceListArray = [JXPCVoiceListModel arrayOfModelsFromDictionaries:voicearr1 error:nil];
    self.mapbottomView.voiceListArr = self.VoiceListArray;
    
    NSString *linePointPath = [[NSBundle mainBundle] pathForResource:@"LinePointData" ofType:@"json"];
    NSData *linePointPathData = [NSData dataWithContentsOfFile:linePointPath];
    NSArray *linePointarr = [NSJSONSerialization JSONObjectWithData:linePointPathData options:NSJSONReadingAllowFragments error:nil];
    self.linePointArray = linePointarr;


    self.mapbottomView.LineNameArr = @[@"路线一"];
}
@end
