# XQToolbarView
ToolbarView
## Image
![](http://a1.qpic.cn/psb?/V12vcXx72Pkh20/6OcUyulDSRsUNuBqXxTMqf7scXNJIbOHV6uMaqv1gxA!/m/dLAAAAAAAAAAnull&bo=fQFLAAAAAAADBxU!&rf=photolist&t=5)

## Usage
At first, import XQToolbarView:
```
#import "XQToolbarView.h"
```
Delegate
```
@interface ViewController () <XQToolbarViewDelegate>
```
The sample code, details the Demo
```objective-c
- (void)viewDidLoad
{
    NSArray *titlesArray = @[@"热门", @"发现", @"好声音", @"脱口秀", @"燃舞蹈", @"潮音乐", @"潮人", @"体育", @"明显", @"酷玩", @"网游", @"手游", @"其他"];
    XQToolbarView *toolbarView = [XQToolbarView toolbarViewWithTitles:titlesArray delegate:self];
    toolbarView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 30);
    [self.view addSubview:toolbarView];
}

#pragma mark - XQToolbarViewDelegate
- (void)didSelectIndex:(NSInteger)selectIndex toolbarView:(XQToolbarView *)toolbarView
{
    NSLog(@"\nindex-->%ld\ntoolbarView-->%p",selectIndex,&toolbarView);
}
```
