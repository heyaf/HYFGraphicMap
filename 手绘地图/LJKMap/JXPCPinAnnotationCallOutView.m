//
//  JXPCPinAnnotationCallOutView.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/25.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCPinAnnotationCallOutView.h"
//#import "YGAudioPlayer.h"

@interface JXPCPinAnnotationCallOutView ()
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *MainbgView;



@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, weak)   LJKPinAnnotationMapView *mapView;
//@property (nonatomic, strong)AVAudioPlayer *audioPlayer;
@end
@implementation JXPCPinAnnotationCallOutView
- (id)initOnMapView:(LJKPinAnnotationMapView *)mapView{
    
    self = [[NSBundle mainBundle] loadNibNamed:@"JXPCPinAnnotationCallOutView" owner:nil options:nil].lastObject;
//    self = [super initWithFrame:CGRectMake(0, 0, 257, 106)];
    if (self) {
        self.mapView = mapView;
        self.hidden  = YES;
        self.sceneImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.audioBtn.titleLabel.font = kNormalFont(12);

    }
    return self;
}

- (void)setMap:(LJKPinAnnotationMapView *)mapView{
    
    self.mapView = mapView;
    self.hidden = YES;
}

- (void)setAnnotation:(LJKPinAnnotation *)annotation
{
    _annotation = annotation;
    self.position = annotation.point;
    self.point = annotation.point;

    [self updatePosition];
    
    self.titleLabel.text = annotation.title;
    [self.sceneImageView sd_setImageWithURL:[NSURL URLWithString:self.annotation.imageUrl]];
    
//    if (annotation.type==Scene) {
//        self.audioBtn.hidden = YES;
//        self.width = 188;
//    }else{
        self.audioBtn.hidden = NO;
        self.width = 257;
//    }
    if (annotation.scenicType==0) {
        [self.audioBtn setTitle:@"解锁" forState:UIControlStateNormal];
    }else{
        [self.audioBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    if (annotation.canTrial) {
        [self.audioBtn setTitle:@"试听" forState:UIControlStateNormal];
    }
//    NSInteger playingid = [[kUserDefaults objectForKey:@"playeringId"] integerValue];
//    if ([[kUserDefaults objectForKey:@"playeringId"] integerValue] ==self.annotation.linePointId&&[YGAudioPlayer sharedInstance].playStatus == YGAudioPlayerPlayStatusPlaying) {
//        [self.audioBtn setTitle:@"暂停" forState:UIControlStateNormal];
//    }
}

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.position];
    CGFloat xPos = point.x - (self.frame.size.width / 2.0f);
    CGFloat yPos = point.y+12; //12为景点图片的宽高的一半 24/2
    
//

//    CGFloat ScreenH = kScreenH-kNavBarHeight-kSafeAreaBottom-48+51;  //屏高
//    CGFloat ScreenW = (ScreenH/self.mapView.originalSize.height)*self.mapView.originalSize.width; //一屏幕显示的底图宽度
//    CGFloat zoomMultiple = self.mapView.contentSize.height/ScreenH; //
//    CGFloat zoomMultiple1 = self.mapView.originalSize.width/self.mapView.contentSize.width; //

    ASLog(@"~~~~~%f,%f",self.mapView.contentSize.height,self.mapView.originalSize.height);
    ASLog(@".....%f,%f...%f",point.x,point.y,self.width);
    NSInteger selfwidth = 257;
//    if (self.annotation.type ==line||self.annotation.type==Voice) {
//        selfwidth = 257;
//    }else{
//        selfwidth = 188;
//    }
    if (point.x<selfwidth/2&&(self.mapView.contentSize.height-point.y)<self.height+12) {             //---------左下--------
        self.arrowsX.constant =-(selfwidth/2)+5;
        self.arrawsY.constant = self.height-6;
        self.mainBgViewY.constant = 0;
        xPos = point.x-10;
        yPos = point.y - (self.frame.size.height) - 16;
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_down");
    }else if (point.x<selfwidth/2){                                                                  //---------左上--------
        self.arrowsX.constant =-(selfwidth/2)+5;
        self.arrawsY.constant = 0;
        self.mainBgViewY.constant = 6;
        xPos = point.x-10;
        yPos = point.y + 16;
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_up");

    }else if ((self.mapView.contentSize.width-point.x)<selfwidth/2&&(self.mapView.contentSize.height-point.y)<self.height+12) {   //---------右下--------
        self.arrowsX.constant =(selfwidth/2)-12-5;
        self.arrawsY.constant = self.height-6;
        self.mainBgViewY.constant = 0;
        xPos = point.x+10-selfwidth;
        yPos = point.y - (self.frame.size.height) - 16;
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_down");

    }else if ((self.mapView.contentSize.width-point.x)<selfwidth/2){                   //---------右上--------
        self.arrowsX.constant =(selfwidth/2)-12-5;
        self.arrawsY.constant = 0;
        self.mainBgViewY.constant = 6;
        xPos = point.x+10-selfwidth;
        yPos = point.y + 16;
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_up");

    }else if((self.mapView.contentSize.height-point.y)<self.height+12){
        self.arrowsX.constant =-6;
        self.arrawsY.constant = self.height-6;
        self.mainBgViewY.constant = 0;
        xPos = point.x-selfwidth/2;
        yPos = point.y - self.height - 16;
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_down");

    }else{
        self.arrowsX.constant =-6;
        self.arrawsY.constant = 0;
        self.mainBgViewY.constant = 6;
        xPos = point.x-selfwidth/2;
        yPos = point.y + 16;
        
        self.arrowsImageView.image = kIMAGE_Name(@"triangle_up");

    }
//    ASLog(@".....%f,%f",point.x,self.width/2/ScreenW*self.mapView.originalSize.width/zoomMultiple1);
//    ASLog(@"%f,%f",self.mapView.contentSize.width,zoomMultiple);

    if (self.superview) {
        self.superview.frame = CGRectMake(floor(xPos), yPos, selfwidth, 106);
    }else{
        self.frame = CGRectMake(floor(xPos), yPos,selfwidth, 106);
    }
}

