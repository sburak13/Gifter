//
//  HolidayCell.m
//  Gifter
//
//  Created by samanthaburak on 8/2/21.
//

#import "HolidayCell.h"
#import "Person.h"

@implementation HolidayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHoliday:(Holiday *)holiday {
    _holiday = holiday;
    
    self.nameLabel.text = holiday.name;

    self.recipientsLabel.text = [[holiday.recipientNames valueForKey:@"description"] componentsJoinedByString:@", "];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSDate *date = holiday.date;
    self.dateLabel.text = [formatter stringFromDate:date];
}


@end
