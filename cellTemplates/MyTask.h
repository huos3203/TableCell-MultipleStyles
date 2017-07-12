//
//  MyTask.h
//  cellTemplates
//
//  Created by MgenLiu on 13-12-26.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kTASK_PROG_NOTIFICATION @"kTASK_PROG_NOTIFICATION"

@interface MyTask : NSObject
{
    int _count;
    NSTimer *_timer;
}

@property (assign) int taskId;
@property (assign) float progress;
@property (assign) BOOL isCompleted;
@property (nonatomic, strong) NSString *title;

- (void)start;

@end
