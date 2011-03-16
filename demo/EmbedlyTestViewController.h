//
//  EmbedlyTestViewController.h
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Embedly.h"
#import "MBProgressHUD.h"

@interface EmbedlyTestViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate, EmbedlyDelegate> {
	UITextField *url;
	UIButton *submit;
	UISegmentedControl *endpoint;	
	Embedly *embedly;
    IBOutlet UITextField *maxWidth;
    IBOutlet UITextField *maxHeight;
    IBOutlet UITextField *proKey;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITextField *url;
@property (nonatomic, retain) IBOutlet UIButton *submit;
@property (nonatomic, retain) IBOutlet UISegmentedControl *endpoint;
@property (nonatomic, retain) IBOutlet UITextField *maxWidth;
@property (nonatomic, retain) IBOutlet UITextField *maxHeight;
@property (nonatomic, retain) IBOutlet UITextField *proKey;

@property (nonatomic, retain) Embedly *embedly;

- (IBAction)submit:(id)sender;
@end

