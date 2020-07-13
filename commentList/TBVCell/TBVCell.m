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
    self.titleLab.alpha = 1;
    self.tableView.alpha = 1;
    self.loadingMoreLab.alpha = 1;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    NSArray *arr = model;
    if (arr.count > Rule) {
        return 55 * 2 + arr.count * 55;
    }else if (arr.count == 1){

    }else if (arr.count == 0){
        return 55;
    }else{//
        return 55;
    }
}

- (void)richElementsInCellWithModel:(id _Nullable)model{

}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
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
        _loadingMoreLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_loadingMoreLab];
        [_loadingMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.tableView.mas_bottom);
        }];
    }return _loadingMoreLab;
}


@end
