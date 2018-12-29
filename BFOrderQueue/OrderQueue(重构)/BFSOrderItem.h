//
//  BFSOrderItem.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

// 指令渠道
typedef enum {
    BFSOrderTypeUnknow = 0,
    BFSOrderTypeNetwork,
    BFSOrderTypeBluetooth,
} BFSOrderType;
// 指令优先级
typedef enum {
    BFSOrderPriorityLow = 0,
    BFSOrderPriorityNormal,
    BFSOrderPriorityMiddle,
    BFSOrderPriorityHightest,
} BFSOrderPriority;

typedef void (^ItemTaskBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BFSOrderItem : NSObject

@property (nonatomic, assign) BFSOrderType orderType;
@property (nonatomic, assign) BFSOrderPriority orderPrority;
@property (nonatomic, assign) ItemTaskBlock taskBlock;

@property (nonatomic, assign) NSUInteger testIndex;

#pragma mark - Methods

+ (instancetype)order;

@end

NS_ASSUME_NONNULL_END
