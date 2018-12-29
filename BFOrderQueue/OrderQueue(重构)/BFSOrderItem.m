//
//  BFSOrderItem.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFSOrderItem.h"

@implementation BFSOrderItem

#pragma mark - API

+ (instancetype)order {
    
    BFSOrderItem *order = [[BFSOrderItem alloc] init];
    if (order) {
        [order setupDefault];
    }
    
    return order;
}

#pragma mark - Feature

- (void)setupDefault {
    
    self.orderPrority = BFSOrderPriorityNormal;
}

@end
