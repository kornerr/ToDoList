//
//  XYZChangeGroupViewController.m
//  ToDoList
//
//  Created by Kirill Skulkin on 21.03.14.
//
//

#import "XYZChangeGroupViewController.h"
#import "Groups.h"


@interface XYZChangeGroupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *DoneChangeGroup;
@property (weak, nonatomic) IBOutlet UIPickerView *groupPicker;
@property NSMutableArray *allGroups;

@end

@implementation XYZChangeGroupViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad
{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Groups"];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Groups" inManagedObjectContext: managedObjectContext];
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"groupName"]];
    request.returnsDistinctResults = YES;
    
    self.allGroups = [[managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    [self.groupPicker setDelegate:self];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSString *nameOfGroup;
    nameOfGroup = [[self.allGroups objectAtIndex:row] objectForKey:@"groupName"];

    self.GroupName = nameOfGroup;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allGroups count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [[self.allGroups objectAtIndex:row] objectForKey:@"groupName"];
    return title;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.DoneChangeGroup) return;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
