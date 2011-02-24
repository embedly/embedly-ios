//
//  EmbedlyTestViewController.h
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Embedly.h"

@interface EmbedlyTestViewController : UIViewController <UITextFieldDelegate, EmbedlyDelegate> {
	UITextField *url;
	UIButton *submit;
	UIButton *test;
	UISegmentedControl *endpoint;	
	Embedly *embedly;
	
}

@property (nonatomic, retain) IBOutlet UITextField *url;
@property (nonatomic, retain) IBOutlet UIButton *submit;
@property (nonatomic, retain) IBOutlet UIButton *test;
@property (nonatomic, retain) IBOutlet UISegmentedControl *endpoint;
@property (nonatomic, retain) Embedly *embedly;

- (IBAction)submit:(id)sender;
- (IBAction)testMultipleUrls:(id)sender;
@end

