//
//  CommentPopUpVC.m
//  MonkeyKingVideo
//
//  Created by Jobs on 2020/7/6.
//  Copyright © 2020 Jobs. All rights reserved.
//

#import "CommentPopUpVC.h"
#import "CommentPopUpVC+VM.h"

#import "LoadMoreTBVCell.h"
#import "InfoTBVCell.h"

#import "NonHoveringHeaderView.h"
#import "HoveringHeaderView.h"
#import "UITableViewHeaderFooterView+Attribute.h"

#import "FirstClassModel.h"
#import "SecondClassModel.h"

@interface CommentPopUpVC ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIBarButtonItem *closeItem;
///所有数据一次性全部请求完
@property(nonatomic,strong)NSMutableArray <FirstClassModel *>*sourcesMutArr;

@end

@implementation CommentPopUpVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    //直接置为nil 不走dealloc 但是内存打印是nil
}

- (instancetype)init{
    if (self = [super init]) {

    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navTitleColor = [UIColor blackColor];
    self.gk_navBackgroundColor = [UIColor clearColor];
    self.gk_navigationBar.backgroundColor = [UIColor clearColor];
    self.gk_navTitle = @"评论页";
    self.gk_statusBarHidden = NO;
    self.gk_navLineHidden = YES;
    self.gk_navRightBarButtonItem = self.closeItem;
    self.tableView.alpha = 1;
}

- (void)viewWillLayoutSubviews {
    //这种做法确实是没有办法，因为没有办法获取到navigationBar里面的_UINavigationBarContentView
    self.gk_navigationBar.frame = CGRectMake(0,
                                             -GK_NAVBAR_HEIGHT,
                                             SCREEN_WIDTH,
                                             58);
    [self.gk_navigationBar layoutSubviews];
}

#pragma mark —— 点击事件
-(void)closeBtnClickEvent:(UIButton *)sender{
    if (super.block) {
        super.block(sender);
    }
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
    LoadMoreTBVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FirstClassModel *model = self.sourcesMutArr[indexPath.section];
    if ([cell isKindOfClass:LoadMoreTBVCell.class]) {
        FirstClassModel *fcm = self.sourcesMutArr[indexPath.section];
        fcm.randShow += LoadDataNum;//randShow 初始值是 preMax
        if (fcm.rand > fcm.randShow) {//还有数据
            model.PreMax += LoadDataNum;
            fcm._hasMore = YES;
        }else{//fcm.rand = preMax + 1 + LoadDataNum 数据没了
            fcm._hasMore = NO;
        }

        if (fcm._hasMore) {
            if ((fcm.isFullShow && indexPath.row < fcm.secClsModelMutArr.count) ||
                indexPath.row < model.PreMax) {
                #pragma warning 点击单元格要做的事
                NSLog(@"KKK");
            }else{
                fcm.isFullShow = !fcm.isFullShow;
            }
        }else{}
    #warning 使用动画刷屏 在下面几个数据刷新的时候会闪屏
    //        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
    //                 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    FirstClassModel *model = self.sourcesMutArr[section];
    if (model.secClsModelMutArr.count > model.PreMax &&
        model._hasMore &&
        !model.isFullShow) {
        return model.PreMax + 1;
    }else{
        return model.secClsModelMutArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstClassModel *firstClassModel = self.sourcesMutArr[indexPath.section];
    SecondClassModel *secondClassModel = firstClassModel.secClsModelMutArr[indexPath.row];
    if (firstClassModel.isFullShow) {//是全显示
        InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
        [cell richElementsInCellWithModel:secondClassModel.secondClassText];
        return cell;
    }else{//不是全显示
        if (indexPath.row == firstClassModel.PreMax &&
            firstClassModel._hasMore) {//
            LoadMoreTBVCell *cell = [LoadMoreTBVCell cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            return cell;
        }else{
            InfoTBVCell *cell = [InfoTBVCell cellWith:tableView];
//            int r = indexPath.row;
//            int d = indexPath.section;
            [cell richElementsInCellWithModel:secondClassModel.secondClassText];
            return cell;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sourcesMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [LoadMoreTBVCell cellHeightWithModel:nil];
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section{
    
    NonHoveringHeaderView *header = nil;
    FirstClassModel *model = self.sourcesMutArr[section];
    
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
    header.textLabel.text = model.firstClassText;

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
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = NO;
        CGFloat D = isiPhoneX_series()?80:49;
        [self.view addSubview:_tableView];
        _tableView.frame = CGRectMake(0,
                                      GK_NAVBAR_HEIGHT,
                                      SCREEN_WIDTH,
                                      self.liftingHeight - GK_NAVBAR_HEIGHT - D);
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.top.equalTo(self.gk_navigationBar.mas_bottom);
//        }];
    }return _tableView;
}

- (NSMutableArray <FirstClassModel *>*)sourcesMutArr{
    if(!_sourcesMutArr){
        _sourcesMutArr = NSMutableArray.array;
        for(NSInteger idx = 1; idx <= 50; idx ++){
            NSString *str = [NSString stringWithFormat:@"%ld", idx];
            FirstClassModel *hm = [FirstClassModel create:str];
            [_sourcesMutArr addObject:hm];
        }
    }return _sourcesMutArr;
}

-(UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        UIButton *btn = UIButton.new;
        btn.frame = CGRectMake(0,
                               0,
                               44,
                               44);
        [btn setImage:kIMG(@"close")
             forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(closeBtnClickEvent:)
      forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }return _closeItem;
}

@end
