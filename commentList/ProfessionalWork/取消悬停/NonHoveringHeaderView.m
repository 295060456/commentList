//
//  NonHoveringHeaderView.m
//  HeaderDemo
//
//  Created by zyd on 2018/6/22.
//  Copyright © 2018年 zyd. All rights reserved.
//

#import "NonHoveringHeaderView.h"
#import "UITableViewHeaderFooterView+Attribute.h"

@implementation NonHoveringHeaderView

- (void)setFrame:(CGRect)frame {
    [super setFrame:[self.tableView rectForHeaderInSection:self.section]];
}

@end
