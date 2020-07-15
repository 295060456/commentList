
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

#import "FirstClassModel.h"
#import "SecondClassModel.h"

#define LoadDataNum 1//加载更多数据 一次加载的个数

@interface ViewController ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <FirstClassModel *>*sources;

//@property(nonatomic,assign)long loadDataNum;//每次加载数据的

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.alpha = 1;
    NSLog(@"");
}
#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    self.loadDataNum = LoadDataNum;//在这里进行赋值
    
//    if (LoadMoreTBVCell.class == [tableView cellForRowAtIndexPath:indexPath].class) {
//        //定位到具体的“加载更多”的锚点
//        NSArray *arr_0 = self.dataMutArr[indexPath.section][0];
//        NSArray *arr_1 = self.dataMutArr[indexPath.section][1];
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:arr_1];
//        NSLog(@"");
//
//        if (self.loadDataNum != self.supplementDataMutArr.count) {//每次加载loadDataNum
//            for (int i = 0; i < self.loadDataNum; i++) {
//                NSString *str = self.supplementDataMutArr[i];
//                [temp addObject:str];
//            }
//        }else{//全加载
//            for (NSString *str in self.supplementDataMutArr) {
//                [temp addObject:str];
//            }
//        }
//        //整理数据源
//        [self.dataMutArr removeObjectAtIndex:indexPath.section];
//        [self.dataMutArr insertObject:@[arr_0,temp]
//                              atIndex:indexPath.section];
//        NSLog(@"");
//        self.isFullShow = YES;
//        //两种刷新方法
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
//                      withRowAnimation:UITableViewRowAnimationAutomatic];
//        //    [self.tableView reloadData];
//    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (self.sources[section].secClsModelMutArr.count > preMax &&
        !self.sources[section].isFullShow) {
        return preMax + 1;
    }else{
        return self.sources[section].secClsModelMutArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.sources[indexPath.section].isFullShow) {//不是全显示
        if (indexPath.row == preMax) {
            LoadMoreTBVCell *cell = [LoadMoreTBVCell cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            return cell;
        }else{
            InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
//            int r = indexPath.row;
//            int d = indexPath.section;
            [cell richElementsInCellWithModel:self.sources[indexPath.section].secClsModelMutArr[indexPath.row].secondClassText];
            return cell;
        }
    }else{//全显示
        InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
        [cell richElementsInCellWithModel:self.sources[indexPath.section].secClsModelMutArr[indexPath.row].secondClassText];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sources.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    //viewForHeaderInSection 悬停与否
    Class headerClass = NonHoveringHeaderView.class;
//    Class headerClass = HoveringHeaderView.class;
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerClass)];
    header.tableView = tableView;
    header.section = section;
    header.textLabel.text = self.sources[section].firstClassText;
    return header;
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

- (NSMutableArray <FirstClassModel *>*)sources{
    if(!_sources){
        _sources = [NSMutableArray array];
        for(NSInteger idx = 1; idx <= 50; idx ++){
            NSString *str = [NSString stringWithFormat:@"第%ld条评论", idx];
            FirstClassModel *hm = [FirstClassModel create:str];
            [_sources addObject:hm];
        }
    }return _sources;
}


@end
