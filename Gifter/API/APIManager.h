//
//  APIManager.h
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)getSearchResultsFor:(NSString *)text completion:(void (^)(NSDictionary *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END
