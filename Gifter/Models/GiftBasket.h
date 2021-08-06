//
//  GiftBasket.h
//  Gifter
//
//  Created by samanthaburak on 7/20/21.
//

#import <Foundation/Foundation.h>
#import "Gift.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftBasket : NSObject

@property (nonatomic) int numItems;
@property (nonatomic) double totalPrice;
@property (strong, nonatomic) NSMutableArray *gifts;
@property (strong, nonatomic) NSString *giftNames;
// @property bought

- (instancetype)init:(NSMutableArray*)gifts;

@end

NS_ASSUME_NONNULL_END
