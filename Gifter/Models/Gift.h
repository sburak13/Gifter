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

@interface Gift : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *asin;
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) PFFileObject *image;
// @property (nonatomic, strong) NSString *link;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)giftsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
