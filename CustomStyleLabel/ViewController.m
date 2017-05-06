//
//  ViewController.m
//  CustomStyleLabel
//
//  Created by fengbaitong on 2017/5/4.
//  Copyright © 2017年 fbt. All rights reserved.


/**
 思路全部都是zhupc工程师，想的。我也仅仅是赋值整理代码。
 NSArray+Log NSDictionary+Log 都是打印 不是UTF8。打印字符串正确。
 HotTagsModel 有时候你可能点击按钮传递的是模型。这个时候你要从模型中取字符串。
 YJXTagButton 下方的Tagbutton由超神封装，根据文字设置宽度。里面的setTitle中的逻辑顺序很重要请不要随便更改
 UIColor+Ext 颜色分类 已经不知道是谁写的了
 UIView+Ext 一个强大的UIView分类。
 */

//

#import "ViewController.h"
#import "UIView+Ext.h"
#import "UIColor+Ext.h"
#import "YJXTagButton.h"
#import "HotTagsModel.h"
#import "NSArray+Log.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#import "CustomStyleView.h"
@interface ViewController ()<UIGestureRecognizerDelegate,FBTCustomStyleViewDelegate>
@property (nonatomic,strong) UIButton * filterButton;//下方的筛选按钮
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIScrollView *tagBgView;
@property (nonatomic, strong) UIView *filterContentView;
@property (nonatomic, strong) UITapGestureRecognizer *oneTap;
//下方标签相关数组
@property (nonatomic, strong) NSMutableArray *hotTags;
@property (nonatomic, strong) NSMutableArray *hotTagButtons;
@property (nonatomic, strong) NSMutableArray *selectHotTagsArray;

@property (nonatomic, strong) CustomStyleView *styleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBottomCircularView];
    
//    CustomStyleView * View = [[CustomStyleView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    View.hidden = YES;
//    [self.view addSubview:View];
//    self.styleView = View;
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(dddpopViewFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
//错误写法
//- (CustomStyleView *)styleView{
//    CustomStyleView * View = [[CustomStyleView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:View];
//    return View;
//}

- (CustomStyleView *)styleView{
    if (!_styleView) {
//        _styleView =  [[CustomStyleView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //要求你一创建的时候就传进去一个数组，可以传空数组
        _styleView =  [[CustomStyleView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) array:self.hotTags];
        _styleView.delegate = self;
//        _styleView.hotTags = self.hotTags;//  在init的时候就已经布局了所以这个时候赋值是错误的。
        [self.view addSubview:_styleView];
    }
    return _styleView;
}
#pragma mark 协议
-(void)clickCancelButtonBackArray:(NSArray *)array{

    NSLog(@"%@",array);
}
- (void)clickEnsureButtonBackArray:(NSArray *)array{

     NSLog(@"%@",array);
}

#pragma mark 点击这个回归主线程 
/**
 弹出View
 */
- (void)dddpopViewFilterView:(UIButton *)button{
    
    [self.styleView showView];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.styleView.hidden = NO;
//        self.styleView.originY = 0;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.styleView.filterContentView.originY = SCREEN_HEIGHT - self.filterContentView.height;
//        }];
//    });
}
/**
 下方的标签数组(可有由网络请求进行返回也可以写成死数据)
 */
- (NSMutableArray *)hotTags {
    if (!_hotTags) {
//        _hotTags = [NSMutableArray array];
        _hotTags = [NSMutableArray arrayWithArray:@[@"高血压",@"糖尿病",@"风湿",@"类风湿性关节炎",@"颈椎病",@"感冒",@"发热",@"甲状腺",@"我是测试标签疾病",@"牛皮靴",@"头痛",@"胃功能障碍",@"骨折",@"肩周炎",@"肌肉酸痛",@"视力模糊",@"青光眼",@"白内障",@"耳鸣",@"呼吸道感染",@"消化不良",@"腹泻",@"头晕眼花"]];
    }
    return _hotTags;
}

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
/**
 点击后弹出的背景灰色蒙版（视图） 添加简单的动画
 */
- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] init];
        _filterView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        //一开始的时候 宽高为屏幕， point为 中心点为（0，SCREEN_HEIGHT）
        _filterView.originX = 0;
        _filterView.width = SCREEN_WIDTH;
        _filterView.height = SCREEN_HEIGHT;
        //用uiwindow添加
        [[UIApplication sharedApplication].keyWindow addSubview:_filterView];
        _filterView.originY = SCREEN_HEIGHT;
        //添加装tag的父白色视图
        [_filterView addSubview:self.filterContentView];
        //手势 隐藏视图和动画
        _oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneClick:)];
        _oneTap.numberOfTapsRequired     = 1;
        _oneTap.numberOfTouchesRequired  = 1;
        _oneTap.delegate = self;
        [_filterView addGestureRecognizer:_oneTap];
    }
    return _filterView;
}

