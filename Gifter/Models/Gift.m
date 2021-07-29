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

/*
@dynamic asin;
@dynamic descrip;
@dynamic price;
@dynamic image;
@dynamic link;
*/

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (apiNum == 1) {
            self.asin = dictionary[@"asin"];
            // self.descrip = dictionary[@"productDescription"];
            self.descrip = dictionary[@"title"];
            // self.price = dictionary[@"price"];
            self.price = dictionary[@"price"][@"current_price"];
            // self.rating = dictionary[@"productRating"];
            self.rating = dictionary[@"reviews"][@"rating"];
            
            // NSURL *imageUrl = [NSURL URLWithString:dictionary[@"imgUrl"]];
            NSURL *imageUrl = [NSURL URLWithString:dictionary[@"thumbnail"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            self.image = [UIImage imageWithData: imageData];

            self.link = dictionary[@"url"];
        } else {
            // self.asin = dictionary[@"asin"];
            self.descrip = dictionary[@"productDescription"];
            // self.descrip = dictionary[@"title"];
            self.price = dictionary[@"price"];
            // self.price = dictionary[@"price"][@"current_price"];
            self.rating = dictionary[@"productRating"];
            // self.rating = dictionary[@"reviews"][@"rating"];
            
            NSURL *imageUrl = [NSURL URLWithString:dictionary[@"imgUrl"]];
            // NSURL *imageUrl = [NSURL URLWithString:dictionary[@"thumbnail"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            self.image = [UIImage imageWithData: imageData];

            self.link = dictionary[@"url"];
        }
    }
    
    return self;
}

+ (NSMutableArray *)giftsWithArray:(NSArray *)dictionaries {
    
    NSMutableArray *gifts = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        if (dictionary) {
            Gift *gift = [[Gift alloc] initWithDictionary:dictionary];
            [gifts addObject:gift];
        }
    }
    
    return gifts;
    
}

@end
