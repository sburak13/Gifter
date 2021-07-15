//
//  Gift.m
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import "Gift.h"

@implementation Gift

@dynamic description;
@dynamic price;
@dynamic image;
@dynamic link;

+ (nonnull NSString *)parseClassName {
    return @"Gift";
}

@end
