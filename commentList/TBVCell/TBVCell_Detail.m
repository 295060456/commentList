//
//  TBVCell_Detail.m
//  commentList
//
//  Created by 刘赓 on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TBVCell_Detail.h"

@interface TBVCell_Detail ()

@property(nonatomic,strong)UILabel *detailTitleLab;

@end
//二级
@implementation TBVCell_Detail

+(instancetype)cellWith:(UITableView *)tableView{
    TBVCell_Detail *cell = (TBVCell_Detail *)[tableView dequeueReusableCellWithIdentifier:@"TBVCell_Detail"];
    if (!cell) {
        cell = [[TBVCell_Detail alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"TBVCell_Detail"];
        cell.contentView.backgroundColor = [UIColor blueColor];

    }return cell;
}

-(void)drawRect:(CGRect)rect{
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return 55;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.detailTitleLab.text = model;
}

-(UILabel *)detailTitleLab{
    if (!_detailTitleLab) {
        _detailTitleLab = UILabel.new;
        _detailTitleLab.backgroundColor = [UIColor redColor];
        _detailTitleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_detailTitleLab];
        [_detailTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _detailTitleLab;
}

@end
