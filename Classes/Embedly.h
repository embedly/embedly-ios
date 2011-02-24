//
//  Embedly.h
//  Embedly
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EmbedlyDelegate;
//===========================================================
#pragma mark -
#pragma mark Definitions and Types
//===========================================================


#define kEmbedlyLibVersion			@"0.1.0"
#define kEmbedlyApiVersion			@"1"
#define kEmbedlyApiPath				@"api.embed.ly"
#define kEmbedlyProPath				@"pro.embed.ly"


#define kEmbedlyOembedEndpoint		@"oembed"
#define kEmbedlyObjectifyEndpoint	@"objectify"
#define kEmbedlyPreviewEndpoint		@"preview"

#define kEmbedlyDefaultUserAgent	@"Mozilla/5.0 (compatible; embedly-ios/0.1.0;)"
#define kEmbedlyClientHeader		@"Embedly-iOS/0.1.0"

//===========================================================
#pragma mark -
#pragma mark Embedly Interface
//===========================================================

@interface Embedly : NSObject {
	NSString *key;
	NSString *endpoint;
	NSString *path;
	NSString *userAgent;
	NSNumber *maxHeight;
	NSNumber *maxWidth;
	NSURLConnection *connection;
	
	// the delegate
	id<EmbedlyDelegate> delegate;
}

//===========================================================
#pragma mark -
#pragma mark Properties
//===========================================================
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *endpoint;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *userAgent;
@property (nonatomic, retain) NSNumber *maxHeight;
@property (nonatomic, retain) NSNumber *maxWidth;

@property (nonatomic, retain) NSURLConnection *connection;

@property (nonatomic, assign) id<EmbedlyDelegate> delegate;


//===========================================================
#pragma mark -
#pragma mark Class Methods
//===========================================================
+ (Embedly *)sharedInstance;



//===========================================================
#pragma mark -
#pragma mark Instance Methods
//===========================================================
- (void)callWithArray:(NSArray *)urls;
- (void)callWithUrl:(NSString *)url;
- (void)callEmbedlyWithURL:(NSURL *)url;
- (void)stop;

@end


//===========================================================
#pragma mark -
#pragma mark Delegate Protocol
//===========================================================
@protocol EmbedlyDelegate <NSObject>
@optional
// method for accessing Data returned. Response is either Array or Dictionary
- (void)embedlyDidLoad:(id)result;
// pass through for NSURLConnection didReturnData
- (void)embedlyDidReturnRawData:(NSData *)data;
// pass through for NSURLConnection didFailWithError
- (void)embedlyDidFailWithError:(NSError *)error;
// pass through for NSURLConnection didReceiveResponse 
- (void)embedlyDidReceiveResponse:(NSURLResponse *)response;
@end
