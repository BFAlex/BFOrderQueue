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

- (NSObject *)synchronizeExecuteOrder:(BFSOrderItem *)order {

    NSLog(@"重写了同步任务内容");

    return nil;
}

@end
