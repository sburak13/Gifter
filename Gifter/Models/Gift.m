//
//  Gift.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "Gift.h"
#import "Parse/Parse.h"

@implementation Gift

@dynamic asin;
@dynamic descrip;
@dynamic price;
@dynamic image;
// @dynamic link;

+ (nonnull NSString *)parseClassName {
    return @"Gift";
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.asin = dictionary[@"asin"];
        self.descrip = dictionary[@"title"];
        self.price = dictionary[@"price"][@"current_price"];
        
        NSURL *imageUrl = [NSURL URLWithString:dictionary[@"thumbnail"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        // UIImage *image = [UIImage imageWithData:imageData];
        self.image = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
