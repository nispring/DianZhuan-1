//
//  SSWebViewController.m
//  SSToolKit
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright 2012 Sam Soffes. All rights reserved.
//



#import "SSWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "CBAppDelegate.h"

#import "CBKeyChain.h"

@interface SSWebViewController ()<UIScrollViewDelegate,UIAlertViewDelegate> {
    SSWebView *_webView;
	NSURL *_url;
	UIActivityIndicatorView *_indicator;
	UIBarButtonItem *_backBarButton;
	UIBarButtonItem *_forwardBarButton;
    
    //int _lastPosition;    //A variable define in headfile

    BOOL _returnFlag;
    NSString *_orderId;
    
}
        
- (void)_updateBrowserUI;
- (void)openSafari:(id)sender;
- (void)openActionSheet:(id)sender;

@end

@implementation SSWebViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)dealloc{
    _webView = nil;
    _webView.delegate = nil;
    [_webView stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML='';"];
    [_webView removeFromSuperview];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    NSUInteger pointY=0;
    if(IOS_7){
        pointY = 20;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//写cookie
//    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//    [cookieProperties setObject:@"user_sessionid" forKey:NSHTTPCookieName];
//    [cookieProperties setObject:@"111" forKey:NSHTTPCookieValue];
//    [cookieProperties setObject:@"182.131.0.212" forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//    [cookieProperties setObject:@"1" forKey:NSHTTPCookieDiscard];
//    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//    
//    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    DLog(@"new cookie:%@",cookie);

    
	_webView = [[SSWebView alloc] initWithFrame:CGRectMake(0,pointY, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-40-20)];
	_webView.delegate = self;
	_webView.scalesPageToFit = YES;
    if(self.currentStr.length>1){
        [_webView loadHTMLString:self.currentStr];
    }else{
        [_webView loadURL:_url];
    }
	[self.view addSubview:_webView];
    
    _indicator = [[UIActivityIndicatorView alloc]
                  initWithFrame : CGRectMake((APP_SCREEN_WIDTH-32)/2,(APP_SCREEN_CONTENT_HEIGHT-49-32)/2, 32.0f, 32.0f)] ;
	_indicator.hidesWhenStopped = YES;
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[self.view addSubview:_indicator];

	
    UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _webView.bottom, APP_SCREEN_WIDTH, 40)];
    [self.view addSubview:bottomImageView];
    bottomImageView.image = [UIImage imageNamed:@"wap_down"];
    bottomImageView.userInteractionEnabled = YES;
    NSArray *images = @[@"back-button",@"reload-button",@"action-button"];
    for(int i=0;i<3;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(35+i*110, 5, 25, 33);
        [bottomImageView addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(doBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)doBottomButton:(UIButton *)sender{
    if(sender.tag==100){
        if([_webView canGoBack]){
            [_webView goBack];
        }else{
            [self exitVC];
        }
    }
    if(sender.tag==101){
        [_webView reload];
    }
    if(sender.tag==102){
        [self openActionSheet:sender];
    }
}
#pragma mark - URL Loading

- (void)loadURL:(NSURL *)url {
	_url = url;
    [_webView stopLoading];
    [_webView loadURL:url];
}

- (NSURL *)currentURL {
	NSURL *url = _webView.lastRequest.mainDocumentURL;
	if (!url) {
		url = _url;
	}
	return url;
}


- (void)openSafari:(id)sender {
	[[UIApplication sharedApplication] openURL:self.currentURL];
}


- (void)openActionSheet:(id)sender {
	UIActionSheet *actionSheet = nil;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"用safari打开",@"退出当前页",nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
}

#pragma mark - Private

- (void)_updateBrowserUI {
	
    UIButton *button1 = (UIButton *)[self.view viewWithTag:101];
	if ([_webView isLoadingPage]) {
		[_indicator startAnimating];
        button1.hidden = YES;
	} else {
		[_indicator stopAnimating];
        button1.hidden = NO;
	}
}


#pragma mark - SSWebViewDelegate

- (void)webViewDidLoadDOM:(SSWebView *)aWebView {
	NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	if (title && title.length > 0) {
		self.title = title;
	}
}

- (void)webViewDidStartLoadingPage:(SSWebView *)aWebView {

//    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
//    NSLog(@"之前:%d %d",urlCache.memoryCapacity,urlCache.diskCapacity);
//    
//    [urlCache removeAllCachedResponses];
//    NSLog(@"之前:%d %d",urlCache.memoryCapacity,urlCache.diskCapacity);
	[self _updateBrowserUI];
}

- (void)webViewDidFinishLoadingPage:(SSWebView *)aWebView {
	[self _updateBrowserUI];
    
    DLog(@"url:%@",_webView.lastRequest.mainDocumentURL);
    
    UIButton *backBtn = (UIButton *)[self.view viewWithTag:100];
    UIButton *refreshBtn = (UIButton *)[self.view viewWithTag:101];

    NSString *urlStr = [NSString stringWithFormat:@"%@",_webView.lastRequest.mainDocumentURL];
    if([urlStr containString:@"appowj=1"]){ //支付宝支付
        backBtn.enabled = NO;
        refreshBtn.enabled = NO;
        NSRange beginRange = [urlStr rangeOfString:@"id"];
        NSString *tmpStr = [urlStr substringFromIndex:beginRange.location+3];
        NSRange endRange = [tmpStr rangeOfString:@"&"];
        _orderId = [tmpStr substringToIndex:endRange.location];
        return;
    }
    if([urlStr containString:@"appowj=2"]){ //银联支付
        backBtn.enabled = NO;
        refreshBtn.enabled = NO;
        NSRange beginRange = [urlStr rangeOfString:@"id"];
        NSString *tmpStr = [urlStr substringFromIndex:beginRange.location+3];
        NSRange endRange = [tmpStr rangeOfString:@"&"];
        _orderId = [tmpStr substringToIndex:endRange.location];
        return;
    }
    backBtn.enabled = YES;
    refreshBtn.enabled = YES;
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"cookie:%@", cookie);
        NSLog(@"%@",cookie.name);
        NSLog(@"%@",cookie.value);
    }
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        NSString *URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

- (void)didReceiveMemoryWarning{
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
        _webView = nil;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    

    [super didReceiveMemoryWarning];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [self share];
	} else if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:self.currentURL];
	}else if(buttonIndex == 2){
        [self exitVC];
    }
}
- (void)share{
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSURL *url = _webView.lastRequest.mainDocumentURL;
    id<ISSContent>publishContent=[ShareSDK content:[NSString stringWithFormat:@"%@\n%@",title,url.absoluteString] defaultContent:@"米珈微街"
                                             image:nil title:@"米珈微街" url:@"http://www.wxjust.com/"
                                       description:@"圈子比口岸更重要!" mediaType:SSPublishContentMediaTypeText];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)exitVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
