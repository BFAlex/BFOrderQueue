//
//  BFOrderAssistant.h
//  BFOrderQueue
//
//  Created by 刘玲 on 2018/9/17.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFOrderItem.h"

#define kAsyncTask(queue, block) dispatch_async(queue, block)
#define kSyncTask(queue, block) dispatch_sync(queue, block)

@interface BFOrderAssistant : NSObject

+ (instancetype)assistant;
- (BOOL)addOrder:(BFOrderItem *)order;
- (void)cancelAllOrders;

@end
