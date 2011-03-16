//
//  EmbedlyHtmlViewController.h
//  EmbedlyTest
//
//  Created by Thomas Boetig on 3/16/11.
//  Copyright 2011 Embed.ly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmbedlyHtmlViewController : UIViewController {
    IBOutlet UIWebView *wv;
    NSString *html;
}

@property (nonatomic, retain) UIWebView *wv;
@property (nonatomic, retain) NSString *html;

@end
