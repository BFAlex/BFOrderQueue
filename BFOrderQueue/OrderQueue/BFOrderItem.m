//
//  BFOrderItem.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/9/17.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFOrderItem.h"

@implementation BFOrderItem

#pragma mark - API

+ (instancetype)order {
    
    BFOrderItem *order = [[BFOrderItem alloc] init];
    if (order) {
        [order setupDefault];
    }
    
    return order;
}

#pragma mark - Feature

- (void)setupDefault {
    
    self.orderPrority = BFOrderPriorityNormal;
}

@end
