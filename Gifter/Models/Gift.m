//
//  Gift.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "Gift.h"

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
        self.descrip = dictionary[@"productDescription"];
        self.price = dictionary[@"price"];
        
        NSURL *imageUrl = [NSURL URLWithString:dictionary[@"imgUrl"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        // UIImage *image = [UIImage imageWithData:imageData];
        self.image = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    }
    
    return self;
}

@end
