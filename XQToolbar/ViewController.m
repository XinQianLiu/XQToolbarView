//
//  ViewController.m
//  XQToolbar
//
//  Created by 用户 on 16/8/30.
//  Copyright © 2016年 XinQianLiu. All rights reserved.
//

#import "ViewController.h"
#import "XQToolbarView.h"

@interface ViewController () <XQToolbarViewDelegate>

@property (nonatomic, assign) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _index = 0;
    NSArray         *titlesArray = @[@"热门", @"发现", @"好声音", @"脱口秀", @"燃舞蹈", @"潮音乐", @"潮人", @"体育", @"明显", @"酷玩", @"网游", @"手游", @"其他"];
    XQToolbarView   *toolbarView;
    
    if (_index == 0) {
        toolbarView = [XQToolbarView toolbarViewWithTitles:titlesArray delegate:self];
    }
    else if (_index == 1) {
        toolbarView = [[XQToolbarView alloc] initWithTitles:titlesArray delegate:self];
    }
    else if (_index == 2){
        toolbarView = [[XQToolbarView alloc] init];
        toolbarView.backgroundColor = [UIColor whiteColor];
        toolbarView.delegate = self;
        toolbarView.titlesArray = titlesArray;
    }
    else{
        toolbarView = [[XQToolbarView alloc] initWithFrame:CGRectZero];
        toolbarView.backgroundColor = [UIColor whiteColor];
        toolbarView.delegate = self;
        toolbarView.titlesArray = titlesArray;
    }
    
    toolbarView.selectedIndex = 7;
    toolbarView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30);
    /**
     optional:
     toolbarView.selectedIndex = 2;
     toolbarView.selectTextColor = [UIColor redColor];
     toolbarView.selectLineColor = [UIColor greenColor];
     toolbarView.deselectTextColor = [UIColor blueColor];
     toolbarView.deselectLineColor = [UIColor yellowColor];
     toolbarView.itmeSize = CGSizeMake(100, 30);
     toolbarView.itmeBackgroundColor = [UIColor redColor];
     toolbarView.itmeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
     */
    [self.view addSubview:toolbarView];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - XQToolbarViewDelegate
- (void)didSelectIndex:(NSInteger)selectIndex toolbarView:(XQToolbarView *)toolbarView
{
    NSLog(@"\nindex-->%ld\ntoolbarView-->%p",selectIndex,&toolbarView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
