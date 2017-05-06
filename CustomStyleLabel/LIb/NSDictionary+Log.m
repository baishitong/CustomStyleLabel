//
//  NSDictionary+Log.m
//  CustomStyleLabel
//
//  Created by fengbaitong on 2017/5/4.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
    id value= self[key];
    [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    return str;
}
@end
