//
//  edemViewController.h
//  EmbedlyDemo
//
//  Created by Andrew Pellett on 5/19/14.
//  Copyright (c) 2014 Embedly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface edemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *urlResponse;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextField *optimizeImagesField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *endpointChooser;
@property (weak, nonatomic) IBOutlet UILabel *urlProvider;
@property (weak, nonatomic) IBOutlet UILabel *urlTitle;

- (IBAction)urlChanged:(id)sender;

@end
