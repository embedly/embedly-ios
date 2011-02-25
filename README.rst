=============
 Embedly iOS
=============

Embedly iOS iPhone/iPad client library.  To find out what Embedly is all about, please visit
http://embed.ly. To see our API documentation, visit http://api.embed.ly/docs.

Prerequisites
+++++++++++++

* XCode - downloadable from `<http://developer.apple.com/>`_
* iOS Developer Account
    
Getting Started
+++++++++++++++

Check out the included xcodeproj file. The demo project loads the embedly response into a table view. If
you do not have a Pro Key, you will be limited to the services we support through `<http://api.embed.ly>`_.

Importing Embedly
^^^^^^^^^^^^^^^^^

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

    // Alternatively if you are an Embedly Pro User and know what endpoint you want to use
    Embedly *embedly = [[Embedly alloc] initWithKey:@"yourProKeyHere" andEndpoint:@"preview"];

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
  Read more about the json-framework hosted in `Google Code <http://code.google.com/p/json-framework/>`_.
  

Delegate
^^^^^^^^

In order for your Application to receive the information returned from Embedly you should 
implement the EmbedlyDelegate::
  
    #import <UIKit/UIKit.h>
    #import "Embedly.h"
    @interface YourViewController : UIViewController <EmbedlyDelegate>
    {
    }

There are 4 Methods that should be implemented as part of the Embedly Delegate::
  
    -(void) embedlyDidReturnRawData:(NSData *)data;
    -(void) embedlyDidLoad:(id)result;
    -(void) embedlyDidFailWithError:(NSError *)error;
    -(void) embedlyDidReceiveResponse:(NSURLResponse *)response;

embedlyDidReturnRawData
    This method receives the raw NSData object that gets returned from the URL. This method
    is useful if you would like to use your own JSON Parser to interpret the byte code

embedlyDidLoad
    This method receives either an NSDictionary or NSArray, depending on whether one or 
    multiple URLs were passed to Embedly. You can use [result isKindOfClass:[NSArray class]]
    to determine what the object should be cast as. The NSDictionary allows you to access
    parameters by key, you can see what keys are returned in our `documentation <http://pro.embed.ly/docs>`_.

embedlyDidFailWithError
    Method returns if there's a problem accessing the API. This is not what gets returned from
    the API if a given URL is invalid. That is handled in a JSON object defined `here <https://pro.embed.ly/docs/oembed#error-codes>`_.

embedlyDidReceiveResponse
    This method fires when the response returns but before all the data has been received. This  method maps
    directly to the NSURLConnection delegate method that Embedly receives.

Pro
+++

The Embedly iOS Library supports Embedly Pro accounts. If you have a pro key you can initialize the Embedly class
with the initWithKey method::

    Embedly *embedly = [[Embedly alloc] initWithKey:@"yourProKeyHere"];

If you do not have a Pro account, you can sign up for one at `Embedly Pro <http://pro.embed.ly>`_.

Choose an Endpoint
++++++++++++++++++

Our iOS Library supports all three of our endpoints. We recommend checking out how the responses differ between the three 
over at `Embedly Explore <http://explore.embed.ly>`_. The three endpoints are:

`oEmbed <http://pro.embed.ly/docs/oembed>`_
    This endpoint works for both Pro and Free accounts. If using with a free account, the responses are
    limited to the 204 services `listed here <http://api.embed.ly>`_. With a Pro account any URL will work.
`Objectify <http://pro.embed.ly/docs/objectify>`_
    This endpoint is only available for Pro Users. It returns every bit of information we can determine about a URL.
`Preview <http://pro.embed.ly/docs/Preview>`_
    This endpoint is only available for Pro Users. It returns a curated list of fields we think are most important
    including images, embeds, videos and descriptions.    

HTML5
^^^^^

Embedly supports HTML5 as it is available. That said only a handful of our video providers are currently supporting HTML5 Video.
That list is growing, but developers should bear in mind the limitations iOS faces with flash video. Our current list of HTML5
supporters:

* Youtube
* Whitehouse.gov
* Ted.com
* Posterous
* FunnyOrDie
* Flickr
* Confreaks
* Vimeo
* Crocodoc
