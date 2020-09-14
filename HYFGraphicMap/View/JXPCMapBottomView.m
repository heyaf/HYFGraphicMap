//
//  JXPCMapBottomView.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCMapBottomView.h"
#import "JXPCMapNormalTableViewCell.h"
#import "JXPCMapVoiceTableViewCell.h"
#import "JXPCVoiceListModel.h"
#import "JXPCLineNameModel.h"
#import "JXPCScenicPointModel.h"
#import "JXPCFacilityModel.h"

#define downFrameY (kScreenH-48-kSafeAreaBottom)
@interface JXPCMapBottomView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *titleButtonArray;

@property (nonatomic,strong) UIImageView *titleBtnBottomImageV;  //标题按钮下部——线image

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString * selectNameString;

@property (nonatomic,strong) UIView *scenicPointHeaderView;  //景点头视图
@property (nonatomic,strong) UIButton *lockVoiceBtn;
@property (nonatomic,strong) UIView *scenicLineHeaderView;   //路线y头视图

/// 记录自身初始Y值
@property (nonatomic,assign) CGFloat frameY;

/// 景点数组
@property (nonatomic,strong) NSMutableArray *scenicPointArr;
///// 路线数组
//@property (nonatomic,strong) NSMutableArray *sceniclineArr;

@property (nonatomic,assign) NSInteger lineIndex;  //选中的路线
@property (nonatomic,assign) NSInteger voiceIndex;  //选中的语音

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic,strong) UIView *BottomSafeView;
@end


