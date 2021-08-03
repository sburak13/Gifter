//
//  Holiday.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "Holiday.h"
#import "Person.h"

@implementation Holiday

@dynamic name;
@dynamic recipients;
@dynamic recipientNames;
@dynamic date;
@dynamic totalSpending;
@dynamic dictionary;

+ (nonnull NSString *)parseClassName {
    return @"Holiday";
}

+ (void)createHoliday:(NSString *)name withRecipients:(NSMutableArray *)recipients withRecipientNames:(NSMutableArray*)recipientNames withDate:(NSDate *)date withCompletion:(PFBooleanResultBlock)completion {
    Holiday *newHoliday = [Holiday new];
    newHoliday.name = name;
    newHoliday.recipients = recipients;
    newHoliday.recipientNames = recipientNames;
    newHoliday.date = date;
    newHoliday.dictionary = [[NSMutableDictionary alloc] initWithCapacity:[recipients count]];
    
    for (NSString* personName in recipientNames) {
        [newHoliday.dictionary setObject:[NSMutableArray array] forKey:personName];

    }
    
    [newHoliday saveInBackgroundWithBlock: completion];
}

@end