#pragma mark - 手势处理
// 单击事件
- (void)oneClick:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContentView.originY = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _filterView.hidden = YES;
        _filterView.originY = SCREEN_HEIGHT;
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
        //        tagBgView.contentSize = CGSizeMake(0, 300);
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

/**
 *  下方的圆view。
 */
- (void)setupBottomCircularView{
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    filterButton.layer.cornerRadius = 25;
    filterButton.layer.masksToBounds = YES;
    
    // 64为距离下面的高度，80位搜索和分栏的高度，64 为导航的高度。44 为tabbr的高度-60-64-80-48
    filterButton.frame = CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-60-64-80-48, 50, 50);
    //    [filterButton setImage:[UIImage imageNamed:@"noselect_tag_gray"] forState:UIControlStateNormal];
    //    [filterButton setImage:[UIImage imageNamed:@"selectd_tag_blue"] forState:UIControlStateSelected];
    filterButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [filterButton setBackgroundColor:[UIColor clearColor]];
    [filterButton setImage:[UIImage imageNamed:@"noselect_tag_gray"] forState:UIControlStateNormal];
    [filterButton setImage:[UIImage imageNamed:@"noselect_tag_gray"] forState:UIControlStateNormal];
    self.filterButton = filterButton;
    [self.filterButton addTarget:self action:@selector(popViewFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.filterButton];

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
//        
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
        self.filterView.hidden = YES;
        self.filterView.originY = SCREEN_HEIGHT;
        for (UIButton *button in self.hotTagButtons) {
            button.selected = NO;
        }
         NSLog(@"即将清除的标签个数--%ld",self.selectHotTagsArray.count);
        [self.selectHotTagsArray removeAllObjects];
        NSLog(@"已经清除后标签个数为0--%ld",self.selectHotTagsArray.count);
    }];
    
}

- (void)ensureBtnClick:(UIButton *)button {
    if (self.selectHotTagsArray.count==0) {
        self.filterButton.selected = NO;
        
    }else{
        self.filterButton.selected = YES;
    }
    [self filterTagNetWork:self.selectHotTagsArray];
    NSLog(@"标签个数%ld",self.selectHotTagsArray.count);
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContentView.originY = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.filterView.hidden = YES;
        self.filterView.originY = SCREEN_HEIGHT;
        //        for (UIButton *button in self.hotTagButtons) {
        //            button.selected = NO;
        //        }
        //        [self.selectHotTagsArray removeAllObjects];
    }];
    
    
}

- (void)filterTagNetWork:(NSArray *)array{
    NSLog(@"%@",array);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.selectHotTagsArray.count ==0) {
            [self.filterButton setTitle:nil forState:UIControlStateNormal];
            [self.filterButton setBackgroundColor:[UIColor clearColor]];
            [self.filterButton setImage:[UIImage imageNamed:@"noselect_tag_gray"] forState:UIControlStateNormal];
            
        }else{
            
            [self.filterButton setTitle:[NSString stringWithFormat:@"%ld人",array.count] forState:UIControlStateSelected];
            [self.filterButton setBackgroundColor:[UIColor blueColor]];
            [self.filterButton setImage:nil forState:UIControlStateNormal];
        }
    });
    
}

/**
 弹出View
 */
- (void)popViewFilterView:(UIButton *)button{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.filterView.hidden = NO;
        self.filterView.originY = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.filterContentView.originY = SCREEN_HEIGHT - self.filterContentView.height;
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
