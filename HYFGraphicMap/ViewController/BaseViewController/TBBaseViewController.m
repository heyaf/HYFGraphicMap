
//
//  TBBaseViewController.m
//  TabbarBeyondClick
//
//  Created by lujh on 2017/4/18.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "TBBaseViewController.h"
#import "UIFactory.h"

@interface TBBaseViewController ()
@property (nonatomic, retain) UIView* overlayView;
@property (nonatomic, retain) UIView* bgview;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UIImageView *loadingImageView;

@property (nonatomic,strong) UIButton *actionButton;
@end

@implementation TBBaseViewController


- (void)viewDidLoad
{  
    [super viewDidLoad];
    
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.view.backgroundColor = kRGB(245, 245, 245);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRGB(51, 51, 51),
                                                                         NSFontAttributeName : [UIFont fontWithName:@"PingFang-SC-Medium" size:18]}];
    //导航栏 返回 按钮
    NSArray *viewControllers = self.navigationController.viewControllers;
//    self.tabBar.unselectedItemTintColor = [UIColor blackColor];
    if (viewControllers.count > 1){
        
        [self.navigationItem setHidesBackButton:NO animated:NO];
        
        UIBarButtonItem *leftBarButtonItem = [UIFactory createBackBarButtonItemWithTarget:self action:@selector(backAction)];
        
        if (iOS7) {
            
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = -15;
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarButtonItem];
            
        }else{
            
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        //返回的手势
        //UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSweepGesture:)];
        //gesture.direction = UISwipeGestureRecognizerDirectionRight;
        //[self.view addGestureRecognizer:gesture];
        
        
    }else{
        
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
    }
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(10, kStatusBarHeight+100, 44, 20);
    backBtn.backgroundColor = kBlueColor;
    
    [backBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.actionButton = backBtn;
    [self.view addSubview:backBtn];
    self.actionButton.hidden = YES;
    [self setNavigationBackImage:@"navibar_return"];

}
- (void)setNavigationBackImage:(NSString *)imageName{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 25);
    leftButton.titleLabel.font = Nav_Back_Font_M;
//    [leftButton setTitleColor:Theme_Color_Pink forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    leftButton.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = nil;
     self.navigationItem.leftBarButtonItem = leftBtn;
}
- (void)setNavigationRightImage:(NSString *)imageName{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 25);
    leftButton.titleLabel.font = Nav_Back_Font_M;
//    [leftButton setTitleColor:Theme_Color_Pink forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];

    leftButton.adjustsImageWhenHighlighted = NO;
    [leftButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = nil;
     self.navigationItem.rightBarButtonItem = leftBtn;
}
-(void)rightBtnClick:(id)sender{
    
}

- (void)backSweepGesture:(UISwipeGestureRecognizer*)gesture{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 禁用返回手势
- (void)banGestureBack{
    //
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
     UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
     [self.view addGestureRecognizer:pan];
}
//启用返回手势
-(void)pickGestureBack{
    //    // 先设置测滑代理
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // 将系统自带的滑动手势打开
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)setTextButtonhiden:(BOOL)textButtonhiden{
    if (!textButtonhiden) {
        self.actionButton.hidden = NO;
        [self.view bringSubviewToFront:self.actionButton];
        return;
    }
    self.actionButton.hidden = YES;

}
-(void)buttonAction{
    
}
#pragma mark -
#pragma mark Action

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setCustomerTitle:(NSString *)title{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    
}


@end
