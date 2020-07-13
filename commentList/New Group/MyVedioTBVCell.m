
//
//  MyVedioTBVCell.m
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/6/24.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "MyVedioTBVCell.h"
#import "Release&LikeVC.h"

@interface MyVedioTBVCell ()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)FSCustomButton *showMoreBtn;
@property(nonatomic,strong)Release_LikeVC  *release_LikeVC;

@end

@implementation MyVedioTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    MyVedioTBVCell *cell = (MyVedioTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[MyVedioTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:ReuseIdentifier
                                              marginX:3
                                              marginY:10];
        cell.contentView.backgroundColor = kBlueColor;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:kBlackColor
//                     AndBorderWidth:.1f];
        
    }return cell;
}

-(void)drawRect:(CGRect)rect{
    self.titleLab.alpha = 1;
    self.showMoreBtn.alpha = 1;
    self.release_LikeVC.view.alpha = 1;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 3.5;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    
}

-(void)showMoreBtnClickEvent:(UIButton *)sender{
    NSLog(@"查看更多");
    self.actionBlock(sender);
}

-(void)action:(DataBlock)actionBlock{
    self.actionBlock = actionBlock;
}

#pragma mark —— lazyLoad
-(Release_LikeVC *)release_LikeVC{
    if (!_release_LikeVC) {
        _release_LikeVC = Release_LikeVC.new;
        _release_LikeVC.view.backgroundColor = kRedColor;
        [self.contentView addSubview:_release_LikeVC.view];
        [_release_LikeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.titleLab.mas_bottom).offset(SCALING_RATIO(15));
        }];
    }return _release_LikeVC;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"我的视频";
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(SCALING_RATIO(15));
        }];
    }return _titleLab;
}

-(FSCustomButton *)showMoreBtn{
    if (!_showMoreBtn) {
        _showMoreBtn = FSCustomButton.new;
        _showMoreBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
        _showMoreBtn.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                        0,
                                                        0,
                                                        SCALING_RATIO(10));
        [_showMoreBtn setTitle:@"查看更多"
                   forState:UIControlStateNormal];
        [_showMoreBtn setImage:kIMG(@"查看更多")
                      forState:UIControlStateNormal];
        [_showMoreBtn addTarget:self
                         action:@selector(showMoreBtnClickEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showMoreBtn];
        [_showMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-15));
        }];
    }return _showMoreBtn;
}

@end
