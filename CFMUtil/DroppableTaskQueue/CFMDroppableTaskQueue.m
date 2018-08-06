//
//  CFMDroppableTaskQueue.m
//  CFMUtil
//
//  Created by lxm on 2018/8/6.
//  Copyright © 2018年 lxm. All rights reserved.
//

#import "CFMDroppableTaskQueue.h"

@interface CFMDroppableTaskQueue ()

@property (nonatomic,strong) dispatch_queue_t queue;

@property (nonatomic,copy) void (^currentTask)(void);

@property (nonatomic,copy) void (^nextTask)(void);

@end

@implementation CFMDroppableTaskQueue

+ (instancetype)defaultPriorityQueue {
    return [self queueWithGCDQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

+ (instancetype)queueWithGCDQueue:(dispatch_queue_t)queue {
    CFMDroppableTaskQueue *droppableTaskQueue = [[CFMDroppableTaskQueue alloc] init];
    droppableTaskQueue.queue = queue;
    return droppableTaskQueue;
}


- (void)dispatchBlock:(void(^)(void))block {
    @synchronized(self) {
        _nextTask = block;
    }
    [self checkTask];
}

- (void)checkTask {
    if (!_currentTask && _nextTask) {
        @synchronized(self) {
            if (!_currentTask && _nextTask) {
                _currentTask = _nextTask;
                dispatch_async(_queue, ^{
                    self.currentTask();
                    @synchronized(self) {
                        self.currentTask = nil;
                    }
                    [self checkTask];
                });
            }
        }
    }
}


@end
