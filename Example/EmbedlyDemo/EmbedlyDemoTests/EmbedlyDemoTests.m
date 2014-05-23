//
//  EmbedlyDemoTests.m
//  EmbedlyDemoTests
//
//  Created by Andrew Pellett on 5/19/14.
//  Copyright (c) 2014 Embedly. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Embedly.h>

@interface EmbedlyDispatch : NSObject <EmbedlyDelegate>

@property (copy) void (^handleResponse)(NSInteger responseCode, id response);

- (void)initWithResponder:(void(^)(NSInteger responseCode, id response))responderBlock;

@end

@implementation EmbedlyDispatch

- (void)initWithResponder:(void(^)(NSInteger responseCode, id response))responderBlock
{
    self.handleResponse = responderBlock;
}

- (void)embedlyFailure:(NSString *)callUrl withError:(NSError *)error endpoint:(NSString *)endpoint operation:(id)operation
{
    //XCTFail(@"This shouldn't happen \"%s\"", __PRETTY_FUNCTION__);
}

- (void)embedlySuccess:(NSString *)callUrl withResponse:(id)response endpoint:(NSString *)endpoint operation:(id)operation
{
    self.handleResponse(200, response);
}

@end

@interface EmbedlyDemoTests : XCTestCase

@property EmbedlyDispatch *dis;

@end

@implementation EmbedlyDemoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.dis = [EmbedlyDispatch alloc];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
*/

- (void)testSingleUrl
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *callUrl = [e callEmbedlyApi:@"/1/oembed" withUrl:@"embed.ly" params:nil];
    
    XCTAssertEqualObjects(callUrl,
                          @"http://api.embed.ly/1/oembed?key=mykey&url=embed.ly",
                          "test single url");
    
    /*
    [self.dis initWithResponder:^(NSInteger responseCode, id response) {
        NSLog(@"test got responseCode response %ld, %@", (long)responseCode, response);
    }];
    */
}

- (void)testEmbed
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *callUrl = [e callEmbed:@"embed.ly" params:nil optimizeImages:200];
    
    XCTAssertEqualObjects(callUrl,
                          @"http://api.embed.ly/1/oembed?key=mykey&url=embed.ly&image_width=200",
                          "test embed");
}

- (void)testExtract
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *callUrl = [e callExtract:@"embed.ly" params:nil optimizeImages:200];
    
    XCTAssertEqualObjects(callUrl,
                          @"http://api.embed.ly/1/extract?key=mykey&url=embed.ly&image_width=200",
                          "test embed");
}

- (void)testDisplay
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *call = [e buildDisplayUrl:@"/1/display/resize" withUrl:@"http://embed.ly/static/images/office/DSC_0157.JPG" params:@{@"width": @"200"}];
    
    XCTAssertEqualObjects(call,
                          @"http://i.embed.ly/1/display/resize?width=200&key=mykey&url=http://embed.ly/static/images/office/DSC_0157.JPG",
                          "test display call");
}

- (void)testResize
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *resize = [e buildResizedImageUrl:@"http://embed.ly/static/images/office/DSC_0157.JPG" width:200];
    
    XCTAssertEqualObjects(resize,
                          @"http://i.embed.ly/1/display/resize?key=mykey&url=http://embed.ly/static/images/office/DSC_0157.JPG&width=200",
                          "test resize call");
}

- (void)testParams
{
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self.dis];
    
    NSString *call = [e buildDisplayUrl:@"/1/display/resize" withUrl:@"http://embed.ly/static/images/office/DSC_0157.JPG" params:@{@"width": @"200", @"height": @"200", @"grow": @"false"}];
    
    XCTAssertEqualObjects(call,
                          @"http://i.embed.ly/1/display/resize?width=200&grow=false&key=mykey&url=http://embed.ly/static/images/office/DSC_0157.JPG&height=200",
                          "test params");
}

@end
