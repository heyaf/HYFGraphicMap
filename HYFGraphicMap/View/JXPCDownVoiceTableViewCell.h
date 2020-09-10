//
//  JXPCDownVoiceTableViewCell.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/6.
//  Copyright © 2020 he. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCDownVoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *MainBGView;
@property (weak, nonatomic) IBOutlet UILabel *VoiceTitle;
@property (weak, nonatomic) IBOutlet UILabel *VoiceSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
- (IBAction)downBtnClicked:(id)sender;
@property (nonatomic,strong) CAShapeLayer *btnlayer;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign) CGFloat Layerprogress;
@property (nonatomic,assign) NSInteger btnImageStates; //设置中间按钮图片

@property (weak, nonatomic) IBOutlet UIView *btnBgView;

@property (nonatomic,copy) void(^btnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
