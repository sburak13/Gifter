//
//  APIManager.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "APIManager.h"

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (NSString *)getKey {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"API_KEY"];
    return key;
}

- (void)getSearchResultsFor:(NSString *)keyword completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *headers = @{ @"x-rapidapi-key": [self getKey],
                               @"x-rapidapi-host": @"axesso-axesso-amazon-data-service-v1.p.rapidapi.com" };

    NSString *baseURL = @"https://axesso-axesso-amazon-data-service-v1.p.rapidapi.com/amz/amazon-search-by-keyword-asin?page=1&keyword=";
    NSString *baseURLWithKeyword = [baseURL stringByAppendingString:keyword];
    NSString *requestURL = [baseURLWithKeyword stringByAppendingString: @"&domainCode=com&sortBy=relevanceblender"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        completion(nil, error);
                                                    } else {
                                                        // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        // NSLog(@"%@", httpResponse);
                                                        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        completion(dataDictionary, nil);
                                                    }
                                                }];
    [dataTask resume];
}

@end
