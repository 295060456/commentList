//
//  ViewController.m
//  commentList
//
//  Created by Jobs on 2020/7/13.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

#import "TBVCell.h"

@interface ViewController ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSArray <NSArray <NSString *>*>*>*dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.alpha = 1;
}
#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TBVCell cellHeightWithModel:self.dataArr[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TBVCell *cell = [TBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:self.dataArr[indexPath.row]];
    return cell;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray <NSArray <NSArray <NSString *>*>*>*)dataArr{
    if (!_dataArr) {
        _dataArr = NSMutableArray.array;
        [_dataArr addObject:@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]];
        [_dataArr addObject:@[@[@"我是标题 2"],@[@"我是标题 2.1",@"我是标题 2.2",@"我是标题 2.3"]]];
        [_dataArr addObject:@[@[@"我是标题 3"],@[]]];
        [_dataArr addObject:@[@[@"我是标题 4"],@[@"我是标题 4.1"]]];
        [_dataArr addObject:@[@[@"我是标题 5"],@[@"我是标题 5.1",@"我是标题 5.2"]]];
    }return _dataArr;
}




@end
