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
//  Embedly.m
//  Embedly
//
//  Created by Thomas Boetig on 2/16/11.
//

#import "Embedly.h"
#import "JSON.h"

@implementation Embedly
//===========================================================
#pragma mark -
#pragma mark Synthesizing
//===========================================================
@synthesize key;
@synthesize endpoint;
@synthesize userAgent;
@synthesize con;
@synthesize returnedData;
@synthesize delegate;
@synthesize maxWidth, maxHeight;


//===========================================================
#pragma mark -
#pragma mark Lifecycle
//===========================================================

- (id)init {
	self.key = nil;
	self.userAgent = kEmbedlyDefaultUserAgent;
    self.returnedData = [[NSMutableData alloc] init];
	return self;
}

- (id)initWithKey:(NSString *)k {
	self.key = k;
	
	self.endpoint = kEmbedlyOembedEndpoint;		// standard endpoint, oembed works for API and Pro
	self.userAgent = kEmbedlyDefaultUserAgent;
    
    
    self.returnedData = [[NSMutableData alloc] init];
	
	return self;
}

- (id)initWithKey:(NSString *)k andEndpoint:(NSString *)e {
	self.key = k;
	
	if( self.key == nil){
		self.endpoint = kEmbedlyOembedEndpoint;
	} else {
		self.endpoint = e;
	}
	self.userAgent = kEmbedlyDefaultUserAgent;
    
    self.returnedData = [[NSMutableData alloc] init];
	
	return self;
}

- (void)dealloc {
	[key release], key = nil;
	[endpoint release], endpoint = nil;
	[userAgent release], userAgent = nil;
	
	delegate = nil;
	[super dealloc];
}

- (NSString *)escapeUrlWithString:(NSString *)string {
    return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

//===========================================================
#pragma mark -
#pragma mark API Access
//===========================================================

// Call the Embedly API with One URL. Will return a Dictionary
- (void)callWithUrl:(NSString *)url {
    
    url = [self escapeUrlWithString:url];
    
	NSString* request = [[[NSString alloc] initWithFormat:@"http://%@/%@?&url=%@", kEmbedlyProPath, self.endpoint, url] autorelease];
    if( self.key != nil){
		request = [request stringByAppendingFormat:@"&key=%@", self.key];
	}
	if (self.maxWidth != nil){
		request = [request stringByAppendingFormat:@"&maxwidth=%@", self.maxWidth];
	}
	if (self.maxHeight != nil){
		request = [request stringByAppendingFormat:@"&maxheight=%@", self.maxHeight];
	}
	
	NSURL* u = [[NSURL alloc] initWithString:request];
    [self callEmbedlyWithURL:u];
	[u release];
}

// Call the Embedly API with Multiple URLs. Will return an Array of Dictionaries
- (void)callWithArray:(NSArray *)urls {
	NSString* set = [[[NSString alloc] initWithString:@""] autorelease];
	for( NSString *s in urls){
		set = [set stringByAppendingString:@","];
		set = [set stringByAppendingString: [self escapeUrlWithString:s]];
	}
	set = [set substringFromIndex:1];	// remove the initial , from the url string
	
	NSString* request = [[[NSString alloc] initWithFormat:@"http://%@/%@?&urls=%@", kEmbedlyProPath, self.endpoint, set] autorelease];
	
	if( self.key != nil){
		request = [request stringByAppendingFormat:@"&key=%@", self.key];
	}
	if (self.maxWidth != nil){
		request = [request stringByAppendingFormat:@"&maxwidth=%@", self.maxWidth];
	}
	if (self.maxHeight != nil){
		request = [request stringByAppendingFormat:@"&maxheight=%@", self.maxHeight];
	}
	
	
	NSURL* u = [[NSURL alloc] initWithString:request];
	[self callEmbedlyWithURL:u];
	[u release];
}

- (void) callEmbedlyWithURL:(NSURL *)url{
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
	[request addValue:kEmbedlyClientHeader forHTTPHeaderField:@"X-Embedly-Client"];
	NSURLConnection *c = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.con = c;
	[c release];
}


// Cancel a URLConnection
- (void)stop {
	[[self con] cancel];
    self.returnedData = nil;
}



//===========================================================
#pragma mark -
#pragma mark NSURLConnection Delegate Methods
//===========================================================

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidFailWithError:)]) {
		[self.delegate embedlyDidFailWithError:error];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // concatenate data returned until all data is received
    [self.returnedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // return the raw data if a developer wants that instead of a json object
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidReturnRawData:)]){
        [self.delegate embedlyDidReturnRawData:[self returnedData]];
    }
    
    // return parsed JSON as NSArray or NSDictionary
    SBJsonParser *parser = [[SBJsonParser alloc] init];
	id result = [parser objectWithData:self.returnedData];
    
    
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidLoad:)]) {
		[self.delegate embedlyDidLoad:result];
	}
    
    [parser release];
    [self.returnedData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    int statusCode = [(NSHTTPURLResponse *)response statusCode];
    if (statusCode >= 400){
        [connection cancel];
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:NSLocalizedString(@"Server returned status code: %d",@""), statusCode] 
                                                              forKey:NSLocalizedDescriptionKey];
        
        NSError *statusError = [NSError errorWithDomain:kEmbedlyProPath
                                                   code:statusCode
                                               userInfo:errorInfo]; 
        
        [self connection:con didFailWithError:statusError];
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidReceiveResponse:)]) {
		[self.delegate embedlyDidReceiveResponse:response];
	}
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	return request;
}


//===========================================================
#pragma mark -
#pragma mark Singleton definitons
//===========================================================

static Embedly *sharedEmbedly = nil;

+ (Embedly *)sharedInstance {
	@synchronized(self) {
		if(sharedEmbedly == nil) {
			sharedEmbedly = [[self alloc] init];
		}
	}
	
	return sharedEmbedly;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self){
		if(sharedEmbedly == nil){
			sharedEmbedly = [super allocWithZone:zone];
		}
	}
	return sharedEmbedly;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (id)autorelease {
	return self;
}

@end
