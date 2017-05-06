//
//  NSArray+Log.m
//  CustomStyleLabel
//
//  Created by fengbaitong on 2017/5/4.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
@end
