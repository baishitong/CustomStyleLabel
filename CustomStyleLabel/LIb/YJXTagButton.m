//
//  YJXTagButton.m
//  YiJianXingNew
//
//  Created by pczhu on 2017/4/12.
//  Copyright © 2017年 sean. All rights reserved.
//

#import "YJXTagButton.h"
#import "UIView+Ext.h"
@interface YJXTagButton()
///  title的左右间隙

@property (nonatomic, assign)CGFloat spaceMargin;

@end

@implementation YJXTagButton



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        ////   默认值是 13
//        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];

    [self sizeToFit];
    
    //  根据字符串计算宽度
    CGFloat w = [self getLableWidth:self.titleLabel];
    
    if (w<self.frame.size.width) {
        [self setWidth:w];
    }
    _spaceMargin = self.frame.size.height * 0.5;
    self.width += 2 * _spaceMargin;
}

- (CGFloat)getLableWidth:(UILabel *)lable{
    
    CGSize maxSize = CGSizeMake(MAXFLOAT,[UIScreen mainScreen].bounds.size.height);
    NSDictionary *attrs = @{NSFontAttributeName : lable.font};
    
    CGSize size = [lable.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attrs
                                           context:nil].size;
    
    return size.width;
}
- (CGFloat)getLableHeight:(UILabel *)lable width:(CGFloat)width{
    CGSize maxSize = CGSizeMake(width,MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName : lable.font};
    
    CGSize size = [lable.text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attrs
                                           context:nil].size;
    
    return size.height;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.originX = _spaceMargin;
    [self.titleLabel setWidth:self.width-_spaceMargin*2];

}

@end
