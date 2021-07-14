//
//  ProductStreamViewController.h
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProductStreamViewController : UIViewController

@property (nonatomic, weak) Person *person;

@end

NS_ASSUME_NONNULL_END
