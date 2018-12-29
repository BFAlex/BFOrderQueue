//
//  BFSOrderAssistant.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFSOrderAssistant.h"

#define kAsyncTask(queue, block) dispatch_async(queue, block)
#define kSyncTask(queue, block) dispatch_sync(queue, block)

#define kMaxConcurrentOperationCount 1  // 任务最大并发数

@interface BFSOrderAssistant () {
    
    int     _curOperationCount; // 同步队列专用参数
}

// GCD
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
// NSArray
@property (nonatomic, strong) NSLock *lockOfNetwork;
@property (nonatomic, assign) BOOL isExecutingNetworkOrder;
@property (nonatomic, strong) NSMutableArray *ordersOfConcurrent;   //

@end

@implementation BFSOrderAssistant

#pragma mark - Prpperty

- (NSLock *)lockOfNetwork {
    
    if (!_lockOfNetwork) {
        _lockOfNetwork = [[NSLock alloc] init];
    }
    
    return _lockOfNetwork;
}

- (NSMutableArray *)ordersOfConcurrent {
    
    if (!_ordersOfConcurrent) {
        _ordersOfConcurrent = [NSMutableArray array];
    }
    
    return _ordersOfConcurrent;
}

#pragma mark - API

+ (instancetype)assistant {
    
    static BFSOrderAssistant *assistant;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assistant = [[BFSOrderAssistant alloc] init];
    });
    
    return assistant;
}

- (BOOL)addOrder:(BFSOrderItem *)order {
    
    kAsyncTask(self.concurrentQueue, ^{
        [self addNetworkOrder:order];
    });
    
    return true;
}

- (void)cancelAllOrders {
    
    if (self.ordersOfConcurrent.count > 0) {
        [self.ordersOfConcurrent removeAllObjects];
    }
}

#pragma mark - Feature

- (instancetype)init {
    
    if (self = [super init]) {
        [self configInstance];
    }
    
    return self;
}

- (void)configInstance {
    
    // GCD
    NSString *queueName = @"bibi";
    self.concurrentQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    self.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
    _curOperationCount = 0;
}

- (BFSOrderItem *)searchOrderForHighterProperty:(NSArray *)orders {
    
    BFSOrderItem *targetOrder = [orders firstObject];
    for (int i = 1; i < orders.count; i++) {
        BFSOrderItem *tmpOrder = orders[i];
        if (targetOrder.orderPrority < tmpOrder.orderPrority) {
            targetOrder = tmpOrder;
        }
    }
    
    return targetOrder;
}

/**
 并发队列顺序执行order
 */
- (void)addNetworkOrder:(BFSOrderItem *)order {
    NSLog(@"添加任务线程： %@", [NSThread currentThread]);
    [self.lockOfNetwork lock];
    [self.ordersOfConcurrent addObject:order];
    
    if (self.isExecutingNetworkOrder && (_curOperationCount >= self.maxConcurrentOperationCount)) {
        [self.lockOfNetwork unlock];
        return;
    }
    
    _curOperationCount++;
    while (self.ordersOfConcurrent.count > 0) {
        
        self.isExecutingNetworkOrder = YES;
        [self.lockOfNetwork unlock];
        
        BFSOrderItem *executeOrder = [self searchOrderForHighterProperty:self.ordersOfConcurrent];
        
        id result = [self synchronizeExecuteOrder:executeOrder];
        [self handOrderResult:result order:executeOrder];
        
        
        [self.lockOfNetwork lock];
        [self.ordersOfConcurrent removeObject:executeOrder];
    }
    self.isExecutingNetworkOrder = NO;
    _curOperationCount--;
    [self.lockOfNetwork unlock];
}

#pragma mark - 任务处理方法
/**
 子类重写具体指令操作方法
 */

- (id)synchronizeExecuteOrder:(BFSOrderItem *)order {
    
    /**
     增加具体的网络指令内容
     */
    [NSThread sleepForTimeInterval:1.f];
    order.taskBlock();
    // Sample
    NSLog(@"执行指令线程：%@", [NSThread currentThread]);
    NSLog(@"在这里执行了网络指令【order index:%lu, priority:%d】", (unsigned long)order.testIndex, order.orderPrority);
    
    return nil;
}

- (void)handOrderResult:(id)result order:(BFSOrderItem *)order{
    NSLog(@"order操作结果再加工%@...", [NSThread currentThread]);
}

@end
