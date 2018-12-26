//
//  BFNetworkOrderAssistant.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/11/22.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFNetworkOrderAssistant.h"

#define kMaxConcurrentOperationCount 1  // 任务最大并发数

@interface BFNetworkOrderAssistant () {
    
    int     _curOperationCount; // 同步队列专用参数
}

// GCD
@property (nonatomic, strong) dispatch_queue_t networkQueue;
// NSArray
@property (nonatomic, strong) NSLock *lockOfNetwork;
@property (nonatomic, assign) BOOL isExecutingNetworkOrder;
@property (nonatomic, strong) NSMutableArray *ordersOfNetwork;
// NSOperationQueue
//@property (nonatomic, strong) NSOperationQueue *networkOperationQueue;

@end

@implementation BFNetworkOrderAssistant

#pragma mark - Prpperty

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

#pragma mark - API

+ (instancetype)assistant {
    
    static BFNetworkOrderAssistant *assistant;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assistant = [[BFNetworkOrderAssistant alloc] init];
        [assistant configInstance];
    });
    
    return assistant;
}

- (BOOL)addOrder:(BFOrderItem *)order {
    
    kAsyncTask(self.networkQueue, ^{
        [self addNetworkOrder:order];
    });
    
    return true;
}

- (void)cancelAllOrders {
    
    if (self.ordersOfNetwork.count > 0) {
        [self.ordersOfNetwork removeAllObjects];
    }
}

#pragma mark - Feature

- (void)configInstance {
    
    // GCD
    NSString *queueName = @"bibi";
    self.networkQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    self.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
    _curOperationCount = 0;
    
    // NSOperationQueue
//    self.networkOperationQueue = [[NSOperationQueue alloc] init];
//    self.networkOperationQueue.maxConcurrentOperationCount = 1;
}

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

/**
 并发队列顺序执行order
 */
- (void)addNetworkOrder:(BFOrderItem *)order {
    NSLog(@"添加任务线程： %@", [NSThread currentThread]);
    [self.lockOfNetwork lock];
    [self.ordersOfNetwork addObject:order];
    
    if (self.isExecutingNetworkOrder && (_curOperationCount >= self.maxConcurrentOperationCount)) {
        [self.lockOfNetwork unlock];
        return;
    }
    
    _curOperationCount++;
    while (self.ordersOfNetwork.count > 0) {
        
        self.isExecutingNetworkOrder = YES;
        [self.lockOfNetwork unlock];
        
        BFOrderItem *executeOrder = [self searchOrderForHighterProperty:self.ordersOfNetwork];
        
        /**
         增加具体的网络指令内容
         */
        executeOrder.taskBlock();
        // Sample
        NSLog(@"执行指令线程：%@", [NSThread currentThread]);
        NSLog(@"在这里执行了网络指令【order index:%lu, priority:%d】\n", (unsigned long)executeOrder.testIndex, executeOrder.orderPrority);
        [NSThread sleepForTimeInterval:1.f];
        
    
        [self.lockOfNetwork lock];
        [self.ordersOfNetwork removeObject:executeOrder];
    }
    self.isExecutingNetworkOrder = NO;
    _curOperationCount--;
    [self.lockOfNetwork unlock];
}

@end
