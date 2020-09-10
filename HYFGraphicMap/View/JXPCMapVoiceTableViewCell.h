//
//  JXPCMapVoiceTableViewCell.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPCVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JXPCMapVoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *VoiceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;

@property (weak, nonatomic) IBOutlet UIImageView *GuiderHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *GuiderNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guiderLabelmargin;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fromSharingImageView;
@property (nonatomic,strong) JXPCVoiceListModel *voiceModel;
@property (nonatomic, copy) void(^unlockBlock)(void);
@property (nonatomic, copy) void(^useOrderBlock)(void);

@property (nonatomic,strong) UIButton *startBtn;
@end

NS_ASSUME_NONNULL_END
