embedly
-------

Embedly iOS iPhone/iPad client library.  To find out what Embedly is all about, please visit
http://embed.ly. To see our API documentation, visit http://api.embed.ly/docs.

Prerequisites
^^^^^^^^^^^^^

* XCode - downloadable from `<http://developer.apple.com/>`_
* iOS Developer Account

Getting Started
^^^^^^^^^^^^^^^

Check out the included xcodeproj file. The demo project loads the embedly response into a table view. If
you do not have a Pro Key, you will be limited to the services we support through `<http://api.embed.ly>`_.


Importing Embedly into a Project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* Right click on your Project and select Add Existing Files
* Navigate to where you have the Embedly Library checked out
* Select the Embedly.h and Embedly.m files and continue
* Do not select "Copy items into destination group's folder". This will make updating the Embedly code easier
* Click Add


Initializing Embedly
^^^^^^^^^^^^^^^^^^^^

* Include "Embedly.h" in your file
* Create an instance of the Embedly class::
    
    // instantiate Embedly
    Embedly *embedly = [[Embedly alloc] init];

    // Alternatively if you are an Embedly Pro User
    Embedly *embedly = [[Embedly alloc] initWithKey:@"yourProKeyHere"];

* Call the Embedly API with a URL String or array of URLs::
    
    // one URL 
    NSString *url = [[NSString alloc] initWithString:@"http://www.youtube.com/watch?v=PKC_ORM0vpo"];
    [embedly callWithUrl:url ];
    
    // Array of URLs
    NSArray *urls = [[NSArray alloc] initWithObjects:@"http://www.youtube.com/watch?v=PKC_ORM0vpo", 
                                                     @"http://www.youtube.com/watch?v=97wCoDn0RrA", 
                                                     nil];
    [embedly callWithArray:urls];

* Embedly returns a JSON String. The iOS json-framework is included with the Embedly Demo project here. 
  Read more about the json-framework at `<http://code.google.com/p/json-framework/>`_.
  

Delegate
^^^^^^^^

* In order for your Application to receive the information returned from Embedly you should 
  implement the EmbedlyDelegate::
    
  #import <UIKit/UIKit.h>
  #import "Embedly.h"
  
  @interface YourViewController : UIViewController <EmbedlyDelegate> {
  }

* There are 4 Methods that should be implemented as part of the Embedly Delgate. These map to the NSURLConnection
  responses::
  
    -(void) embedlyDidReturnRawData:(NSData *)data;
    -(void) embedlyDidLoad:(id)result;
    -(void) embedlyDidFailWithError:(NSError *)error;
    -(void) embedlyDidReceiveResponse:(NSURLResponse *)response;

