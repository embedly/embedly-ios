//
//  edemViewController.m
//  EmbedlyDemo
//
//  Created by Andrew Pellett on 5/19/14.
//  Copyright (c) 2014 Embedly. All rights reserved.
//

#import "edemViewController.h"
#import <Embedly.h>

@interface edemViewController ()

@end

@implementation edemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlField.text = @"embed.ly";
    [self urlChanged:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)urlChanged:(id)sender {
    NSLog(@"url changed %@", self.urlField.text);
    self.urlResponse.text = self.urlField.text;
    [self.urlField endEditing:true];
    [self.optimizeImagesField endEditing:true];
    
    NSInteger endpointIndex = self.endpointChooser.selectedSegmentIndex;
    NSString *endpoint;
    if (endpointIndex == 0) {
        endpoint = @"/1/oembed";
    } else {
        endpoint = @"/1/extract";
    }
    
    Embedly *e = [[Embedly alloc] initWithKey:@"mykey" delegate:self];

    if ([self.optimizeImagesField.text isEqual:@"0"]) {
        [e callEmbedlyApi:endpoint withUrl:self.urlField.text params:nil];
    } else {
        [e callEmbedlyApi:endpoint withUrl:self.urlField.text params:@{@"image_width": self.optimizeImagesField.text}];
    }
}

- (void)embedlyFailure:(NSString *)callUrl withError:(NSError *)error endpoint:(NSString *)endpoint operation:(AFHTTPRequestOperation *)operation {
    NSLog(@"embedly failure %@", callUrl);
}

- (void)embedlySuccess:(NSString *)callUrl withResponse:(id)response endpoint:(NSString *)endpoint operation:(AFHTTPRequestOperation *)operation {
    NSLog(@"embedly success %@, %@", callUrl, [response description]);
    self.urlResponse.text = [response description];
    self.urlTitle.text = [response objectForKey:@"title"];
    self.urlProvider.text = [response objectForKey:@"provider_name"];
}
@end
