//
//  BFsCmdTestVC.m
//  BFOrderQueue
//
//  Created by BFsAlex on 2019/7/1.
//  Copyright © 2019 BFAlex. All rights reserved.
//

#import "BFsCmdTestVC.h"
#import "BFsCmdTestItem.h"

@interface BFsCmdTestVC () {
    int _itemIndex;
    __block BOOL _isCmdWorking;
    
}
@property (nonatomic, strong) dispatch_queue_t cmdQueue;
@property (nonatomic, strong) __block NSMutableArray *cmdArr;
@property (nonatomic, strong) NSLock *cmdArrLock;
@property (nonatomic, strong) NSCondition *cmdOperateLock;

@end

@implementation BFsCmdTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configDefaultSetting];
    [self configSubviews];
}

#pragma mark - Feature
#pragma mark Common

- (void)configDefaultSetting {
    _cmdQueue = dispatch_queue_create("com.bf.cmd.queue", DISPATCH_QUEUE_CONCURRENT);
    _cmdArr = [[NSMutableArray alloc] init];
    _cmdArrLock = [[NSLock alloc] init];
    _cmdOperateLock = [[NSCondition alloc] init];
    
    //
    _itemIndex = 0;
    _isCmdWorking = NO;
}

#pragma mark UI

- (void)configSubviews {
    
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect taskFrame = CGRectMake(10.f, 100.f, 100.f, 100.f);
    taskBtn.frame = taskFrame;
    [taskBtn setTitle:@"Task" forState:UIControlStateNormal];
    [taskBtn addTarget:self action:@selector(actionTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taskBtn];
    
    UIButton *workBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect workFrame = CGRectMake(120.f, 100.f, 100.f, 100.f);
    workBtn.frame = workFrame;
    [workBtn setTitle:@"Work" forState:UIControlStateNormal];
    [workBtn addTarget:self action:@selector(actionWorkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:workBtn];
}

#pragma mark Event

- (void)actionTaskButton:(id)sender {
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    BFsCmdTestItem *cmdItem = [[BFsCmdTestItem alloc] init];
    cmdItem.cmdIndex = _itemIndex;
    int tmpIndex = _itemIndex;
    cmdItem.taskBlock = ^{
        NSLog(@"working task: %d", tmpIndex);
    };
    cmdItem.resultBlock = ^(id value, NSError *error) {
        NSLog(@"cmd value:%@", value);
    };
    [self addCmdItem:cmdItem];
    _itemIndex++;
}

- (void)actionWorkButton:(id)sender {
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (_isCmdWorking) {
        [_cmdOperateLock lock];
        [_cmdOperateLock signal];
        [_cmdOperateLock unlock];
    }
}

#pragma mark - CMD

- (void)addCmdItem:(BFsCmdTestItem *)cmdItem {
    
    [_cmdArrLock lock];
    [_cmdArr addObject:cmdItem];
    NSLog(@"增加了cmd:%d", cmdItem.cmdIndex);
    [_cmdArrLock unlock];
    
    if (_cmdArr.count > 0 && !_isCmdWorking) {
        _isCmdWorking = YES;
//        NSLog(@"add cmd thread: %@", [NSThread currentThread]);
        dispatch_async(_cmdQueue, ^{
//            NSLog(@"work cmd thread: %@", [NSThread currentThread]);
            [self startCmdWork];
        });
    }
}

- (void)startCmdWork {
    
    while (_cmdArr.count > 0) {
        BFsCmdTestItem *cmdItem = _cmdArr[0];
        [_cmdArrLock unlock];
//        [_cmdArr removeObject:cmdItem];
        [_cmdArr removeObjectAtIndex:0];
        [_cmdArrLock unlock];
        
        [self workingCmdItem:cmdItem];
        
        [_cmdOperateLock lock];
        // 带超时机制
        BOOL isInTime = [_cmdOperateLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.f]];
        if (isInTime) {
            NSLog(@"cmd(%d) 没有超时", cmdItem.cmdIndex);
        } else {
            NSLog(@"cmd(%d) 超时了", cmdItem.cmdIndex);
        }
        // 不超时等待
//        [_cmdOperateLock wait];
//        NSLog(@"得到响应(%d)", cmdItem.cmdIndex);
        [_cmdOperateLock unlock];
        
    }
    _isCmdWorking = NO;
}

- (void)workingCmdItem:(BFsCmdTestItem *)cmdItem {
    cmdItem.taskBlock();
}

@end
