//
//  EmbedlyTestViewResultsController.m
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/18/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import "EmbedlyTestViewResultsController.h"


@implementation EmbedlyTestViewResultsController

@synthesize obj, keys, isArray, objArray;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	if ( objArray != nil ){
		self.isArray = TRUE;
	} else {
		self.isArray = FALSE;
	}
	if( self.isArray) {
		// do nothing right now
		
	} else {
		if ([obj objectForKey:@"title"] != nil)
			self.title = [obj objectForKey:@"title"];
		keys = [[NSArray alloc] initWithArray: [[obj allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	}
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (self.isArray){
		return [objArray count];
	} else {
		return [keys count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (self.isArray){
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			NSString *text = [[NSString alloc] initWithFormat:@"%d", indexPath.row];
			[cell.textLabel setText:text];
			[text release];
		}
	} else {
		NSString *attrName = [keys objectAtIndex:indexPath.row];
		NSString *title = [attrName capitalizedString];
		
		
		
		if (cell == nil) {
			if([[obj objectForKey:attrName] isKindOfClass:[NSArray class]] || [[obj objectForKey:attrName] isKindOfClass:[NSDictionary class]]) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				[cell.textLabel setText:title];
			} else {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
				[cell.textLabel setText:title];
				if( [obj objectForKey:attrName] != [NSNull null] ){
					NSString *text = [[NSString alloc] initWithFormat:@"%@", [obj objectForKey:attrName]];
					[cell.detailTextLabel setText: text];
					[text release];
				} else {
					[cell.detailTextLabel setText: @"null"];
				}

			}
		}
	}
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	
	EmbedlyTestViewResultsController *detailView = [[EmbedlyTestViewResultsController alloc] initWithStyle:UITableViewStylePlain];
	if (self.isArray){
		
		if ( [[objArray objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]] ){
			detailView.objArray = [objArray objectAtIndex:indexPath.row];
			NSLog(@"%@", [objArray objectAtIndex:indexPath.row]);
			//detailView.title = [[NSString alloc] initWithFormat:@"%d", indexPath.row];
			[self.navigationController pushViewController:detailView animated:YES];
		} else if ( [[objArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]] ) {
			detailView.obj = [objArray objectAtIndex:indexPath.row];
			NSLog(@"%@", [objArray objectAtIndex:indexPath.row]);
			//detailView.title = [[NSString alloc] initWithFormat:@"%d", indexPath.row];
			[self.navigationController pushViewController:detailView animated:YES];
		}
		
	} else {
		NSString *attrName = [[NSString alloc] initWithString:[keys objectAtIndex:indexPath.row]];
		if ( [attrName isEqualToString:@"object"] ){
			UIViewController *v = [[UIViewController alloc] init];
			
			[self.navigationController pushViewController:v animated:YES];
			[v release];
		} else if ( [attrName isEqualToString:@"html"] || [attrName isEqualToString:@"html5"] ) {
			UIViewController *v = [[UIViewController alloc] init];
			
			UIWebView *wv = [[UIWebView alloc] init];
			
			[wv loadHTMLString:[obj objectForKey:attrName] baseURL:[NSURL URLWithString:@"http://embed.ly"]];
			 v.view = wv;
			[self.navigationController pushViewController:v animated:YES];
			[wv release];
			[v release];
		} else if ( [attrName isEqualToString:@"images"] ){
			NSLog(@"Image Display");
			NSMutableArray *images = [[NSMutableArray alloc] init];
			for(NSDictionary *image in [obj objectForKey:attrName]){
				NSURL *u = [[NSURL alloc] initWithString:[image objectForKey:@"url"]];
				NSData *data = [[NSData alloc] initWithContentsOfURL:u];
				UIImage *img = [[UIImage alloc] initWithData:data];
				[u release];
				[images addObject:img];
				[img release];
				[data release];
			}
			UIViewController *view = [[UIViewController alloc] init];
			UIImageView *imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:0]];
			imageView.animationImages = images;
			
			imageView.animationDuration = 5.0;
			view.view = imageView;
			[self.navigationController pushViewController:view animated:YES];
			[view release];
			[imageView startAnimating];
			[imageView release];
			
		} else if ([[obj objectForKey:attrName] isKindOfClass:[NSArray class]]){
			detailView.objArray = [obj objectForKey:attrName];
			detailView.title = attrName;
			// Pass the selected object to the new view controller.
			[self.navigationController pushViewController:detailView animated:YES];
		} else if ([[obj objectForKey:attrName] isKindOfClass:[NSDictionary class]]){
			detailView.obj = [obj objectForKey:attrName];
			detailView.title = attrName;
			// Pass the selected object to the new view controller.
			[self.navigationController pushViewController:detailView animated:YES];
			
		}
		[attrName release];
		
	}
	[detailView release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	keys = nil;
	obj = nil;
	objArray = nil;
}


- (void)dealloc {
	[obj release];
	[objArray release];
	[keys release];
    [super dealloc];
}


@end

