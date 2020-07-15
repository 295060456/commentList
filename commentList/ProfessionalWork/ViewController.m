
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

-(void)headerIsTapEvent:(NonHoveringHeaderView *)sender{
    //疑惑 传tag无效
    NSLog(@"%p",sender);
}
#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstClassModel *fcm = self.sources[indexPath.section];
    if(!fcm._hasMore ||
       (fcm.isFullShow && indexPath.row < fcm.secClsModelMutArr.count) ||
       indexPath.row < preMax){
        #pragma warning 点击单元格要做的事
        NSLog(@"KKK");
    }else{
        fcm.isFullShow = !fcm.isFullShow;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                 withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //    [self.tableView reloadData];
    }
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
    
    NonHoveringHeaderView *header = nil;
    
    {//第一种创建方式
        header = [[NonHoveringHeaderView alloc]initWithReuseIdentifier:NSStringFromClass(NonHoveringHeaderView.class)
                                                              withData:@(section)];


    
        [header.result addTarget:self
                          action:@selector(headerIsTapEvent:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
//    {//第二种创建方式
//        //viewForHeaderInSection 悬停与否
//        Class headerClass = NonHoveringHeaderView.class;
//    //    Class headerClass = HoveringHeaderView.class;
//
//        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerClass)];
//    }
    
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
