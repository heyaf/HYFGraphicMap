//
//  JXPCMapVoiceTableViewCell.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCMapVoiceTableViewCell.h"


@implementation JXPCMapVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewRadius(self.VoiceImageView, 5);
    self.selectImageView.hidden = YES;
    self.VoiceImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.GuiderHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    kViewRadius(self.GuiderHeaderImageView, 12);
}
- (void)setVoiceModel:(JXPCVoiceListModel *)voiceModel{
    _voiceModel = voiceModel;

    CGFloat pricef = voiceModel.price/100.00;
    NSString *priceStr = kStringFormat(@"￥%.2f",pricef);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:priceStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 20]} range:NSMakeRange(1, priceStr.length-1)];

    if (voiceModel.clientOrder) {
        if ([voiceModel.clientOrder[@"shareOrder"] integerValue]==1) {
            self.fromSharingImageView.hidden = NO;
        }else{
            self.fromSharingImageView.hidden = YES;
        }
    }else{
        self.fromSharingImageView.hidden = YES;

    }
    
     NSInteger commentnum = voiceModel.commentNumber;
    if (voiceModel.commentNumber==0) {
        commentnum=1;
    }

     CGFloat  f = voiceModel.clientVoicePacketSumStar/(float)commentnum;

    NSInteger num = (int)roundf(f);
    NSInteger num1 = num/2;
    NSInteger num2 = num%2;
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<5; i++) {
        UIImageView *starImageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*(12+5), 0, 12, 12)];
        starImageV.image = kIMAGE_Name(@"scene_list_score_empty");
        [self.starView addSubview:starImageV];
        [imageArr addObject:starImageV];
    }
    if (num1 >0) {
        for (int j=0;j<num1;j++) {
            UIImageView *imageV = imageArr[j];
            imageV.image = kIMAGE_Name(@"scene_list_score_full");
        }
        if (num2==1) {
            UIImageView *imageV = imageArr[num1];
            imageV.image = kIMAGE_Name(@"scene_list_score_half");
        }
    }
    //半✨
    if (num == 1) {
        UIImageView *imageV = imageArr[num1];
        imageV.image = kIMAGE_Name(@"scene_list_score_half");
    }
    
    [self.VoiceImageView sd_setImageWithURL:[NSURL URLWithString:voiceModel.voicePacketImageUrl] placeholderImage:nil];
    self.titleNameLabel.text = voiceModel.voicePacketName;

    self.youhuiLabel.text = voiceModel.discountActivity;
    [self.GuiderHeaderImageView sd_setImageWithURL:[NSURL URLWithString:voiceModel.clientGuide[@"clientGuideElephant"]] placeholderImage:kIMAGE_Name(@"icon3")];
    self.GuiderNameLabel.text = voiceModel.clientGuide[@"clientGuideName"];
    
    if (voiceModel.isselect) {
        self.selectImageView.hidden = NO;
        self.backgroundColor = kRGB(242, 254, 250);
    }else{
        self.selectImageView.hidden = YES;
        self.backgroundColor = kWhiteColor;
    }
    
    if (voiceModel.clientOrder) {
        NSDictionary *orderDic = voiceModel.clientOrder;
        if ([orderDic[@"orderType"] integerValue]==1) {
            self.PriceLabel.hidden = YES;
            UIButton *startBtn = [UIButton buttonWithType:0];
            startBtn.frame = CGRectMake(kScreenW-92-15, 130-15-30, 92, 30);
            startBtn.backgroundColor =kClearColor;
            kViewBorderRadius(startBtn, 15, 1, kRGB(71, 204, 160));
            [startBtn setTitle:@"开始使用" forState:0    ];
            [startBtn setTitleColor:kRGB(71, 204, 160) forState:0];
            startBtn.titleLabel.font = kNormalFont(13);
            [startBtn addTarget:self action:@selector(startUse) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:startBtn];
            _startBtn = startBtn;
            self.guiderLabelmargin.constant = 122;
        }else if ([orderDic[@"orderType"] integerValue]==2||[orderDic[@"orderType"] integerValue]==3){
            
            self.PriceLabel.hidden = NO;
            self.guiderLabelmargin.constant = 60;
        }else{
            self.PriceLabel.hidden = NO;
            self.PriceLabel.attributedText = string;
            self.guiderLabelmargin.constant = 60;

        }
    }else{
        self.PriceLabel.hidden = NO;
        self.PriceLabel.attributedText = string;
        self.guiderLabelmargin.constant = 60;
        
    }
    
    if (voiceModel.isFree==1) {
        self.PriceLabel.hidden = YES;
        self.startBtn.hidden = YES;
    }
}
- (void)startUse{
    if (self.useOrderBlock) {
        self.useOrderBlock();
    }
}


@end
