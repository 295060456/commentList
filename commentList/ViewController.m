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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.tableView.alpha = 1;
}

#pragma mark —————————— UITableViewDelegate,UITableViewDataSource ——————————
//- (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [MyFansTBVCell cellHeightWithModel:nil];
//}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    @weakify(self)
//    [PersonalCenterVC ComingFromVC:weak_self
//                       comingStyle:ComingStyle_PUSH
//                 presentationStyle:UIModalPresentationAutomatic
//                     requestParams:nil
//                           success:^(id data) {}
//                          animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TBVCell *cell = [TBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:nil];
    return cell;
}

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



@end
