//
//  Holiday.h
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Holiday : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) NSMutableArray *recipientNames;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *totalSpending;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
// dictionary - key: (Person) recipient, (GiftBasket) value - basket

+ (void) createHoliday: ( NSString * _Nullable )name
        withRecipients: ( NSMutableArray * _Nullable )recipients
    withRecipientNames: ( NSMutableArray * _Nullable )recipientNames
              withDate: ( NSDate * _Nullable)date
       withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
