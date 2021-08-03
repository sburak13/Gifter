//
//  Gift.h
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface Gift : NSObject

@property (nonatomic, strong) NSString *asin;
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic) int numInBasket;
@property (nonatomic) double price;
@property (nonatomic, strong) NSString *ofInterest;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)giftsWithArray:(NSArray *)dictionaries FromInterest:(NSString *)interest;

@end

NS_ASSUME_NONNULL_END
