//
//  AddHolidayViewController.m
//  Gifter
//
//  Created by samanthaburak on 8/3/21.
//

#import "AddHolidayViewController.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import <Parse/Parse.h>
#import "Person.h"

@interface AddHolidayViewController () <CCDropDownMenuDelegate>

@property (nonatomic) NSArray *peopleArray;
@property (nonatomic) ManaDropDownMenu *menu;
@property (nonatomic) int currentlySelectedPersonIndex;

@end

@implementation AddHolidayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menu = [[ManaDropDownMenu alloc] initWithFrame:CGRectMake(self.placeholderMenuView.frame.origin.x, self.placeholderMenuView.frame.origin.y, self.placeholderMenuView.frame.size.width, self.placeholderMenuView.frame.size.height) title:@"Menu"];
    self.menu.delegate = self;
    [self getPeople];
}

- (void)getPeople {
    PFQuery *personQuery = [Person query];
    [personQuery orderByDescending:@"createdAt"];
    personQuery.limit = 20;

    [personQuery findObjectsInBackgroundWithBlock:^(NSArray<Person *> * _Nullable people, NSError * _Nullable error) {
        if (people) {
            self.peopleArray = people;
            self.menu.numberOfRows = people.count;
            self.menu.textOfRows = [self getArrayOfNames:people];
            [self.view addSubview:self.menu];
        }
        else {
            NSLog(@"Error getting people%@", error.localizedDescription);
        }
    }];
}

-(NSArray*)getArrayOfNames:(NSArray*)people{
    NSMutableArray* names = [NSMutableArray array];
    for (Person* person in people) {
        [names addObject:person.name];
    }
    return names;
}

- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    self.currentlySelectedPersonIndex = index;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
