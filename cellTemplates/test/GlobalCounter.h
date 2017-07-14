//
//  GlobalCounter.h
//  tableViewCellHeight
//
//  Created by Mgen on 12/14/14.
//  Copyright (c) 2014 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalCounter : NSObject
{
    NSMutableDictionary *_counters;
}

+ (instancetype)getInstance;
- (void)add:(NSString*)name;
- (int)get:(NSString*)name;
- (NSDictionary*)dictionary;

@end
