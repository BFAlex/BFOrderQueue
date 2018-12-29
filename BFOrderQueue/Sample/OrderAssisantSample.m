//
//  OrderAssisantSample.m
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/12/29.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "OrderAssisantSample.h"

@implementation OrderAssisantSample

+ (instancetype)assistant {
    
    static OrderAssisantSample *assistant;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assistant = [[OrderAssisantSample alloc] init];
    });
    
    return assistant;
}

- (instancetype)init {
    
    if (self = [super init]) {
        //
    }
    
    return self;
}

- (id)synchronizeExecuteOrder:(BFSOrderItem *)order {

    [NSThread sleepForTimeInterval:1.f];
    NSLog(@"重写了同步任务内容");

    return nil;
}

- (void)handOrderResult:(id)result {
    NSLog(@"在子类中，order操作结果再加工...\n");
}

@end
