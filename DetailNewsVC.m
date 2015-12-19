//
//  DetailNewsVC.m
//  QuantumNews
//
//  Created by wangxinyan on 15/11/17.
//  Copyright (c) 2015年 longjiang. All rights reserved.
//

#import "DetailNewsVC.h"
#import "DKCircleButton.h"

#define OriginHight 250
#define Height 80.0f

@interface DetailNewsVC ()<UIWebViewDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)UIWebView *webView;
@property(strong,nonatomic)UIImageView *TopImageView;

@property(strong,nonatomic)DKCircleButton *ReturnButton;



@end

@implementation DetailNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    _ReturnButton=[[DKCircleButton alloc]initWithFrame:CGRectMake(20, 20, 35, 35)];
    _ReturnButton.center=CGPointMake(30, 50);
    _ReturnButton.backgroundColor=[UIColor blackColor];

    [_ReturnButton addTarget:self action:@selector(ReturnMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ReturnButton];
    

    //界面用Parallax ScrollView
    //MXScrollView
  //webview
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *urlStr=[NSString stringWithFormat:@"http://www.longxyun.com/AppData/News/html/%@",self.selectedData.url];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];

        });
    });

    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    
    self.webView.delegate=self;
    self.webView.scrollView.delegate=self;
    [self.view addSubview:self.webView];
    //q去掉滚动条
//    for (UIView *sView in [self.webView subviews]) {
//        if ([sView isKindOfClass:[UIScrollView class]]) {
//            //右侧
//            [(UIScrollView *)sView setShowsVerticalScrollIndicator:NO];
//            //下侧
//            for (UIView *scView in sView.subviews) {
//                if ([scView isKindOfClass:[UIImageView class]]) {
//                    scView.hidden=YES;
//                }
//            }
//        }
//    }
    
    [self.webView addSubview:_ReturnButton];
    

   
    //导航栏？？？
    
  
}
#pragma mark webview的delegate代理方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"网页开始加载");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"网页加载错误");
    NSLog(@"%@",error);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载完成");
//    NSString *meta=[NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes\"",webView.frame.size.width];
//    //NSLog(@"width:%f",self.webView.frame.size.width);
//    [webView stringByEvaluatingJavaScriptFromString:meta];
  
}



#pragma mark 返回按钮返回前一个页面
-(void)ReturnMainVC{

    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark 返回按钮滑动隐藏
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"正在滑动");
    
        self.ReturnButton.hidden=YES;
    
    
}
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    //NSLog(@"滑动停止");
//        self.ReturnButton.hidden=NO;
//
//}
//手指停止滑动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        self.ReturnButton.hidden=NO;
    }
    
}
//scrollview停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.ReturnButton.hidden=NO;
}


@end
