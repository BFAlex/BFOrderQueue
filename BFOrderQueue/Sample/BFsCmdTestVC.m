//
//  BFsCmdTestVC.m
//  BFOrderQueue
//
//  Created by BFsAlex on 2019/7/1.
//  Copyright © 2019 BFAlex. All rights reserved.
//

#import "BFsCmdTestVC.h"
#import "BFsCmdItem.h"

@interface BFsCmdTestVC () {
    int _itemIndex;
    __block BOOL _isCmdWorking;
    
}
@property (nonatomic, strong) dispatch_queue_t cmdQueue;
@property (nonatomic, strong) NSMutableArray *cmdArr;
@property (nonatomic, strong) NSLock *cmdArrLock;
@property (nonatomic, strong) NSConditionLock *cmdOperateLock;

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
    _cmdOperateLock = [[NSConditionLock alloc] init];
    
    //
    _itemIndex = 0;
    _isCmdWorking = NO;
}

#pragma mark UI

- (void)configSubviews {
    
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
    BFsCmdItem *cmdItem = [[BFsCmdItem alloc] init];
    cmdItem.cmdIndex = _itemIndex;
    cmdItem.taskBlock = ^{
        NSLog(@"task: %d", self->_itemIndex);
    };
    cmdItem.resultBlock = ^(id value, NSError *error) {
        NSLog(@"cmd value:%@", value);
    };
    [self addCmdItem:cmdItem];
    _itemIndex++;
}

- (void)actionWorkButton:(id)sender {
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark - CMD

- (void)addCmdItem:(BFsCmdItem *)cmdItem {
    
    [_cmdArrLock lock];
    [_cmdArr addObject:cmdItem];
    [_cmdArrLock unlock];
    
    if (_cmdArr.count > 0 && !_isCmdWorking) {
        _isCmdWorking = YES;
        dispatch_async(_cmdQueue, ^{
            [self startCmdWork];
        });
    }
}

- (void)startCmdWork {
    
    while (_cmdArr.count > 0) {
        BFsCmdItem *cmdItem = _cmdArr[0];
        [_cmdArrLock unlock];
        [_cmdArr removeObject:cmdItem];
        [_cmdArrLock unlock];
        
        cmdItem.taskBlock();
//        [_cmdOperateLock lock];
        
    }
    _isCmdWorking = NO;
}

@end
