//
//  GiftBasket.m
//  Gifter
//
//  Created by samanthaburak on 7/20/21.
//

#import "GiftBasket.h"
#import "Gift.h"
#import <math.h>

@implementation GiftBasket

- (instancetype)init:(NSMutableArray*)gifts {
    self = [super init];
    
    if (self) {
        self.gifts = gifts; // [NSMutableArray array];
        self.numItems = gifts.count;
        self.totalPrice = 0;
        
        for (Gift* gift in gifts) {
            self.totalPrice += gift.price; // [gift.price doubleValue];
        }

    }
    
    return self;
}

@end
