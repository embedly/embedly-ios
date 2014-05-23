//
//  Embedly.m
//  Embedly
//
//  Created by Andrew Pellett on 4/25/14.
//  Copyright (c) 2014 Embedly. All rights reserved.
//

#import "Embedly.h"

@implementation Embedly

- (id)initWithKey:(NSString *)key delegate:(id)delegate {
    self.key = key;
    self.delegate = delegate;
    
    return self;
}

/* API stuff */

- (NSString *)callEmbed:(NSString *)url params:(NSDictionary *)params optimizeImages:(NSInteger)width {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    if (width > 0) {
        [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)width] forKey:@"image_width"];
    }
    
    return [self fetchEmbedlyApi:@"/1/oembed" withParams:completeParams];
}

- (NSString *)callExtract:(NSString *)url params:(NSDictionary *)params optimizeImages:(NSInteger)width {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    if (width > 0) {
        [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)width] forKey:@"image_width"];
    }
    
    return [self fetchEmbedlyApi:@"/1/extract" withParams:completeParams];
}

- (NSString *)callEmbedlyApi:(NSString *)endpoint withUrl:(NSString *)url params:(NSDictionary *)params {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    
    return [self fetchEmbedlyApi:endpoint withParams:completeParams];
}

- (NSString *)callEmbedlyApi:(NSString *)endpoint withUrls:(NSArray *)urls params:(NSDictionary *)params {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:self.key forKey:@"key"];
    // Using NSArray causes [] to be appended to param name. NSSet avoids this.
    [completeParams setObject:[NSSet setWithArray:urls] forKey:@"urls"];
    
    return [self fetchEmbedlyApi:endpoint withParams:completeParams];
}

/* Display stuff */

- (NSString *)buildCroppedImageUrl:(NSString *)url width:(NSInteger)width height:(NSInteger)height
{
    NSMutableDictionary *completeParams = [[NSMutableDictionary alloc] init];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)width] forKey:@"width"];
    [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)height] forKey:@"height"];
    
    return [self buildEmbedlyUrl:@"/1/display/crop" withParams:completeParams];
}

- (NSString *)buildResizedImageUrl:(NSString *)url width:(NSInteger)width {
    NSMutableDictionary *completeParams = [[NSMutableDictionary alloc] init];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    [completeParams setObject:[NSString stringWithFormat:@"%ld", (long)width] forKey:@"width"];
    
    return [self buildEmbedlyUrl:@"/1/display/resize" withParams:completeParams];
}

- (NSString *)buildDisplayUrl:(NSString *)endpoint withUrl:(NSString *)url params:(NSDictionary *)params {
    NSMutableDictionary *completeParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [completeParams setObject:self.key forKey:@"key"];
    [completeParams setObject:url forKey:@"url"];
    
    return [self buildEmbedlyUrl:endpoint withParams:completeParams];
}

/* Other stuff */

- (NSString *)buildEmbedlyUrl:(NSString *)endpoint withParams:(NSDictionary *)params {
    NSString *embedlyUrl;
    if ([endpoint hasPrefix:@"/1/display"]) {
        embedlyUrl = [NSString stringWithFormat:@"http://i.embed.ly%@", endpoint];
    } else {
        embedlyUrl = [NSString stringWithFormat:@"http://api.embed.ly%@", endpoint];
    }
    
    
    NSString *displayQuery = @"?";
    NSString *param;
    for (id key in params) {
        NSString *paramValue = [params[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([displayQuery length] == 1) {
            displayQuery = [NSString stringWithFormat:@"?%@=%@", key, paramValue];
        } else {
            param = [NSString stringWithFormat:@"&%@=%@", key, paramValue];
            displayQuery = [displayQuery stringByAppendingString:param];
        }
    }
    
    return [NSString stringWithFormat:@"%@%@", embedlyUrl, displayQuery];
}

- (NSString *)fetchEmbedlyApi:(NSString *)endpoint withParams:(NSDictionary *)params {
    NSString *embedlyUrl = [self buildEmbedlyUrl:endpoint withParams:params];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requestSerializer;
    [requestSerializer setValue:@"embedly-ios/1.0" forHTTPHeaderField:@"User-Agent"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:embedlyUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[self delegate] embedlySuccess:embedlyUrl withResponse:responseObject endpoint:endpoint operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[self delegate] embedlyFailure:embedlyUrl withError:error endpoint:endpoint operation:operation];
    }];
    
    return embedlyUrl;
}

@end
