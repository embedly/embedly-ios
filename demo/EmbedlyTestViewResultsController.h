//
//  EmbedlyTestViewResultsController.h
//  EmbedlyTest
//
//  Created by Thomas Boetig on 2/18/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmbedlyTestViewResultsController : UITableViewController {
	NSDictionary *obj;
	NSArray *objArray;
	NSArray *keys;
	Boolean isArray;
}
@property (nonatomic, retain) NSDictionary *obj;
@property (nonatomic, retain) NSArray *objArray;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic) Boolean isArray;

@end
