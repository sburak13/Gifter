//
//  GiftBasketsViewController.h
//  Gifter
//
//  Created by samanthaburak on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftBasketsViewController : UIViewController

@property (nonatomic, weak) Person *person;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsViewHeight;

@end

NS_ASSUME_NONNULL_END
