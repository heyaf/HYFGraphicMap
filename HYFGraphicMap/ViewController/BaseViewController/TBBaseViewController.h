//
//  TBBaseViewController.h
//  TabbarBeyondClick
//
//  Created by lujh on 2017/4/18.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define KNotifitionSelectChange @"selectionState"


typedef NS_ENUM(NSInteger, MineActionType) {
    MineActionCollect,
    MineActionComment,
    MineActionLike,
    MineActionPublish,//我发布的
};

@interface TBBaseViewController : UIViewController

- (void)backAction;

-(void)setCustomerTitle:(NSString *)title;


/// 设置返回图标
/// @param imageName imageName
- (void)setNavigationBackImage:(NSString *)imageName;

/// 设置右导航栏按钮
/// @param imageName imagename
- (void)setNavigationRightImage:(NSString *)imageName;
- (void)rightBtnClick:(id)sender;

/// 测试按钮，当前界面需要按钮做测试时显示
@property (nonatomic,assign) BOOL textButtonhiden;
-(void)buttonAction;

// 禁用返回手势
- (void)banGestureBack;
//启用返回手势
- (void)pickGestureBack;
@end