- (void)stopPlay{
    ASLog(@"停止播放");
}
- (IBAction)cancleBtnclicked:(id)sender {
    [self.mapView hideCallOut];
}

- (IBAction)TryBtnclicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if ([btn.titleLabel.text isEqualToString:@"解锁"]) {
//        KPostNotification(KNotificationMapVoiceUnLock, nil, nil);
        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"试听"]||[btn.titleLabel.text isEqualToString:@"播放"]) {
//        KPostNotification(KNotificationMapScenicPlay, @(YES), @{@"scenicPointid":@(self.annotation.linePointId)});
        [self.audioBtn setTitle:@"暂停" forState:UIControlStateNormal];

        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"暂停"]) {
//        KPostNotification(KNotificationMapScenicPlay, @(NO), @{@"scenicPointid":@(self.annotation.linePointId)});
        if (self.annotation.canTrial) {
            [self.audioBtn setTitle:@"试听" forState:UIControlStateNormal];
        }else{
            [self.audioBtn setTitle:@"播放" forState:UIControlStateNormal];
        }

        return;
    }
    


}
-(void)changeVoiceBtn:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;

    if ([dic[@"state"] isEqualToString:@"0"]) {  //恢复原装
        if (self.annotation.scenicType==0) {
            [self.audioBtn setTitle:@"解锁" forState:UIControlStateNormal];
        }else{
            [self.audioBtn setTitle:@"播放" forState:UIControlStateNormal];
        }
        if (self.annotation.canTrial) {
            [self.audioBtn setTitle:@"试听" forState:UIControlStateNormal];
        }
    }else if ([dic[@"state"] isEqualToString:@"1"]) {  //自动触发开始播放
            [self.audioBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
    }
}

- (IBAction)DetailBtnclicked:(id)sender {
//    KPostNotification(KNotificationMapScenicDetail, nil, @{@"spId":@(self.annotation.linePointId)});
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
