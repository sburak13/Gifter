//
//  PersonCell.h
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

@property (strong, nonatomic) Person *person;

@end

NS_ASSUME_NONNULL_END