@implementation JXPCMapBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self baseSet];
        
    }
    
    return self;
}
- (void)baseSet{
    _frameY = self.y;
    self.y = downFrameY;
    _titleNameArray = [NSMutableArray arrayWithCapacity:0];
    [_titleNameArray addObjectsFromArray:@[@"听讲解",@"路线",@"景点",@"设施"]];
    
    _titleButtonArray = [NSMutableArray arrayWithCapacity:0];
    _selectNameString = @"听讲解";

    _lineIndex = 0;
    _voiceIndex = 0;


}
- (void)ReloadData{
//    for (JXPCFacilityModel *facilityModel in self.facilityArray) {
//        [_titleNameArray addObject:facilityModel.ssfnFacilitiesName];
//    }
    [self creatTitleView];
    [self tableView];
    [self bringSubviewToFront:self.BottomSafeView];

}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, kScreenW, self.height-kSafeAreaBottom-48) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorColor:kRGB(237, 237, 237)];
        [self addSubview:_tableView];
    }
    return _tableView;
}
-(void)setVoiceListArr:(NSArray *)voiceListArr{
    _voiceListArr = voiceListArr;
    [_tableView reloadData];
    JXPCVoiceListModel *voiceModel = self.voiceListArr[0];
    if (voiceModel.isFree) {
        self.lockVoiceBtn.hidden = YES;
    }

//
    if ([self.selectNameString isEqualToString:@"听讲解"]) {
        NSIndexPath *indexPatch = [NSIndexPath indexPathForRow:self.voiceIndex inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:indexPatch];
    }
}
-(void)setLineNameArr:(NSArray *)LineNameArr{
    _LineNameArr = LineNameArr;
//    self.sceniclineArr = [NSMutableArray arrayWithCapacity:0];
//    for (JXPCLineNameModel *lineNameModel in LineNameArr) {
//        if (lineNameModel.ssrtRouteNameStatus==1) {
//            [self.sceniclineArr addObject:lineNameModel];
//        }
//    }
}
-(void)setScenicPointListArr:(NSArray *)scenicPointListArr{
    _scenicPointListArr = scenicPointListArr;
}
-(void)setFacilityArray:(NSArray *)facilityArray{
    _facilityArray = facilityArray;
    [self ReloadData];
}
- (void)selectBtnClicked:(UIButton *)button{
    NSInteger index = button.tag -520;
    _selectNameString = button.titleLabel.text;
    for (UIButton *titleBtn in self.titleButtonArray) {
        titleBtn.selected = NO;
        if (titleBtn.tag==button.tag) {
            titleBtn.selected = YES;
        }
    }
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.titleBtnBottomImageV.x = index*72+13.5;
    }];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    if ([_selectNameString isEqualToString:@"景点"]) {
        if (self.ScenicBtnblock) {
            self.ScenicBtnblock(-1);
        }
    }else if ([_selectNameString isEqualToString:@"路线"]){
        if (self.lineBtnblock) {

            self.lineBtnblock();
        }
        NSIndexPath *Path = [NSIndexPath indexPathForItem:self.lineIndex inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:Path];
    }else if ([_selectNameString isEqualToString:@"听讲解"]){
        JXPCVoiceListModel *voicemodel = self.voiceListArr[_voiceIndex];
         if (self.voiceBtnblock) {
            self.voiceBtnblock(voicemodel.VoiceId,voicemodel.clientOrder);
         }
         NSIndexPath *Path = [NSIndexPath indexPathForItem:self.voiceIndex inSection:0];
         [self tableView:_tableView didSelectRowAtIndexPath:Path];
    }else {
        JXPCFacilityModel *facilityModel = self.facilityArray[0];
        if (self.SSBtnblock) {
            self.SSBtnblock(facilityModel.ssfnFacilitiesName);
        }
        
    }
    
    if (!self.downUpBtn.selected) {
        self.downUpBtn.selected = NO;
        [self downUpBtnClick:self.downUpBtn];
    }

    //启动定时器
    if ([_selectNameString isEqualToString:@"听讲解"]) {
    }else{
        [self deallocTimer];
    }


}
/// 弹起或收缩按钮事件
/// @param btn a按钮
- (void)downUpBtnClick:(UIButton *)btn{

    [UIView animateWithDuration:0.5 animations:^{
        if (btn.selected) {
            self.y = downFrameY;
            self.BottomSafeView.hidden = NO;
        }else{
            self.y = self.frameY;
            self.BottomSafeView.hidden = YES;
        }
    }];
    btn.selected = !btn.isSelected;
    
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.selectNameString isEqualToString:@"听讲解"]) {
        static NSString *cellID = @"JXPCMapVoiceTableViewCell";
        
        JXPCMapVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle  mainBundle]  loadNibNamed:@"JXPCMapVoiceTableViewCell" owner:self options:nil]  lastObject];
        }
        JXPCVoiceListModel *voiceModel = self.voiceListArr[indexPath.row];
        cell.voiceModel = voiceModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.useOrderBlock = ^{
            if (self.useOrderDataBlock) {
                self.useOrderDataBlock(voiceModel.clientOrder);
            }
        };
        return cell;
    }
    static NSString *cellID = @"JXPCMapNormalTableViewCell";
    
    JXPCMapNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle  mainBundle]  loadNibNamed:@"JXPCMapNormalTableViewCell" owner:self options:nil]  lastObject];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if ([self.selectNameString isEqualToString:@"景点"]) {
        cell.ImageView.image = kIMAGE_Name(@"jrdt_jd");
        JXPCScenicPointModel *scenicPointModel = self.scenicPointListArr[indexPath.row];
        cell.Label.text = scenicPointModel.ssaName;
        cell.tagImageView.hidden = NO;
        if ([scenicPointModel.clientVoicePacketDetails[@"isEffective"] integerValue]==1||[scenicPointModel.clientVoicePacketDetails[@"isFree"] integerValue]==1) {
            cell.tagImageView.hidden = YES;
        }
        if ([scenicPointModel.clientVoicePacketDetails[@"isAudition"] integerValue]==1) {
            cell.tagImageView.hidden = NO;
            cell.tagImageView.image = kIMAGE_Name(@"jrdt_st");
        }
    }else if([self.selectNameString isEqualToString:@"路线"]){
//        JXPCLineNameModel *linenameModel  = self.sceniclineArr[indexPath.row];
        cell.Label.text = self.LineNameArr[indexPath.row];
        cell.ImageView.image = kIMAGE_Name(@"lx_fast");
//        if ([linenameModel.ssrtRouteName isEqualToString:@"快速游"]) {
//
//        }else if ([linenameModel.ssrtRouteName isEqualToString:@"半日游"]) {
//            cell.ImageView.image = kIMAGE_Name(@"lx_half day");
//        }else if ([linenameModel.ssrtRouteName isEqualToString:@"一日游"]) {
//            cell.ImageView.image = kIMAGE_Name(@"lx_one day");
//        }
    }else{
//        JXPCFacilityModel *facilityModel;

        NSMutableArray *facArr = [NSMutableArray arrayWithCapacity:0];
        for (JXPCFacilityModel *facilityModel in self.facilityArray) {
            if (![facArr containsObject:facilityModel.ssfnFacilitiesName]) {
                [facArr addObject:facilityModel.ssfnFacilitiesName];
            }
        }
        
        NSString *facName = facArr[indexPath.row];
            if([facName isEqualToString:@"售票处"]){
                   cell.ImageView.image = kIMAGE_Name(@"spc_icon");
            }else if([facName isEqualToString:@"游客中心"]){
                   cell.ImageView.image = kIMAGE_Name(@"ykzx_icon");
            }else if([facName isEqualToString:@"出入口"]){
                   cell.ImageView.image = kIMAGE_Name(@"crk_icon");
            }else if([facName isEqualToString:@"餐饮"]){
                   cell.ImageView.image = kIMAGE_Name(@"cy_icon");
            }else if([facName isEqualToString:@"购物"]){
                   cell.ImageView.image = kIMAGE_Name(@"gw_icon");
            }else if([facName isEqualToString:@"卫生间"]){
                   cell.ImageView.image = kIMAGE_Name(@"cs_icon");
            }else if([facName isEqualToString:@"停车场"]){
                   cell.ImageView.image = kIMAGE_Name(@"tcc_icon");
            }else if([facName isEqualToString:@"热水房"]){
                   cell.ImageView.image = kIMAGE_Name(@"rsf_icon");
            }else if([facName isEqualToString:@"表演场"]){
                   cell.ImageView.image = kIMAGE_Name(@"byc_icon");
            }else if([facName isEqualToString:@"医务室"]){
                   cell.ImageView.image = kIMAGE_Name(@"yws_icon");
            }else if([facName isEqualToString:@"住宿"]){
                   cell.ImageView.image = kIMAGE_Name(@"zs_icon");
            }
            cell.Label.text = facName;
    }


    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([self.selectNameString isEqualToString:@"景点"]) {
       return self.scenicPointListArr.count;
    }else if ([self.selectNameString isEqualToString:@"路线"]) {
        return self.LineNameArr.count;
    }else if ([self.selectNameString isEqualToString:@"听讲解"]) {
        return self.voiceListArr.count;
    }else{
        NSMutableArray *facArr = [NSMutableArray arrayWithCapacity:0];
        for (JXPCFacilityModel *facilityModel in self.facilityArray) {
            if (![facArr containsObject:facilityModel.ssfnFacilitiesName]) {
                [facArr addObject:facilityModel.ssfnFacilitiesName];
            }
        }
        return facArr.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectNameString isEqualToString:@"听讲解"]) {
        return 130;
    }
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.selectNameString isEqualToString:@"听讲解"]||[self.selectNameString isEqualToString:@"路线"]) {
        return 48;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.selectNameString isEqualToString:@"听讲解"]) {
           return self.scenicPointHeaderView;
       }
    if ([self.selectNameString isEqualToString:@"路线"]) {
        return [self scenicLineHeaderView1];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectNameString isEqualToString:@"听讲解"]) {
//        JXPCMapVoiceTableViewCell *voiceCell = [tableView cellForRowAtIndexPath:indexPath];
//        voiceCell.selectImageView.hidden = NO;
//        voiceCell.backgroundColor = kRGB(242, 254, 250);
        for (JXPCVoiceListModel *voiceModel in self.voiceListArr) {
            voiceModel.isselect = NO;
        }
        JXPCVoiceListModel *voiceModel = self.voiceListArr[indexPath.row];
        voiceModel.isselect = YES;
        [self.tableView reloadData];
        self.voiceIndex = indexPath.row;
        if (self.voiceBtnblock) {
            self.voiceBtnblock(voiceModel.VoiceId,voiceModel.clientOrder);
        }
    }else if ([self.selectNameString isEqualToString:@"路线"]){
        JXPCMapNormalTableViewCell *normalCell = [tableView cellForRowAtIndexPath:indexPath];
        normalCell.SelectImageView.hidden = NO;
        self.lineIndex = indexPath.row;
        if (self.lineBtnblock) {

           self.lineBtnblock();
        }
    }else if ([self.selectNameString isEqualToString:@"景点"]){
        self.downUpBtn.selected = YES;
        [self downUpBtnClick:self.downUpBtn];
        JXPCScenicPointModel *spModel = self.scenicPointListArr[indexPath.row];
        if (self.ScenicBtnblock) {
            self.ScenicBtnblock(spModel.spId);

        }
//        JXPCMapNormalTableViewCell *normalCell = [tableView cellForRowAtIndexPath:indexPath];
//        normalCell.tagImageView.hidden = NO;
        
    }else if ([self.selectNameString isEqualToString:@"设施"]){
        NSMutableArray *facArr = [NSMutableArray arrayWithCapacity:0];
        for (JXPCFacilityModel *facilityModel in self.facilityArray) {
            if (![facArr containsObject:facilityModel.ssfnFacilitiesName]) {
                [facArr addObject:facilityModel.ssfnFacilitiesName];
            }
        }
        if (self.SSBtnblock) {
                self.SSBtnblock(facArr[indexPath.row]);
            }
        self.downUpBtn.selected = YES;
        [self downUpBtnClick:self.downUpBtn];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    if ([self.selectNameString isEqualToString:@"听讲解"]) {
//        JXPCMapVoiceTableViewCell *voiceCell = [tableView cellForRowAtIndexPath:indexPath];
//        voiceCell.selectImageView.hidden = YES;
//        voiceCell.backgroundColor = kWhiteColor;
//    }else
    if ([self.selectNameString isEqualToString:@"路线"]){
        JXPCMapNormalTableViewCell *normalCell = [tableView cellForRowAtIndexPath:indexPath];
        normalCell.SelectImageView.hidden = YES;
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self cellsForTableView:tableView];
    for (NSIndexPath *indexPath1 in arr) {
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath1];
    }
    return indexPath;
}



