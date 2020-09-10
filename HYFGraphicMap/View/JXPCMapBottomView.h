//
//  JXPCMapBottomView.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCMapBottomView : UIView

@property (nonatomic,strong) NSMutableArray *titleNameArray;

@property (nonatomic,strong) NSArray *voiceListArr;

@property (nonatomic,strong) NSArray *LineNameArr;

@property (nonatomic,strong) NSArray *scenicPointListArr;

@property (nonatomic,strong) NSArray *facilityArray;

@property (nonatomic,strong) UIViewController *superVC;
//标题title按钮点击回调

@property (nonatomic, copy) void(^ScenicBtnblock)(NSInteger spId);
@property (nonatomic, copy) void(^lineBtnblock)(NSInteger lineNameid,NSInteger voiceId,NSDictionary *orderDic);
@property (nonatomic, copy) void(^voiceBtnblock)(NSInteger voiceId,NSDictionary *orderDic);

/// 设施点击回调
@property (nonatomic, copy) void(^SSBtnblock)(NSString *ssName);

/// 重新请求语音列表数据
@property (nonatomic, copy) void(^ReloadVoiceListDataBlock)(void);
//开始使用
@property (nonatomic, copy) void(^useOrderDataBlock)(NSDictionary *orderdic);
@property (nonatomic,strong) UIButton *downUpBtn; //上下按钮

- (void)selectBtnClicked:(UIButton *)button;
- (void)upVoiceBtn;
@end

NS_ASSUME_NONNULL_END
