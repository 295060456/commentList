//
//  TBVCell.m
//  commentList
//
//  Created by 刘赓 on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TBVCell.h"
#import "TBVCell_Detail.h"

#define Rule 3//二级标题展示多少个

@interface TBVCell ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *loadingMoreBtn;

@property(nonatomic,strong)NSArray <NSArray <NSString*>*>*dataArr;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,assign)BOOL isUnfold;

@end

@implementation TBVCell

+(instancetype)cellWith:(UITableView *)tableView
              withModel:(id _Nullable)model{
    
    TBVCell *cell = [[TBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:@"TBVCell_style_2"];
    cell.contentView.backgroundColor = [UIColor blueColor];
    return cell;
    
//    NSArray <NSArray <NSString*>*>*tempArr = (NSArray *)model;
//    TBVCell *cell = nil;
//    if (tempArr.count > Rule) {//包括主标题有大于3条数据 出现“加载更多”
//        cell = (TBVCell *)[tableView dequeueReusableCellWithIdentifier:@"TBVCell_style_1"];
//        if (!cell) {
//            cell = [[TBVCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                 reuseIdentifier:@"TBVCell_style_1"];
//            cell.contentView.backgroundColor = [UIColor greenColor];
//        }return cell;
//    }else{
//        cell = (TBVCell *)[tableView dequeueReusableCellWithIdentifier:@"TBVCell_style_2"];
//        if (!cell) {
//            cell = [[TBVCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                 reuseIdentifier:@"TBVCell_style_2"];
//            cell.contentView.backgroundColor = [UIColor blueColor];
//        }return cell;
//    }
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"");
}
//上个页面要用
+(CGFloat)cellHeightWithModel:(id _Nullable)model{//
    NSArray <NSArray <NSString *>*>*arr = (NSArray *)model[@"data"];
    NSArray *temp_2_Arr = arr[1];// 二级标题
    bool IsUnfold = [model[@"isUnfold"] boolValue];
    if (IsUnfold) {
        return (temp_2_Arr.count + 1) * 55;
    }else{
        if (temp_2_Arr.count > Rule) {//包括主标题有大于3条数据 出现“加载更多”
            return (Rule + 2) * 55;//只展示3个数据
        }else if(temp_2_Arr.count <= Rule && temp_2_Arr.count >= 1){//没有 出现“加载更多”
            return (temp_2_Arr.count + 1) * 55;
        }else{//只有主标题
            return 55;
        }
    }
}
//上个页面要用
- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.dataArr = (NSArray *)model[@"data"];
    self.isUnfold = [model[@"isUnfold"] boolValue];
    self.titleLab.text = self.dataArr[0][0];//一级
    self.tableView.alpha = 1;//二级
    if (self.dataArr[1].count > Rule && !self.isUnfold) {
        self.loadingMoreBtn.alpha = 1;
        self.loadingMoreBtn.tag = [model[@"indexPath"] intValue];
    }else if (self.isUnfold){
        [self.loadingMoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }else{}
}
#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr[1].count > Rule && !self.isUnfold) {
        return Rule;
    }else{
        return self.dataArr[1].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TBVCell_Detail *cell = [TBVCell_Detail cellWith:tableView];
    [cell richElementsInCellWithModel:self.dataArr[1][indexPath.row]];
    return cell;
}

-(void)loadingMoreBtnClickEvent:(UIButton *)sender{
    if (self.block) {
        self.block(sender);
    }
}

-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.backgroundColor = [UIColor grayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(55);
        }];
    }return _titleLab;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom);
            make.left.right.equalTo(self.contentView);
#warning 这个地方要写底部的约束，否则tableView无法出现
            NSArray *temp_2_arr = self.dataArr[1];
            if (temp_2_arr.count > Rule) {//包括主标题有大于3条数据 出现“加载更多”
                make.bottom.equalTo(self.loadingMoreBtn.mas_top);
            }else{
                make.bottom.equalTo(self.contentView);
            }
        }];
    }return _tableView;
}

-(UIButton *)loadingMoreBtn{
    if (!_loadingMoreBtn) {
        _loadingMoreBtn = UIButton.new;
        _loadingMoreBtn.backgroundColor = [UIColor systemBlueColor];
        [_loadingMoreBtn setTitle:@"加载更多"
                         forState:UIControlStateNormal];
        [_loadingMoreBtn addTarget:self
                            action:@selector(loadingMoreBtnClickEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_loadingMoreBtn];
        [_loadingMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.tableView.mas_bottom);
            make.height.mas_equalTo(55);
        }];
    }return _loadingMoreBtn;
}


@end
