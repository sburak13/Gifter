//
//  GiftBasketDetailsViewController.h
//  Gifter
//
//  Created by samanthaburak on 7/28/21.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "GiftBasket.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftBasketDetailsViewController : UIViewController

@property (nonatomic, weak) GiftBasket *basket;
@property (nonatomic, weak) Person *person;

@end

NS_ASSUME_NONNULL_END
