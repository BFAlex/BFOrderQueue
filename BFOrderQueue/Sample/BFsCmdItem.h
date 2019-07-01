//
//  BFsCmdItem.h
//  BFOrderQueue
//
//  Created by BFsAlex on 2019/7/2.
//  Copyright © 2019 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TaskBlock)(void);
typedef void(^ResultBlock)(id _Nullable value, NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface BFsCmdItem : NSObject
@property (nonatomic, assign) int cmdIndex;
@property (nonatomic, copy) TaskBlock   taskBlock;
@property (nonatomic, copy) ResultBlock resultBlock;

@end

NS_ASSUME_NONNULL_END
