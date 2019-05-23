//
//  BFSOrderItem.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFsCmdItem.h"

@implementation BFsCmdItem

#pragma mark - API

+ (instancetype)cmdItem {
    
    BFsCmdItem *order = [[BFsCmdItem alloc] init];
    if (order) {
        [order setupDefault];
    }
    
    return order;
}

#pragma mark - Feature

- (void)setupDefault {
    
    self.orderPrority = BFsCmdPriorityNormal;
}

@end
