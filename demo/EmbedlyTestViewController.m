//
//  EmbedlyTestViewController.m
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import "EmbedlyTestViewController.h"
#import "EmbedlyTestViewResultsController.h"

@implementation EmbedlyTestViewController

@synthesize url, submit, endpoint, test;
@synthesize embedly;

- (IBAction)submit:(id) sender {
	NSArray *earray = [[NSArray alloc] initWithObjects:kEmbedlyOembedEndpoint, kEmbedlyObjectifyEndpoint, kEmbedlyPreviewEndpoint, nil];
	[embedly setEndpoint:[earray objectAtIndex:[endpoint selectedSegmentIndex]]];
	[embedly callWithUrl:url.text];
	[earray release];
}

// Test the Embedly API with Multi-get
- (IBAction)testMultipleUrls:(id) sender {
	NSArray *urls = [[NSArray alloc] initWithObjects:@"http://www.youtube.com/watch?v=BfcWraeZvcw",
													 @"http://www.flickr.com/photos/cybertiesto/336245284/",
													 @"http://vimeo.com/20187108",
													 nil];
	NSArray *earray = [[NSArray alloc] initWithObjects:kEmbedlyOembedEndpoint, kEmbedlyObjectifyEndpoint, kEmbedlyPreviewEndpoint, nil];
	[embedly setEndpoint:[earray objectAtIndex:[endpoint selectedSegmentIndex]]];
	[embedly callWithArray:urls];
	[earray release];
	[urls release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	url.delegate = self;
	embedly = [[Embedly alloc] init];
	embedly.maxWidth = [NSNumber numberWithInt:400];
	embedly.delegate = self;
	
}


//===========================================================
#pragma mark -
#pragma mark EmbedlyDelegate Methods
//===========================================================
- (void)embedlyDidLoad:(id)result {
	EmbedlyTestViewResultsController *aController = [[EmbedlyTestViewResultsController alloc] initWithStyle:UITableViewStylePlain];
	
	if( [result isKindOfClass:[NSArray class]] ){
		aController.objArray = result;
		aController.title = @"Results";
	} else if ( [result isKindOfClass:[NSDictionary class]] ){
		aController.obj = result;
		
	} else {
		NSLog(@"%@", result);
		[aController release];
		return;
	}
	[self.navigationController pushViewController:aController animated:YES];
	[aController release];
}

- (void)embedlyDidReturnRawData:(NSData *)data {
	
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
	test = nil;
}


- (void)dealloc {
	[endpoint release];
	[url release];
	[submit release];
	[test release];
    [super dealloc];
}

@end
