//
//  Embedly.m
//  Embedly
//
//  Created by Thomas Boetig on 2/16/11.
//  Copyright 2011 tboetig. All rights reserved.
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
@synthesize path;
@synthesize userAgent;
@synthesize connection;
@synthesize delegate;
@synthesize maxWidth, maxHeight;


//===========================================================
#pragma mark -
#pragma mark Lifecycle
//===========================================================

- (id)init {
	self.key = nil;
	self.path = kEmbedlyApiPath;
	self.userAgent = kEmbedlyDefaultUserAgent;
	return self;
}

- (id)initWithKey:(NSString *)k {
	self.key = k;
	if (self.key != nil){
		self.path = kEmbedlyProPath;
	} else {
		self.path = kEmbedlyApiPath;
	}
	
	self.endpoint = kEmbedlyOembedEndpoint;		// standard endpoint, oembed works for API and Pro
	self.userAgent = kEmbedlyDefaultUserAgent;
	
	return self;
}

- (id)initWithKey:(NSString *)k andEndpoint:(NSString *)e {
	self.key = k;
	if (self.key != nil){
		self.path = kEmbedlyProPath;
	} else {
		self.path = kEmbedlyApiPath;
	}
	
	if( self.key == nil){
		self.endpoint = kEmbedlyOembedEndpoint;
	} else {
		self.endpoint = e;
	}
	self.userAgent = kEmbedlyDefaultUserAgent;
	
	return self;
}

- (void)dealloc {
	[key release], key = nil;
	[endpoint release], endpoint = nil;
	[path release], path = nil;
	[userAgent release], userAgent = nil;
	
	delegate = nil;
	[super dealloc];
}

//===========================================================
#pragma mark -
#pragma mark API Access
//===========================================================

// Call the Embedly API with One URL. Will return a Dictionary
- (void)callWithUrl:(NSString *)url {
	NSString* request = [[NSString alloc] initWithFormat:@"http://%@/%@/%@?mobile=true&url=%@", self.path, kEmbedlyApiVersion, self.endpoint, url];
	if( self.key != nil){
		request = [request stringByAppendingFormat:@"&key=%@", self.key];
	}
	if (self.maxWidth != nil){
		request = [request stringByAppendingFormat:@"&maxwidth=%@", self.maxWidth];
	}
	if (self.maxHeight != nil){
		request = [request stringByAppendingFormat:@"@maxheight=%@", self.maxHeight];
	}
	
	NSURL* u = [[NSURL alloc] initWithString:request];
	[self callEmbedlyWithURL:u];
}

// Call the Embedly API with Multiple URLs. Will return an Array of Dictionaries
- (void)callWithArray:(NSArray *)urls {
	NSString* set = [[NSString alloc] initWithString:@""];
	for( NSString *s in urls){
		set = [set stringByAppendingString:@","];
		set = [set stringByAppendingString:s];
	}
	set = [set substringFromIndex:1];	// remove the initial , from the url string
	
	NSString* request = [[NSString alloc] initWithFormat:@"http://%@/%@/%@?mobile=true&urls=%@", self.path, kEmbedlyApiVersion, self.endpoint, set];
	
	if( self.key != nil){
		request = [request stringByAppendingFormat:@"&key=%@", self.key];
	}
	if (self.maxWidth != nil){
		request = [request stringByAppendingFormat:@"&maxwidth=%@", self.maxWidth];
	}
	if (self.maxHeight != nil){
		request = [request stringByAppendingFormat:@"@maxheight=%@", self.maxHeight];
	}
	
	
	NSURL* u = [[NSURL alloc] initWithString:request];
	[self callEmbedlyWithURL:u];
}

- (void) callEmbedlyWithURL:(NSURL *)url{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
	[request addValue:kEmbedlyClientHeader forHTTPHeaderField:@"X-Embedly-Client"];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


// Cancel a URLConnection
- (void)stop {
	[[self connection] cancel];
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
	// Push raw data to delegate
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidReturnRawData:)]) {
		[self.delegate embedlyDidReturnRawData:data];
	}
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	id result = [parser objectWithData:data];
	
	// Push NSArray or NSDictionary object to delegate
	if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(embedlyDidLoad:)]) {
		[self.delegate embedlyDidLoad:result];
	}
	
	[parser release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
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
