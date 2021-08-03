//
//  Holiday.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "Holiday.h"

@implementation Holiday

@dynamic name;
@dynamic recipients;
@dynamic date;
@dynamic totalSpending;

+ (nonnull NSString *)parseClassName {
    return @"Holiday";
}

+ (void)createHoliday:(NSString *)name withRecipients:(NSMutableArray *)recipients withDate:(NSDate *)date withCompletion:(PFBooleanResultBlock)completion {
    Holiday *newHoliday = [Holiday new];
    newHoliday.name = name;
    newHoliday.recipients = recipients;
    newHoliday.date = date;
    
    [newHoliday saveInBackgroundWithBlock: completion];
}

@end
