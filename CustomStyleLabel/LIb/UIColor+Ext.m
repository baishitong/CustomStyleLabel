//
//  UIColor+Ext.m
//  Lafaso
//
//  Created by chaizhiyong on 14-7-8.
//  Copyright (c) 2014年 Lafaso. All rights reserved.
//

#import "UIColor+Ext.h"

#define DEFAULT_VOID_COLOR ([UIColor blackColor])

@implementation UIColor (Ext)

+ (UIColor *)colorWithIntRed:(uint)red green:(uint)green blue:(uint)blue alpha:(uint)alpha
{
    return [self colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 255.0f];
}

+ (UIColor*)colorWithARGB:(NSInteger)argb
{
    CGFloat red = (argb>>16)&0xFF;
    CGFloat green = (argb>>8)&0xFF;
    CGFloat blue = argb&0xFF;
    CGFloat alpha = 255;
    if (argb > 0xFFFFFF)
    {
        alpha = (argb>>24)&0xFF;
    }
    return [UIColor colorWithIntRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithRGB:(uint)rgb;
{
    return [UIColor colorWithARGB:rgb];
}

@end

@implementation UIColor (string)

+ (UIColor*)colorWithHex:(int)hex{
    float red = ((hex >> 24) & 0xFF)/255.0f;
    float green = ((hex >> 16) & 0xFF00)/255.0f;
    float blue = ((hex >> 8) & 0xFF0000)/255.0f;
    float alpha = ((hex >> 0) & 0xFF000000)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) return DEFAULT_VOID_COLOR;
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
	if ([cString length] != 6) return DEFAULT_VOID_COLOR;
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

@end

@implementation UIColor (image)

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color withRadius:(float)Radius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f+Radius*2, 5.0f+Radius*2);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:Radius];
    CGContextAddPath(context, bezierPath.CGPath);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextEOFillPath(context);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size withRadius:(float)Radius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:Radius];
    CGContextAddPath(context, bezierPath.CGPath);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextEOFillPath(context);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end