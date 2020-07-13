//
//  TBVCell_Detail.m
//  commentList
//
//  Created by 刘赓 on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "TBVCell_Detail.h"
#import <Masonry/Masonry.h>

@interface TBVCell_Detail ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

@end

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

}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
    }return _tableView;
}

@end