/// 获取所有的cell
/// @param tableView tableview
- (NSArray *)cellsForTableView:(UITableView *)tableView{
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows = [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [cells addObject:indexPath];
        }
    }
    return cells;
}


- (void)creatTitleView{
    CGFloat btnW = 72;
    CGFloat btnH = 48;
    
    UIScrollView *titleScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-48, 48)];
    [self addSubview:titleScrollview];
    titleScrollview.contentSize = CGSizeMake(btnW*_titleNameArray.count, 0);
    titleScrollview.showsHorizontalScrollIndicator = NO;
    
    UIView *safeBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, kScreenW, kSafeAreaBottom)];
    safeBottomView.backgroundColor = kWhiteColor;
    [self addSubview:safeBottomView];
    _BottomSafeView = safeBottomView;
    
    
    _titleBtnBottomImageV = [[UIImageView alloc] initWithFrame:CGRectMake((btnW-45)/2, btnH-9, 45, 4)];
    _titleBtnBottomImageV.image = kIMAGE_Name(@"jd_slider");
    [titleScrollview addSubview:_titleBtnBottomImageV];
    
    NSMutableArray *titleBtnImageArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleBtnImageArray1 = [NSMutableArray arrayWithCapacity:0];

    for (NSString *str in _titleNameArray) {
        if ([str isEqualToString:@"景点"]) {
            [titleBtnImageArray addObject:@"jd_uncheck"];
            [titleBtnImageArray1 addObject:@"jd_selected"];
        }else if ([str isEqualToString:@"路线"]) {
           [titleBtnImageArray addObject:@"lx_uncheck"];
           [titleBtnImageArray1 addObject:@"lx_selected"];
        }else if ([str isEqualToString:@"听讲解"]) {
           [titleBtnImageArray addObject:@"yyb_uncheck"];
           [titleBtnImageArray1 addObject:@"yyb_selected"];
        }else if ([str isEqualToString:@"设施"]) {
           [titleBtnImageArray addObject:@"ss_uncheck"];
           [titleBtnImageArray1 addObject:@"ss_selected"];
        }
//        else if ([str isEqualToString:@"游客中心"]) {
//            [titleBtnImageArray addObject:@"ykzx_uncheck"];
//            [titleBtnImageArray1 addObject:@"ykzx_selected"];
//        }else if ([str isEqualToString:@"出入口"]) {
//            [titleBtnImageArray addObject:@"crk_uncheck"];
//            [titleBtnImageArray1 addObject:@"crk_selected"];
//        }else if ([str isEqualToString:@"餐饮"]) {
//           [titleBtnImageArray addObject:@"cy_uncheck"];
//           [titleBtnImageArray1 addObject:@"cy_selected"];
//        }else if ([str isEqualToString:@"购物"]) {
//           [titleBtnImageArray addObject:@"gw_uncheck"];
//           [titleBtnImageArray1 addObject:@"gw_selected"];
//        }else if ([str isEqualToString:@"卫生间"]) {
//           [titleBtnImageArray addObject:@"cs_uncheck"];
//           [titleBtnImageArray1 addObject:@"cs_selected"];
//        }else  if ([str isEqualToString:@"停车场"]) {
//          [titleBtnImageArray addObject:@"tcc_uncheck"];
//          [titleBtnImageArray1 addObject:@"tcc_selected"];
//        }else  if ([str isEqualToString:@"热水房"]) {
//          [titleBtnImageArray addObject:@"rsf_uncheck"];
//          [titleBtnImageArray1 addObject:@"rsf_selected"];
//        }else  if ([str isEqualToString:@"表演场"]) {
//          [titleBtnImageArray addObject:@"byc_uncheck"];
//          [titleBtnImageArray1 addObject:@"byc_selected"];
//        }else  if ([str isEqualToString:@"医务室"]) {
//          [titleBtnImageArray addObject:@"yws_uncheck"];
//          [titleBtnImageArray1 addObject:@"yws_selected"];
//        }else  if ([str isEqualToString:@"住宿"]) {
//          [titleBtnImageArray addObject:@"zs_uncheck"];
//          [titleBtnImageArray1 addObject:@"zs_selected"];
//        }
    }

    for (int i =0; i<_titleNameArray.count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:0];
        selectBtn.frame = CGRectMake(i*btnW, 0, btnW, btnH);
        [selectBtn setImage:kIMAGE_Name(titleBtnImageArray[i]) forState:0];
        [selectBtn setImage:kIMAGE_Name(titleBtnImageArray1[i]) forState:UIControlStateSelected];
        [titleScrollview addSubview:selectBtn];
        selectBtn.titleLabel.text = _titleNameArray[i];
        [selectBtn setTitle:_titleNameArray[i] forState:0];
        selectBtn.titleLabel.font =kNormalFont(11);
        [selectBtn setTitleColor:kMainGrayColor forState:0];
        [selectBtn setTitleColor:kMainBlackColor forState:UIControlStateSelected];
        [selectBtn setImagePositionWithType:SSImagePositionTypeTop spacing:3.5];
        selectBtn.tag = 520+i;
        [selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleButtonArray addObject:selectBtn];
        
        if (i==0) {
            selectBtn.selected = YES;
        }
    }
    

    
    UIButton *downbtn = [UIButton buttonWithType:0];
    downbtn.frame = CGRectMake(kScreenW-54, 0, 54, 48);
    [downbtn setImage:kIMAGE_Name(@"action bar_up") forState:0];
    [downbtn setImage:kIMAGE_Name(@"action bar_down") forState:UIControlStateSelected];
    downbtn.backgroundColor = kWhiteColor;
    [self addSubview:downbtn];
    downbtn.layer.shadowColor = kMainGrayColor.CGColor;
    downbtn.layer.shadowOffset = CGSizeMake(0,0);
    downbtn.layer.shadowOpacity = 0.5;
    downbtn.layer.shadowRadius = 5;

    // 单边阴影 顶边
    CGRect shadowRect = CGRectZero;
    CGFloat originX,originY,sizeWith,sizeHeight;
    originX = 0;
    originY = 0;
    sizeWith = downbtn.bounds.size.width;
    sizeHeight = downbtn.bounds.size.height;
    shadowRect = CGRectMake(originX-10/2, originY, 20, sizeHeight);

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    downbtn.layer.shadowPath = path.CGPath;
    _downUpBtn = downbtn;
    [downbtn addTarget:self action:@selector(downUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, kScreenW, 0.5)];
    lineView.backgroundColor = kRGB(237, 237, 237);
    [self addSubview:lineView];
}
-(UIView *)scenicPointHeaderView{
    if (!_scenicPointHeaderView) {
        _scenicPointHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
        _scenicPointHeaderView.backgroundColor = kWhiteColor;
//        _scenicPointHeaderView.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, 110, 16)];
        label.text = @"多风格主题讲解";
        label.textColor =kMainBlackColor;
        label.font = kNormalFont(15);
        [_scenicPointHeaderView addSubview:label];
        
        _lockVoiceBtn = [UIButton buttonWithType:0];
        _lockVoiceBtn.frame = CGRectMake(kScreenW-15-92, 9, 92, 30);
        [_lockVoiceBtn setTitle:@"去解锁" forState:0];
        [_lockVoiceBtn setTitleColor:kRGB(71, 204, 160) forState:0];
        [_lockVoiceBtn setTitleColor:kMainGrayColor forState:UIControlStateSelected];
        _lockVoiceBtn.titleLabel.font = kNormalFont(13);
        [_lockVoiceBtn setBackgroundImage:kIMAGE_Name(@"yy_button_ksdl") forState:0];
        [_lockVoiceBtn setBackgroundImage:kIMAGE_Name(@"yy_button not click") forState:UIControlStateSelected];
        [_lockVoiceBtn addTarget:self action:@selector(lockVoice) forControlEvents:UIControlEventTouchUpInside];
        [_scenicPointHeaderView addSubview:_lockVoiceBtn];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, kScreenW, 0.5)];
        lineView.backgroundColor = kRGB(245, 245, 245);
        [_scenicPointHeaderView addSubview:lineView];
    }
    return _scenicPointHeaderView;
}
-(UIView *)scenicLineHeaderView1{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
    view.backgroundColor = kWhiteColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 56, 16)];
    imageView.image = kIMAGE_Name(@"lx_the current");
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(76, 17, kScreenW-15-76, 14)];
    label.textColor =kRGB(102, 102, 102);
    JXPCVoiceListModel *voiceModel = self.voiceListArr[_voiceIndex];
    label.text = voiceModel.voicePacketName;
    label.font = kNormalFont(13);
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5, kScreenW, 0.5)];
    lineView.backgroundColor = kRGB(245, 245, 245);
    [view addSubview:lineView];
    return view;
}
/// 解锁听讲解
-(void)lockVoice{
   
}

- (void)showOrderAlertWithOrdermodel:(JXPCVoiceListModel *)orderModel2{
   
}

- (void)cancleOrderWithid:(NSString *)orderID{
}

/// 修改去解锁按钮状态
/// @param index 2


/// 去解锁按钮是否可点击
/// @param lock 可点击
- (void)lockbtn:(BOOL)lock{
    _lockVoiceBtn.selected = !lock;
}

//定时器

- (void)deallocTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }

}
- (void)upVoiceBtn{
    for (UIButton *btn in self.titleButtonArray) {
        if (btn.tag==520) {
            if (self.y!=self.frameY||![self.selectNameString isEqualToString:@"听讲解"]) {
                btn.selected = YES;
                [self selectBtnClicked:btn];
            }else {
            }

        }
    }
}
@end
