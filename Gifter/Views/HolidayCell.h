//
//  HolidayCell.h
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "Holiday.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface HolidayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) Holiday *holiday;

@end

NS_ASSUME_NONNULL_END
