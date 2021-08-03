//
//  SpecificHolidayRecipientCell.h
//  Gifter
//
//  Created by samanthaburak on 8/3/21.
//

#import <UIKit/UIKit.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpecificHolidayRecipientCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recipientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *basketPrice;

// @property (strong, nonatomic) Person *person;
@property (weak, nonatomic) NSString *personName;

@end

NS_ASSUME_NONNULL_END
