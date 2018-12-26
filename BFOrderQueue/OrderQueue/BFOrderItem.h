//
//  BFOrderItem.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/9/17.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

// 指令渠道
typedef enum {
    BFOrderTypeUnknow = 0,
    BFOrderTypeNetwork,
    BFOrderTypeBluetooth,
} BFOrderType;
// 指令优先级
typedef enum {
    BFOrderPriorityLow = 0,
    BFOrderPriorityNormal,
    BFOrderPriorityMiddle,
    BFOrderPriorityHightest,
} BFOrderPriority;

typedef void (^ItemTaskBlock)(void);

@interface BFOrderItem : NSObject

@property (nonatomic, assign) BFOrderType orderType;
@property (nonatomic, assign) BFOrderPriority orderPrority;
@property (nonatomic, assign) ItemTaskBlock taskBlock;

@property (nonatomic, assign) NSUInteger testIndex;

#pragma mark - Methods

+ (instancetype)order;

@end
