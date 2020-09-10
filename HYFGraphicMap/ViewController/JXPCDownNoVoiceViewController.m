//
//  JXPCDownNoVoiceViewController.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/6.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCDownNoVoiceViewController.h"

@interface JXPCDownNoVoiceViewController ()

@end

@implementation JXPCDownNoVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.view.backgroundColor = kClearColor;
    [self CreatUI];
}

- (void)CreatUI{


    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    bgView.backgroundColor = kRGBA(0, 0, 0, 0.3);
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = YES;


    CGFloat H = 250+kSafeAreaBottom;
    UIView *view1 = [[UIView alloc] init];
    view1.frame = CGRectMake(0,kScreenH-H,kScreenW,H+15);
    view1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self.view addSubview:view1];

    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(kScreenW-35, 15, 20, 20);
    [btn setBackgroundImage:kIMAGE_Name(@"yytc_cancel") forState:0];
    [view1 addSubview:btn];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    view1.layer.cornerRadius = 15;
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, kScreenW-160, 16)];
    titlelabel.text = @"离线下载";
    titlelabel.textColor =kMainBlackColor;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = kNormalFont(18);
    [view1 addSubview:titlelabel];
    
     
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 54, kScreenW-40, 12)];
    titlelabel1.text = @"在Wi-Fi的网络环境下下载离线包";
    titlelabel1.textColor =kRGB(102, 102, 102);
    titlelabel1.textAlignment = NSTextAlignmentCenter;
    titlelabel1.font = kNormalFont(12);
    [view1 addSubview:titlelabel1];
    UILabel *titlelabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, kScreenW-40, 14)];
    titlelabel2.text = @"您还没有购买语音包服务，请先";
    titlelabel2.textColor =kRGB(153, 153, 153);
    titlelabel2.textAlignment = NSTextAlignmentCenter;
    titlelabel2.font = kNormalFont(14);
    [view1 addSubview:titlelabel2];
    UILabel *titlelabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 117, kScreenW-40, 12)];
    titlelabel3.text = @"选择语音包再下载使用";
    titlelabel3.textColor =kRGB(153, 153, 153);
    titlelabel3.textAlignment = NSTextAlignmentCenter;
    titlelabel3.font = kNormalFont(14);
    [view1 addSubview:titlelabel3];
    
    UIButton *chooseVoiceBtn = [UIButton buttonWithType:0];
    chooseVoiceBtn.frame = CGRectMake(kScreenW/2-100, 159, 200, 44);
    [chooseVoiceBtn setBackgroundImage:kIMAGE_Name(@"bddh_bg") forState:0];
    [chooseVoiceBtn setTitleColor:kWhiteColor forState:0];
    [chooseVoiceBtn setTitle:@"选择语音包" forState:0];
    chooseVoiceBtn .titleLabel.font = kNormalFont(16);
    [view1 addSubview:chooseVoiceBtn];
    [chooseVoiceBtn addTarget:self action:@selector(chooseVoice) forControlEvents:UIControlEventTouchUpInside];
}
- (void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)chooseVoice{
    [self dismiss];
    if (self.chooseVoiceBlock) {
        self.chooseVoiceBlock();
    }
}
@end
