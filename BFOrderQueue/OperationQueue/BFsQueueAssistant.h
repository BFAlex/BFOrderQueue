//
//  BFsQueueAssistant.h
//  BFsRuntime
//
//  Created by BFsAlex on 2019/12/9.
//  Copyright © 2019 BFsAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFsQueueAssistant : NSObject

+ (instancetype)sharedInstance;
- (void)addSerialTask:(void(^)(void))taskBlock;

@end

NS_ASSUME_NONNULL_END
