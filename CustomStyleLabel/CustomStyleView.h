//
//  CustomStyleView.h
//  CustomStyleLabel
//
//  Created by fengbaitong on 2017/5/5.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Ext.h"
#import "UIColor+Ext.h"
#import "YJXTagButton.h"
#import "HotTagsModel.h"
#import "NSArray+Log.h"

@protocol FBTCustomStyleViewDelegate <NSObject>
@optional
- (void)clickEnsureButtonBackArray:(NSArray *)array;
- (void)clickCancelButtonBackArray:(NSArray *)array;
@end


@interface CustomStyleView : UIView
//下方标签相关数组


@property (nonatomic, strong) UIView *filterContentView;
@property (nonatomic, weak) id<FBTCustomStyleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array;

/**
 显示的效果。动画效果请不要随便更改，除非要更改动画效果。
 */
- (void)showView;

@end
