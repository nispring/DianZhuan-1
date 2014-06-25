//
//  SSWebViewController.h
//  SSToolKit
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright 2012 Sam Soffes. All rights reserved.
//

#import "SSWebView.h"


@interface SSWebViewController : UIViewController <SSWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) BOOL useToolbar;
@property (nonatomic, readonly, copy) NSURL *currentURL;
@property (nonatomic,strong)NSString *currentStr;

- (void)loadURL:(NSString *)urlStr;


@end
