// Copyright 2011 Embed.ly, Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
 
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  Embedly.h
//  Embedly
//
//  Created by Thomas Boetig on 2/16/11.
//

#import <Foundation/Foundation.h>


@protocol EmbedlyDelegate;
//===========================================================
#pragma mark -
#pragma mark Definitions and Types
//===========================================================


#define kEmbedlyLibVersion			@"0.1.0"
#define kEmbedlyApiPath				@"api.embed.ly"
#define kEmbedlyProPath				@"pro.embed.ly"


#define kEmbedlyOembedEndpoint		@"1/oembed"
#define kEmbedlyObjectifyEndpoint	@"2/objectify"
#define kEmbedlyPreviewEndpoint		@"1/preview"

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
    NSMutableData *returnedData;
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
@property (nonatomic, retain) NSMutableData *returnedData;

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
- (id)initWithKey:(NSString *)k;
- (id)initWithKey:(NSString *)k andEndpoint:(NSString *)e;
- (NSString *)escapeUrlWithString:(NSString *)path;
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
