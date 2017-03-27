//
//  ViewController.m
//  switchViewsDemo
//
//  Created by shaw on 2017/3/15.
//  Copyright © 2017年 shaw. All rights reserved.
//

#import "ViewController.h"
#import "ChildVC1.h"
#import "ChildVC2.h"
#import "ChildVC3.h"
#import "ChildVC4.h"
#import "UIView+Extension.h"

#define KACAppFrameHeight        [[UIScreen mainScreen] applicationFrame].size.height
#define KACAppFrameWidth         [[UIScreen mainScreen] applicationFrame].size.width
#define NavBarHeight 64.f
#define TitleViewHeight 35.f

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIView *indicatorView;

@property (nonatomic,strong)UIButton *selectedBtn;

@property (nonatomic,strong)UIView *titlesView;

@property (nonatomic,strong)UIScrollView *contentScroll;

@property (nonatomic,strong)ChildVC1 *childVC1;
@property (nonatomic,strong)ChildVC2 *childVC2;
@property (nonatomic,strong)ChildVC3 *childVC3;
@property (nonatomic,strong)ChildVC4 *childVC4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 设置导航栏
    [self setupNav];
    
    [self setupTitlesView];
    
    [self setupChildVCes];
    [self setupContentViews];
}

- (void)setupNav
{
    self.navigationItem.title = @"百思不得姐";
}

- (void)setupChildVCes
{
    [self addChildViewController:self.childVC1];
    [self addChildViewController:self.childVC2];
    [self addChildViewController:self.childVC3];
    [self addChildViewController:self.childVC4];
}

- (void)setupContentViews
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view insertSubview:self.contentView atIndex:0];
    
    [self.contentScroll addSubview:self.childVC1.view];
    [self.contentScroll addSubview:self.childVC2.view];
    [self.contentScroll addSubview:self.childVC3.view];
    [self.contentScroll addSubview:self.childVC4.view];
    
    self.childVC1.view.frame = self.contentScroll.bounds;
    self.childVC2.view.frame = CGRectMake(KACAppFrameWidth, 0, KACAppFrameWidth, self.contentScroll.height);
    self.childVC3.view.frame = CGRectMake(KACAppFrameWidth*2, 0, KACAppFrameWidth, self.contentScroll.height);
    self.childVC4.view.frame = CGRectMake(KACAppFrameWidth*3, 0, KACAppFrameWidth, self.contentScroll.height);
}

/**
 *设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = TitleViewHeight;
    titlesView.y = NavBarHeight;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部子标签
    NSArray *titles = @[@"视频",@"声音",@"图片",@"段子"];
    CGFloat height = titlesView.height;
    CGFloat width = titlesView.width / titles.count;
    
    for (NSInteger i=0; i<titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * button.width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button layoutIfNeeded]; // 强制布局（强制更新子控件的frame）
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        if (i == 0) {
            
            button.enabled = NO;
            self.selectedBtn = button;
            // 让按钮内部的label根据文字内容计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    // indicatorView最后才添加到titlesView里
    // 为了后面从titlesView取button方便
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮的状态
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    
    // 让标签执行动画
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.width = self.selectedBtn.titleLabel.width;
        self.indicatorView.centerX = self.selectedBtn.centerX;
    }];
    
    // 滚动contentView
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
/** 
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法 
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}

/** 
 *  在scrollview停止滑动的时候执行 
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 点击菜单按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

#pragma mark - setters and getters
- (ChildVC1 *)childVC1
{
    if (!_childVC1) {
        _childVC1 = [ChildVC1 new];
    }
    return _childVC1;
}

- (ChildVC2 *)childVC2
{
    if (!_childVC2) {
        _childVC2 = [ChildVC2 new];
    }
    return _childVC2;
}

- (ChildVC3 *)childVC3
{
    if (!_childVC3) {
        _childVC3 = [ChildVC3 new];
    }
    return _childVC3;
}

- (ChildVC4 *)childVC4
{
    if (!_childVC4) {
        _childVC4 = [ChildVC4 new];
    }
    return _childVC4;
}

- (UIScrollView *)contentView
{
    if (!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] init];
        _contentScroll.frame = CGRectMake(0, NavBarHeight+TitleViewHeight, self.view.width, self.view.height-NavBarHeight-TitleViewHeight);
        _contentScroll.delegate = self;
        _contentScroll.contentSize = CGSizeMake(KACAppFrameWidth*4, _contentScroll.height);
        _contentScroll.pagingEnabled = YES;
    }
    return _contentScroll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
