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

@synthesize url, submit, endpoint;
@synthesize maxWidth, maxHeight, proKey;
@synthesize embedly;

- (IBAction)submit:(id) sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if(![self.proKey.text isEqualToString:@""]){
        embedly.key = self.proKey.text;
    } 
    
    if(self.maxHeight.text != nil)
        embedly.maxHeight = [f numberFromString:self.maxHeight.text];
    
    if(self.maxWidth.text != nil)
        embedly.maxWidth = [f numberFromString:self.maxWidth.text];
    
	NSArray *earray = [[NSArray alloc] initWithObjects:kEmbedlyOembedEndpoint, kEmbedlyObjectifyEndpoint, kEmbedlyPreviewEndpoint, nil];
    NSLog(@"%@", [earray objectAtIndex:[endpoint selectedSegmentIndex]]);
	[embedly setEndpoint:[earray objectAtIndex:[endpoint selectedSegmentIndex]]];
    [embedly callWithUrl:url.text];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
	[earray release];
    [f release];
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	url.delegate = self;
    embedly = [[Embedly alloc] init];
	embedly.delegate = self;
    [self.submit setEnabled:NO];
    
    // instantiate the loading graphic
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
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
	NSLog(@"Embedly did Receive an Error: %@", error);
}

- (void)embedlyDidReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Embedly did Receive a Response");
    [HUD hide:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:[self proKey]] && ![[self.proKey text] isEqualToString:@""])
        [submit setEnabled:YES];
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
    maxWidth = nil;
    maxHeight = nil;
    proKey = nil;
}


- (void)dealloc {
	[endpoint release];
	[url release];
	[submit release];
	[proKey release];
    [maxWidth release];
    [maxHeight release];
    [super dealloc];
}

@end
