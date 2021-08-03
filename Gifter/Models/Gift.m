//
//  Gift.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "Gift.h"
#import "Parse/Parse.h"
#import "APIManager.h"

@implementation Gift

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (apiNum == 1) {
            self.asin = dictionary[@"asin"];
            self.descrip = dictionary[@"title"];
            self.price = [dictionary[@"price"][@"current_price"] doubleValue];
            self.rating = dictionary[@"reviews"][@"rating"];
            
            NSURL *imageUrl = [NSURL URLWithString:dictionary[@"thumbnail"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            self.image = [UIImage imageWithData: imageData];

            self.link = dictionary[@"url"];
            
        } else {
            self.asin = dictionary[@"asin"];
            self.descrip = dictionary[@"productDescription"];
            self.price = [dictionary[@"price"] doubleValue];
            self.rating = dictionary[@"productRating"];
            
            NSURL *imageUrl = [NSURL URLWithString:dictionary[@"imgUrl"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            self.image = [UIImage imageWithData: imageData];

            self.link = [@"https://www.amazon.com/dp/" stringByAppendingString:self.asin];
        }
    }
    
    return self;
}

+ (NSMutableArray *)giftsWithArray:(NSArray *)dictionaries FromInterest:(NSString *)interest{
    
    NSMutableArray *gifts = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        if (dictionary) {
            Gift *gift = [[Gift alloc] initWithDictionary:dictionary];
            gift.ofInterest = interest;
            [gifts addObject:gift];
        }
    }
    
    return gifts;
    
}

@end
