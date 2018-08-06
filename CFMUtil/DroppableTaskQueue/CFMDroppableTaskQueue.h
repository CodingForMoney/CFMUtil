//
//  CFMDroppableTaskQueue.h
//  CFMUtil
//
//  Created by lxm on 2018/8/6.
//  Copyright © 2018年 lxm. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一个可抛弃中间任务的线程管理器。 使用 GCD .
 
 原因，对于一些复杂的界面响应，我们将耗时任务放到异步线程中，处理完成后，在主线程执行界面修改， 而问题在于这个耗时任务可能多到一段时间内无法完成，所以我们要抛弃一部分过多的任务量，保证响应最关键的事件。
 在这个queue中， 如果一开始加入 A、B两个任务。 当A完成时，如果没有新的任务添加，则执行B，如果在A完成前，加入任务C，则B任务被抛弃。
 */
@interface CFMDroppableTaskQueue : NSObject

/**
 以一个GCDqueue初始化。
 
 @param queue 代理的实际queue
 @return 实例
 */
+ (instancetype)queueWithGCDQueue:(dispatch_queue_t)queue;


/**
 创建一个默认优先级的queue
 
 @return 实例
 */
+ (instancetype)defaultPriorityQueue;


/**
 设置任务。
 
 @param block 添加的任务
 */
- (void)dispatchBlock:(void(^)(void))block;

@end
