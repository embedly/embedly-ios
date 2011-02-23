//
//  EmbedlyTestViewController.m
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import "EmbedlyTestViewController.h"
#import "EmbedlyTestViewResultsController.h"
#import "JSON.h"

@implementation EmbedlyTestViewController

@synthesize url, submit, endpoint;
@synthesize embedly;

- (IBAction)submit:(id) sender {
	NSArray *earray = [[NSArray alloc] initWithObjects:kEmbedlyOembedEndpoint, kEmbedlyObjectifyEndpoint, kEmbedlyPreviewEndpoint, nil];
	[embedly setEndpoint:[earray objectAtIndex:[endpoint selectedSegmentIndex]]];
	[embedly callWithUrl:url.text];
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	url.delegate = self;
	embedly = [[Embedly alloc] initWithKey:@"079dc63c353211e088ae4040f9f86dcd"];
	embedly.maxWidth = [NSNumber numberWithInt:400];
	embedly.delegate = self;
	
}


//===========================================================
#pragma mark -
#pragma mark EmbedlyDelegate Methods
//===========================================================
- (void)embedlyDidReturnData:(NSData *)data {
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSArray *urls = [parser objectWithData:data];
	
	// In this example we return 1 url
	NSDictionary *obj = [[NSDictionary alloc] initWithDictionary: [urls objectAtIndex:0]];
	
	EmbedlyTestViewResultsController *aController = [[EmbedlyTestViewResultsController alloc] initWithStyle:UITableViewStylePlain];
	aController.obj = obj;
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
	[parser release];
	[obj release];
}

- (void)embedlyDidFailWithError:(NSError *)error {
	NSLog(@"Embedly did Receive an Error");
}

- (void)embedlyDidReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Embedly did Receive a Response");
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	endpoint = nil;
	url = nil;
	submit = nil;
	
}


- (void)dealloc {
	[endpoint release];
	[url release];
	[submit release];
    [super dealloc];
}

@end
