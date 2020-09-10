//
//  LJKPinAnnotation.h
//  NAMapKitDemo
//
//  Created by waycubeios02 on 17/9/29.
//  Copyright © 2017年 weilifang. All rights reserved.
//

#import "NAAnnotation.h"

typedef enum {
    WC,
    Scene, //景点
    line,  //路线
    Voice, //语音包
    spcType, //售票处
    ykzxType, //游客中心
    crkType, //出入口
    cyType,  //餐饮
    gwType,  //购物
    wcType,  //卫生间
    tccType, //停车场
    rsfType, //热水房
    bycType, //表演场
    ywsType, //医务室
    zsType,  //住宿
    
    Location
} PinType;//点的类型 根据需要做修改 用于决定点显示的图片

//仿照"NAPinAnnotation"写的点信息类 用于存储你点的信息
@interface LJKPinAnnotation : NAAnnotation

// 点类型
@property (nonatomic, assign) PinType type;
// 点标题
@property (nonatomic, copy) NSString *title;
// 点信息
@property (nonatomic, copy) NSString *imageUrl;

/// 路线点ID
@property (nonatomic,assign) NSInteger linePointId;
/// 路线点序号
@property (nonatomic,assign) NSInteger linenum;
/// 是否可以试用
@property (nonatomic,assign) BOOL canTrial;
/// 是否已经锁住了
@property (nonatomic,assign) BOOL isLock;

@property (nonatomic,assign) NSInteger scenicType;  //景点状态 0 未解锁 1已解锁

// 根据点初始化
- (id)initWithPoint:(CGPoint)point;

@end
