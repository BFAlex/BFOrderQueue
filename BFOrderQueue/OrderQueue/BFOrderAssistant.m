//
//  BFOrderAssistant.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/9/17.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFOrderAssistant.h"

@interface BFOrderAssistant()
//@property (nonatomic, strong) dispatch_queue_t internetQueue;
//@property (nonatomic, strong) dispatch_queue_t bluetoothQueue;

#pragma mark 非GCD版
// network
@property (nonatomic, strong) NSLock *lockOfNetwork;
@property (nonatomic, assign) BOOL isExecutingNetworkOrder;
@property (nonatomic, strong) NSMutableArray *ordersOfNetwork;
// bluetooth
@property (nonatomic, strong) NSLock *lockOfBluetooth;
@property (nonatomic, assign) BOOL isExecutingBluetoothOrder;
@property (nonatomic, strong) NSMutableArray *ordersOfBluetooth;
           
@end

@implementation BFOrderAssistant

#pragma mark - Prpperty
#pragma mark Network
- (NSLock *)lockOfNetwork {
    
    if (!_lockOfNetwork) {
        _lockOfNetwork = [[NSLock alloc] init];
    }
    
    
    
    return _lockOfNetwork;
}

- (NSMutableArray *)ordersOfNetwork {
    
    if (!_ordersOfNetwork) {
        _ordersOfNetwork = [NSMutableArray array];
    }
    
    return _ordersOfNetwork;
}

#pragma mark Bluetooth

- (NSLock *)lockOfBluetooth {
    
    if (!_lockOfBluetooth) {
        _lockOfBluetooth = [[NSLock alloc] init];
    }
    
    return _lockOfBluetooth;
}

- (NSMutableArray *)ordersOfBluetooth {
    
    if (!_ordersOfBluetooth) {
        _ordersOfBluetooth = [NSMutableArray array];
    }
    
    return _ordersOfBluetooth;
}

#pragma mark - API

//+ (instancetype)defaultOrderAssistant {
//
//    static BFOrderAssistant *defaultOA;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultOA = [[BFOrderAssistant alloc] init];
//    });
//
//    return defaultOA;
//}

+ (instancetype)assistant {
    
    BFOrderAssistant *assistant;
    assistant = [[BFOrderAssistant alloc] init];
    
    return assistant;
}

- (BOOL)addOrder:(BFOrderItem *)order {
    
    BOOL result = false;
    switch (order.orderType) {
            
        case BFOrderTypeNetwork:
        {
//            [self addNetworkOrder:order];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addNetworkOrder:order];
            });
            result = true;
        }
            break;
            
        case BFOrderTypeBluetooth:
        {
            [self addBluetoothOrder:order];
            result = true;
        }
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark - Feature
// ************ Network ************
- (BFOrderItem *)searchOrderForHighterProperty:(NSArray *)orders {
    
    BFOrderItem *targetOrder = [orders firstObject];
    for (int i = 1; i < orders.count; i++) {
        BFOrderItem *tmpOrder = orders[i];
        if (targetOrder.orderPrority < tmpOrder.orderPrority) {
            targetOrder = tmpOrder;
        }
    }
    
    return targetOrder;
}

- (void)addNetworkOrder:(BFOrderItem *)order {
    
    [self.lockOfNetwork lock];
    [self.ordersOfNetwork addObject:order];
    [self.lockOfNetwork unlock];
    
    if (self.isExecutingNetworkOrder) {
        return;
    }
    
    while (self.ordersOfNetwork.count > 0) {
        
        self.isExecutingNetworkOrder = YES;
        BFOrderItem *executeOrder = [self searchOrderForHighterProperty:self.ordersOfNetwork];
        
        // 执行有关网络指令操作
#warning 假装指令执行完成了
        NSLog(@"执行指令线程：%@", [NSThread currentThread]);
        NSLog(@"在这里执行了网络指令【order index:%lu, priority:%d】", (unsigned long)executeOrder.testIndex, executeOrder.orderPrority);
        [NSThread sleepForTimeInterval:1.f];
        
//        dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
        kAsyncTask(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"测试宏定义异步线程：%@", [NSThread currentThread]);
        });
        
        [self.lockOfNetwork lock];
        [self.ordersOfNetwork removeObject:executeOrder];
        [self.lockOfNetwork unlock];
    }
    self.isExecutingNetworkOrder = NO;
}

// ************ Bluetooth ************
- (void)addBluetoothOrder:(BFOrderItem *)order {
    
}

@end
