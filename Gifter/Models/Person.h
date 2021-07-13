//
//  Person.h
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *interests;

+ (void) createPerson: ( NSString * _Nullable )name
        withInterests: ( NSMutableArray * _Nullable )interests
       withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
