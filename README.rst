=============
 Embedly iOS
=============

Embedly iOS iPhone/iPad client library. To find out what Embedly is all about, please visit
http://embed.ly. To see our documentation, visit http://pro.embed.ly/docs.

Prerequisites
+++++++++++++

* XCode - downloadable from `<http://developer.apple.com/>`_
* iOS Developer Account
* Embedly Pro Account, available at `Embedly Pro <http://pro.embed.ly>`_
    
Getting Started
+++++++++++++++

Check out the included xcodeproj file. The demo project loads the embedly response into a table view. An
Embedly Pro key is required for the demo project to load anything. You can sign up for a Pro account at
`Embedly Pro <http://pro.embed.ly>`_.

Importing Embedly
^^^^^^^^^^^^^^^^^

* Right click on your Project and select Add Existing Files
* Navigate to where you have the Embedly Library checked out
* Select the Embedly.h and Embedly.m files and continue
* Do not select "Copy items into destination group's folder". This will make updating the Embedly code easier
* Click Add
* You should repeat these steps for the JSON-framework classes included in the project as well. Documentation
  for JSON-framework is available on `GitHub <http://stig.github.com/json-framework/>`_


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

* Call Embedly with a URL String or array of URLs::
    
    // one URL 
    NSString *url = [[NSString alloc] initWithString:@"http://www.youtube.com/watch?v=PKC_ORM0vpo"];
    [embedly callWithUrl:url ];
    
    // Array of URLs
    NSArray *urls = [[NSArray alloc] initWithObjects:@"http://www.youtube.com/watch?v=PKC_ORM0vpo", 
                                                     @"http://www.youtube.com/watch?v=97wCoDn0RrA", 
                                                     nil];
    [embedly callWithArray:urls];

* Embedly returns a JSON String. The iOS JSON-framework is included with the Embedly Demo project. 
  Read more about the JSON-framework hosted on `GitHub <http://stig.github.com/json-framework/>`_.
  

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

The Embedly iOS Library requires an Embedly Pro account. With your Pro Key you can initialize the Embedly class
with the initWithKey method::

    Embedly *embedly = [[Embedly alloc] initWithKey:@"yourProKeyHere"];

If you do not have a Pro account, you can sign up for one at `Embedly Pro <http://pro.embed.ly>`_.

Choose an Endpoint
++++++++++++++++++

Our iOS Library supports all three of our endpoints. We recommend checking out how the responses differ between the three 
over at `Embedly Explore <http://explore.embed.ly>`_. The three endpoints are:

`oEmbed <http://pro.embed.ly/docs/oembed>`_
    This endpoint follows the oEmbed standard.
`Objectify <http://pro.embed.ly/docs/objectify>`_
    This endpoint returns every bit of information we can determine about a URL.
`Preview <http://pro.embed.ly/docs/Preview>`_
    This endpoint returns a curated list of fields we think are most important
    including images, embeds, videos and descriptions.    

HTML5
^^^^^

Embedly supports HTML5 as it is available. We currently support about 20 video and audio providers with HTML5.
That list will continue to grow, but developers should bear in mind the limitations iOS faces with flash video. Our current list of HTML5
supporters: 

* Youtube.com
* Whitehouse.gov
* Ted.com
* Scribd.com
* Vimeo.com
* Dipdive.com
* Edition.cnn.com
* Posterous.com
* FunnyOrDie.com
* Blip.tv
* BigThink.com
* Ustream.com
* Qik.com
* Digg.com
* Revision3.com
* Bambuser.com
* Socialcam.com
* Twitvid.com
* Confreaks.net
* Bandcamp.com
* Huffduffer.com

Test Links
^^^^^^^^^^

 - http://bambuser.com/channel/Spectrial/broadcast/114361
 - http://www.ustream.tv/sfshiba
 - http://bigthink.com/ideas/25129
 - http://dailydips.dipdive.com/media/162456
 - http://www.whitehouse.gov/photos-and-video/video/2010/10/19/educational-excellence-hispanic-americans
 - http://edition.cnn.com/video/#/video/tech/2011/02/24/ns.google.vp.page.cerf.cnn
 - http://www.ted.com/talks/lang/por_br/blaise_aguera.html
 - http://www.funnyordie.com/videos/356fc66a37/yoo-are-don-draper
 - http://www.funnyordie.com/videos/afcb7455c2/flight-of-the-conchords-issues-think-about-it-from-flight-of-the-conchords
 - http://confreaks.net/videos/431-rubyconf2010-keynote-why-ruby
 - http://tv.digg.com/diggnation/goingpublic/new-years-resolutions
 - http://socialcam.com/v/nI7vbp9x
 - http://gist.github.com/636842
 - http://wesingyourtweets.posterous.com/re-sweet-rachieuk
 - http://revision3.com/scientifictuesdays/scientifictuesdays-14
 - http://linuxconfau.blip.tv/file/4851926/
 - http://www.twitvid.com/K1AB6
 - http://www.youtube.com/watch?v=J---aiyznGQ (Weird transition to quicktime player)
 - http://vimeo.com/20297172
 - http://huffduffer.com/robotjohnny/31937
 - http://www.scribd.com/doc/51084126/Gouged-at-the-pumps-again
 - http://tiawittapmuzik.bandcamp.com/
 - http://danielaandbenspector.bandcamp.com/track/cut-it-out-ft-m-jack-bee
 - http://foursquare.com/poplicola_jp/checkin/4d6b1bf79f4b6dcba3a86c28?s=1konKLXLyFsLhP2vzPWcgS84wy0
 - http://www.amazon.com/My-World-2-0-Justin-Bieber/dp/B0037AGASG
 - http://www.google.com/buzz/tom.boetig
 - http://www.meetup.com/Massimo-Brunos-Italian-Supper-Club/
