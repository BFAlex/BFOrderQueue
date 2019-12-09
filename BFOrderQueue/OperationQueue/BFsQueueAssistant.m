//
//  BFsQueueAssistant.m
//  BFsRuntime
//
//  Created by BFsAlex on 2019/12/9.
//  Copyright © 2019 BFsAlex. All rights reserved.
//

#import "BFsQueueAssistant.h"


@interface BFsQueueAssistant () {
    NSOperationQueue *_taskQueue;
}

@end

@implementation BFsQueueAssistant

+ (instancetype)sharedInstance {
    
    static BFsQueueAssistant *queueAssistant;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueAssistant = [[BFsQueueAssistant alloc] init];
        [queueAssistant configSetting];
    });
    
    return queueAssistant;
}

- (void)addSerialTask:(void (^)(void))taskBlock {
    
    if (taskBlock) {
        [_taskQueue addOperationWithBlock:taskBlock];
    }
}

#pragma mark - Private

- (void)configSetting {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    //
    _taskQueue = queue;
}

- (NSTimeInterval)getCurrentTimestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.f];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    
    return timeStamp;
}

@end
