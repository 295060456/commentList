//
//  TBVCell.m
//  commentList
//
//  Created by 刘赓 on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TBVCell.h"
#import "TBVCell_Detail.h"
#import <Masonry/Masonry.h>

#define Rule 3

@interface TBVCell ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *loadingMoreLab;

@property(nonatomic,strong)NSArray <NSArray <NSString*>*>*dataArr;
//@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]
@end

@implementation TBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    TBVCell *cell = (TBVCell *)[tableView dequeueReusableCellWithIdentifier:@"TBVCell"];
    if (!cell) {
        cell = [[TBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"TBVCell"];
        cell.contentView.backgroundColor = [UIColor greenColor];
    }return cell;
}

-(void)drawRect:(CGRect)rect{

}
//@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]
+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    if ([model isKindOfClass:NSArray.class]) {
        NSArray <NSArray <NSString *>*>*arr = (NSArray *)model;
        NSArray *temp_1_Arr = arr[0];
        NSArray *temp_2_Arr = arr[1];
        long t = temp_1_Arr.count + temp_2_Arr.count;//一级标题 ＋ 二级标题
        if (t > Rule) {//包括主标题有大于3条数据 出现“加载更多”
            return 5 * 55;//只展示3个数据
        }else if(t <= Rule && t >= 1){//没有 出现“加载更多”
            return 55 * t;
        }else{//只有主标题
            return 55;
        }
    }else{
        return 0;
    }
}
//@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]
- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.dataArr = (NSArray *)model;
    self.titleLab.text = self.dataArr[0][0];//一级
    self.tableView.alpha = 1;//二级
    self.loadingMoreLab.alpha = 1;
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
    if (self.dataArr[1].count > Rule) {
        return Rule;
    }else return self.dataArr[1].count;
}
//@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TBVCell_Detail *cell = [TBVCell_Detail cellWith:tableView];
    [cell richElementsInCellWithModel:self.dataArr[1][indexPath.row]];
    return cell;
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
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLab.mas_bottom);
        }];
    }return _tableView;
}

-(UILabel *)loadingMoreLab{
    if (!_loadingMoreLab) {
        _loadingMoreLab = UILabel.new;
        _loadingMoreLab.text = @"加载更多";
        _loadingMoreLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_loadingMoreLab];
        [_loadingMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.tableView.mas_bottom);
            make.height.mas_equalTo(55);
        }];
    }return _loadingMoreLab;
}


@end
