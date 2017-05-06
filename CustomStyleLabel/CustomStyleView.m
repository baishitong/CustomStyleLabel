//
//  CustomStyleView.m
//  CustomStyleLabel
//
//  Created by fengbaitong on 2017/5/5.
//  Copyright © 2017年 fbt. All rights reserved.
//

#import "CustomStyleView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface CustomStyleView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton * filterButton;//下方的筛选按钮
@property (nonatomic, strong) UIScrollView *tagBgView;
@property (nonatomic, strong) NSMutableArray *hotTagButtons;
@property (nonatomic, strong) NSMutableArray *selectHotTagsArray;
@property (nonatomic, strong) UITapGestureRecognizer *oneTap;
@property (nonatomic, strong) NSMutableArray *hotTags;
@end

@implementation CustomStyleView

/**
 下方的标签数组(可有由网络请求进行返回也可以写成死数据)
 */
//- (NSMutableArray *)hotTags {
//    if (!_hotTags) {
//        _hotTags = [NSMutableArray array];
////        _hotTags = [NSMutableArray arrayWithArray:@[@"高血压",@"糖尿病",@"风湿",@"类风湿性关节炎",@"颈椎病",@"感冒",@"发热",@"甲状腺",@"我是测试标签疾病",@"牛皮靴",@"头痛",@"胃功能障碍",@"骨折",@"肩周炎",@"肌肉酸痛",@"视力模糊",@"青光眼",@"白内障",@"耳鸣",@"呼吸道感染",@"消化不良",@"腹泻",@"头晕眼花"]];
//    }
//    return _hotTags;
//}
/**
 选中的标签数组
 */
- (NSMutableArray *)selectHotTagsArray{
    
    if (!_selectHotTagsArray) {
        _selectHotTagsArray = [NSMutableArray array];
    }
    return _selectHotTagsArray;
}
/**
 根据标签数组创建的button个数
 */
- (NSMutableArray *)hotTagButtons {
    if (!_hotTagButtons) {
        _hotTagButtons = [NSMutableArray array];
    }
    return _hotTagButtons;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.hotTags = array;
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        //        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self addSubview:self.filterContentView];
        //手势 隐藏视图和动画
        _oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneClick:)];
        _oneTap.numberOfTapsRequired     = 1;
        _oneTap.numberOfTouchesRequired  = 1;
        _oneTap.delegate = self;
        [self addGestureRecognizer:_oneTap];
        
    }
    return self;

}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
//        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self addSubview:self.filterContentView];
        //手势 隐藏视图和动画
        _oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneClick:)];
        _oneTap.numberOfTapsRequired     = 1;
        _oneTap.numberOfTouchesRequired  = 1;
        _oneTap.delegate = self;
        [self addGestureRecognizer:_oneTap];
    }
    return self;
}

#pragma mark - 手势处理
// 单击事件
- (void)oneClick:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContentView.originY = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.originY = SCREEN_HEIGHT;
    }];
}
//白色标签父视图
- (UIView *)filterContentView {
    if (!_filterContentView) {
        _filterContentView = [[UIView alloc] init];
        _filterContentView.backgroundColor = [UIColor whiteColor];
        _filterContentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 15, 100, 20)];
        titleLabel.text = @"标签";
        titleLabel.textColor = [UIColor colorWithHexString:@"989898"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [_filterContentView addSubview:titleLabel];
        
        //装标签的scrollview视图
        UIScrollView *tagBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, titleLabel.bottom + 10, _filterContentView.width - 30, _filterContentView.height - 45 - 50)];
        [_filterContentView addSubview:tagBgView];
        self.tagBgView = tagBgView;
        
        //清除按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake((SCREEN_WIDTH - 210) / 2, _filterContentView.height - 40, 80, 25);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"tag_bg_normal"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"tag_bg_normal"] forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"清除" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"989898"] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_filterContentView addSubview:cancelButton];
        
        //确定按钮
        UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ensureButton.frame = CGRectMake(CGRectGetMaxX(cancelButton.frame) + 50, _filterContentView.height - 40, 80, 25);
        [ensureButton setBackgroundImage:[UIImage imageNamed:@"tag_linebg_normal"] forState:UIControlStateNormal];
        [ensureButton setBackgroundImage:[UIImage imageNamed:@"tag_linebg_normal"] forState:UIControlStateHighlighted];
        [ensureButton setTitle:@"确认" forState:UIControlStateNormal];
        [ensureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        ensureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [ensureButton addTarget:self action:@selector(ensureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_filterContentView addSubview:ensureButton];
        
        
        
        //创建完大体布局。仅差tag
        [self setupHotTagView];
    }
    return _filterContentView;
}
#pragma mark - 标签相关
//热门标签view
- (void)setupHotTagView {
    
    //    for (HotTagsModel *model in self.hotTags) {
    //
    //        NSString *tagName = [NSString stringWithFormat:@"%@ (%@) (%@)人",model.name,model.shortName,model.num];
    //
    //        [self addTag:tagName buttons:self.hotTagButtons];
    //    }
    //    hotTags数组中可以放你写的模型，可以是字符串
        NSLog(@"%@",self.hotTags);
    for (NSString *str in self.hotTags) {
        
        NSString *tagName = str;
        //遍历循环创建tagButton。 用字符串来创建
        [self addTag:tagName buttons:self.hotTagButtons];
    }
    
    //创建完毕后。我们回到主线程去更新ui布局
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新所有按钮的frame
        [self updateButtonFrameWithButtons:self.hotTagButtons];
    });
}

