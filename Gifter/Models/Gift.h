//
//  Gift.h
//  Gifter
//
//  Created by samanthaburak on 7/15/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Gift : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *link;

@end

NS_ASSUME_NONNULL_END
