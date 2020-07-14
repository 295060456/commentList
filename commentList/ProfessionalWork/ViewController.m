
//
//  ViewController.m
//  commentList
//
//  Created by Jobs on 2020/7/14.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "ViewController.h"
#import "LoadMoreTBVCell.h"
#import "InfoTBVCell.h"

#import "NonHoveringHeaderView.h"
#import "HoveringHeaderView.h"
#import "UITableViewHeaderFooterView+Attribute.h"

#define preMax 3

@interface ViewController ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSArray <NSArray <NSString *>*>*>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*supplementDataMutArr;
@property(nonatomic,assign)BOOL isFullShow;

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
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (LoadMoreTBVCell.class == [tableView cellForRowAtIndexPath:indexPath].class) {
        NSArray *arr_0 = self.dataMutArr[indexPath.section][0];
        NSArray *arr_1 = self.dataMutArr[indexPath.section][1];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:arr_1];
        NSLog(@"");
        for (NSString *str in self.supplementDataMutArr) {
            [temp addObject:str];
        }
        [self.dataMutArr removeObjectAtIndex:indexPath.section];
        [self.dataMutArr insertObject:@[arr_0,temp]
                              atIndex:indexPath.section];
        NSLog(@"");
        self.isFullShow = YES;
        //两种刷新方法
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
        //    [self.tableView reloadData];
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (self.dataMutArr[section][1].count > preMax && !self.isFullShow) {
        return preMax + 1;
    }else{
        return self.dataMutArr[section][1].count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{

    Class headerClass = NonHoveringHeaderView.class;
//    Class headerClass = HoveringHeaderView.class;
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerClass)];
    header.tableView = tableView;
    header.section = section;
    header.textLabel.text = self.dataMutArr[section][0][0];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{//preMax
    if (self.dataMutArr[indexPath.section][1].count > preMax && !self.isFullShow) {
        //截留 最后一个cell是 LoadMoreTBVCell
        if (indexPath.row == preMax) {
            LoadMoreTBVCell *cell = [LoadMoreTBVCell cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            return cell;
        }else{
            InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
//            int r = indexPath.row;
//            int d = indexPath.section;
            [cell richElementsInCellWithModel:self.dataMutArr[indexPath.section][1][indexPath.row]];
            return cell;
        }
    }else{//全显示
        InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.section][1][indexPath.row]];
        return cell;
    }
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:NonHoveringHeaderView.class
forHeaderFooterViewReuseIdentifier:NSStringFromClass(NonHoveringHeaderView.class)];
        [_tableView registerClass:HoveringHeaderView.class
forHeaderFooterViewReuseIdentifier:NSStringFromClass(HoveringHeaderView.class)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray <NSArray <NSArray <NSString *>*>*>*)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:@[@[@"我是标题 1"],@[@"我是标题 1.1",@"我是标题 1.2",@"我是标题 1.3",@"我是标题 1.4",@"我是标题 1.5"]]];
        [_dataMutArr addObject:@[@[@"我是标题 2"],@[@"我是标题 2.1",@"我是标题 2.2",@"我是标题 2.3"]]];
        [_dataMutArr addObject:@[@[@"我是标题 3"],@[@""]]];
//        [_dataMutArr addObject:@[@[@"我是标题 4"],@[@"我是标题 4.1"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 5"],@[@"我是标题 5.1",@"我是标题 5.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 6"],@[@"我是标题 6.1",@"我是标题 6.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 7"],@[@"我是标题 7.1",@"我是标题 7.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 8"],@[@"我是标题 8.1",@"我是标题 8.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 9"],@[@"我是标题 9.1",@"我是标题 9.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 10"],@[@"我是标题 10.1",@"我是标题 10.2"]]];
//        [_dataMutArr addObject:@[@[@"我是标题 11"],@[@"我是标题 11.1",@"我是标题 11.2"]]];
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)supplementDataMutArr{
    if (!_supplementDataMutArr) {
        _supplementDataMutArr = NSMutableArray.array;
        [_supplementDataMutArr addObject:@"我是补充数据——01"];
        [_supplementDataMutArr addObject:@"我是补充数据——02"];
        [_supplementDataMutArr addObject:@"我是补充数据——03"];
    }return _supplementDataMutArr;
}

@end