- (void)addTag:(NSString *)tagName buttons:(NSArray *)buttons{
    
    // 添加一个"按钮"
    YJXTagButton *button = [YJXTagButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"tag_bg_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tag_bg_normal"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"tag_bg_selected"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    //弹出视图中的scrollview 添加button
    [self.tagBgView addSubview:button];
    [self.hotTagButtons addObject:button];
    [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:tagName forState:UIControlStateNormal];
    
}

/**
 * 专门用来更新标签按钮的frame  按钮换行。
 */
- (void)updateButtonFrameWithButtons:(NSArray *)buttons {
    // 更新标签按钮的frame
    CGFloat y = 5.0;
    if (buttons.count > 0) {
        for (int i = 0; i < buttons.count; i++) {
            YJXTagButton *tagbutton = buttons[i];
            
            if (i == 0) { // 最前面的标签按钮
                tagbutton.originX = 0;
                tagbutton.originY = y;
            } else { // 其他标签按钮
                YJXTagButton *lastButton = buttons[i - 1];
                // 计算当前行左边的宽度
                CGFloat leftWidth = CGRectGetMaxX(lastButton.frame) + 10;
                // 计算当前行右边的宽度
                CGFloat rightWidth = self.tagBgView.width - leftWidth;
                
                if (rightWidth >= tagbutton.width) { // 按钮显示在当前行
                    tagbutton.originY = lastButton.originY;
                    tagbutton.originX = leftWidth;
                } else { // 按钮显示在下一行
                    tagbutton.originX = 0;
                    tagbutton.originY = CGRectGetMaxY(lastButton.frame) + 10;
                }
            }
            y = tagbutton.originY;
            if (i == buttons.count - 1) {
                y += tagbutton.height;
            }
        }
        self.tagBgView.contentSize = CGSizeMake(0, y + 5);
    }
}

//点击tag热门标签
- (void)tagButtonClick:(YJXTagButton *)tagButton {
    tagButton.selected = !tagButton.selected;
    //必有
    NSLog(@"选择的标签个数--%ld",self.selectHotTagsArray.count);
    if (tagButton.selected) {
        NSInteger index = [self.hotTagButtons indexOfObject:tagButton];
        NSString *str = self.hotTags[index];
        NSLog(@"%@",str);
        [self.selectHotTagsArray addObject:str];
        //        HotTagsModel *model  = self.hotTags[index];
        //        [self.selectHotTagsArray addObject:model];
        
    }else{
        
        NSInteger indexBtn = [self.hotTagButtons indexOfObject:tagButton];
        
        
        NSString *str = self.hotTags[indexBtn];
        NSInteger index = [self.selectHotTagsArray indexOfObject:str];
        
        //        HotTagsModel *model  = self.hotTags[indexBtn];
        //        NSInteger index = [self.selectHotTagsArray indexOfObject:model];
        
        [self.selectHotTagsArray removeObjectAtIndex:index];
        
    }
    
}
/**
 点击清除按钮
 */
- (void)cancelBtnClick {
    self.filterButton.selected = NO;
    [self.filterButton setTitle:nil forState:UIControlStateNormal];
    [self.filterButton setBackgroundColor:[UIColor clearColor]];
    [self.filterButton setImage:[UIImage imageNamed:@"noselect_tag_gray"] forState:UIControlStateNormal];
    //    [self createNetWork];
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContentView.originY = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.originY = SCREEN_HEIGHT;
        for (UIButton *button in self.hotTagButtons) {
            button.selected = NO;
        }
        NSLog(@"即将清除的标签个数--%ld",self.selectHotTagsArray.count);
        [self.selectHotTagsArray removeAllObjects];
        NSLog(@"已经清除后标签个数为0--%ld",self.selectHotTagsArray.count);
}];
    
    [self.delegate clickCancelButtonBackArray:self.selectHotTagsArray];
}

- (void)ensureBtnClick:(UIButton *)button {
    if (self.selectHotTagsArray.count==0) {
        self.filterButton.selected = NO;
        
    }else{
        self.filterButton.selected = YES;
    }
    NSLog(@"标签个数%ld",self.selectHotTagsArray.count);
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContentView.originY = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.originY = SCREEN_HEIGHT;
        //点击确定后是否清除 所有曾经选择的按钮
        //        for (UIButton *button in self.hotTagButtons) {
        //            button.selected = NO;
        //        }
        //        [self.selectHotTagsArray removeAllObjects];
    }];
    
    [self.delegate clickEnsureButtonBackArray:self.selectHotTagsArray];
    
    
}

- (void)showView{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.originY = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.filterContentView.originY = SCREEN_HEIGHT - self.filterContentView.height;
        }];
    });

}

@end
