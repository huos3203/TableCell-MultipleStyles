//
//  MyTask.m
//  cellTemplates
//
//  Created by MgenLiu on 13-12-26.
//  Copyright (c) 2013年 Mgen. All rights reserved.
//

#import "MyTask.h"

@implementation MyTask

- (void)start
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}

- (void)timerHandler:(NSTimer *)timer
{
    _count++;
    float progress = 0.1 * _count;
    if (progress > 0.9)
    {
        self.progress = 1.0;
        [_timer invalidate];
        self.isCompleted = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTASK_PROG_NOTIFICATION object:self userInfo:nil];
    }
    else
    {
        self.progress = progress;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTASK_PROG_NOTIFICATION object:self userInfo:nil];
    }
}

@end
