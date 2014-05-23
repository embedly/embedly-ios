//
//  Embedly.h
//  Embedly
//
//  Created by Andrew Pellett on 4/25/14.
//  Copyright (c) 2014 Embedly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 The EmbedlyDelegate protocol delivers responses of the async HTTP calls.
*/
@protocol EmbedlyDelegate <NSObject>

/**
 embedlySuccess is called when the Embedly API successfully returns a response
 
 @param callUrl The full Embedly API call. Useful for caching and debugging.
 @param withResponse The Embedly API response. Can be accessed as an NSDictionary, or NSArray of NSDictionarys in the case of a batch call.
 @param endpoint The Embedly API endpoint used by the API call.
 @param operation Additional information about the HTTP call.
*/
- (void)embedlySuccess:(NSString *)callUrl withResponse:(id)response endpoint:(NSString *)endpoint operation:(AFHTTPRequestOperation *)operation;
/**
 embedlyFailure is called if there is some issue with the Embedly HTTP call
 
 @param callUrl The full Embedly API call. For debugging, try this URL in your browser.
 @param withError The error returned by the HTTP call.
 @param endpoint The Embedly API endpoint used by the API call.
 @param operation Additional information about the HTTP call.
 */
- (void)embedlyFailure:(NSString *)callUrl withError:(NSError *)error endpoint:(NSString *)endpoint operation:(AFHTTPRequestOperation *)operation;

@end

@interface Embedly : NSObject

/**
 Holds the object which implements the EmbedlyDelegate protocol, which receives the responses to API calls.
*/
@property id delegate;

/**
 Your Embedly API key. Get it for free at:
 
 https://app.embed.ly/signup
*/
@property NSString *key;

/**
 Embedly initializer
 
 @param initWithKey Pass in your Embedly API key
 @param delegate An object implementing the EmbedlyDelegate protocol
*/
- (id)initWithKey:(NSString *)key delegate:(id)delegate;

/**
 Call the Embedly Embed API
 
 @param callEmbed the URL to be passed to the Embedly Embed API
 @param params Embedly Embed API parameters. See http://embed.ly/docs/embed/api/arguments
 @param optimizeImages Pass a width in pixels, and all image URLs in the API response will be replaced with Embedly Display URLs to images resized to the given width. Pass 0 to disable this.
*/
- (NSString *)callEmbed:(NSString *)url params:(NSDictionary *)params optimizeImages:(NSInteger)width;

/**
 Call the Embedly Extract API
 
 @param callExtract the URL to be passed to the Embedly Extract API
 @param params Embedly Embed API parameters. See http://embed.ly/docs/extract/api/arguments
 @param optimizeImages Pass a width in pixels, and all image URLs in the API response will be replaced with Embedly Display URLs to images resized to the given width. Pass 0 to disable this.
 */
- (NSString *)callExtract:(NSString *)url params:(NSDictionary *)params optimizeImages:(NSInteger)width;

/**
 A generic function to call any of the Embedly Embed, Extract, or legacy APIs
 
 @param callEmbedlyApi The Embedly API endpoint to use (e.g. /1/oembed, /1/extract)
 @param withUrl The URL to be passed to the Embedly API endpoint
 @param params Arguments to the Embedly API. See http://embed.ly/docs
*/
- (NSString *)callEmbedlyApi:(NSString *)endpoint withUrl:(NSString *)url params:(NSDictionary *)params;

/**
 A generic function to call any of the Embedly Embed, Extract, or legacy APIs with a multiple URLs in one call (batch)
 
 @param callEmbedlyApi The Embedly API endpoint to use (e.g. /1/oembed, /1/extract)
 @param withUrls The URLs to be passed to the Embedly API endpoint. Should be an NSArray of NSStrings.
 @param params Arguments to the Embedly API. See http://embed.ly/docs
 */
- (NSString *)callEmbedlyApi:(NSString *)endpoint withUrls:(NSArray *)urls params:(NSDictionary *)params;


/**
 Builds a URL to a resized version of an image. See:
 
 http://embed.ly/docs/display/api/endpoints/1/display/resize
 
 @param buildResizedImageUrl URL to the original image to be resized
 @param width Width to resize to. Height is scaled to maintain aspect ratio.
*/
- (NSString *)buildResizedImageUrl:(NSString *)url width:(NSInteger)width;

/**
 Builds a URL to a cropped version of an image. See:
 
 http://embed.ly/docs/display/api/endpoints/1/display/crop
 
 @param buildCroppedImageURL URL to the original image to be cropped
 @param width Width of croppped image
 @param height Height of cropped image
*/
- (NSString *)buildCroppedImageUrl:(NSString *)url width:(NSInteger)width height:(NSInteger)height;

/**
 Builds a URL to a manipulated version of an image via any of the Embedly Display endpoints. See:
 
 http://embed.ly/docs/display
 
 @param buildDisplayUrl Embedly Display endpoint to use (e.g. /1/display, /1/display/resize, /1/display/crop)
 @param withUrl URL to the original image to be manipulated
 @param params Embedly Display API parameters. See: http://embed.ly/docs/display
*/
- (NSString *)buildDisplayUrl:(NSString *)endpoint withUrl:(NSString *)url params:(NSDictionary *)params;

@end