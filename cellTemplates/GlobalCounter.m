//
//  GlobalCounter.m
//  tableViewCellHeight
//
//  Created by Mgen on 12/14/14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import "GlobalCounter.h"

@implementation GlobalCounter

+ (instancetype)getInstance
{
    static GlobalCounter *gcounter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcounter = [GlobalCounter new];
    });
    return gcounter;
}

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _counters = [NSMutableDictionary dictionary];
    return self;
}

- (void)add:(NSString*)name
{
    NSNumber *count = [_counters objectForKey:name];
    if(!count)
        count = @(0);
    [_counters setObject:@([count intValue] + 1) forKey:name];
}

- (int)get:(NSString*)name
{
    return [[_counters objectForKey:name] intValue];
}

- (NSDictionary*)dictionary
{
    return _counters;
}

@end
