//
//  ViewController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenController.h"
#import <QuartzCore/QuartzCore.h>
#import "RotatingWheel.h"
#import <Parse/Parse.h>
#import "GFNavView.h"
#import "DateInfoCell.h"
#import "DetailedDateController.h"
#import "Giraffe.h"

@interface MainScreenController ()

@property (strong, nonatomic) NSArray *listOfDates;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation MainScreenController
@synthesize tableView;
@synthesize spinner;

@synthesize needsLogin, listOfDates=_listOfDates;

CFTimeInterval lastTime;
CGPoint lastPoint;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _listOfDates = [[NSArray alloc] init];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Something" image:[UIImage imageNamed:@"PopularDates"] tag:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDate:) name: GFCreatedDate object:nil];
    }   
    return self;
}

- (void) addDate: (id) sender
{
    [self updateDates];
}

- (void) search: (id) sender
{
    
}

- (void) updateDates
{
    self.tableView.hidden = YES;
    [self.spinner startAnimating];
    [[PFQuery queryWithClassName:@"Date"] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.listOfDates = objects;
    }];
}

- (void)setListOfDates:(NSArray *)listOfDates
{
    _listOfDates = listOfDates;
    [self.spinner stopAnimating];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateDates];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopBarWShadow"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBarLogo"]];
    
    if (![PFUser currentUser])
    {
        UIViewController *tutorial = [[UIStoryboard storyboardWithName:@"Tutorial" bundle:nil] instantiateInitialViewController];
        [self presentViewController:tutorial animated:NO completion:nil];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listOfDates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.listOfDates objectAtIndex:indexPath.row];
    
    DateInfoCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.date = object;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((DetailedDateController *)segue.destinationViewController).date = [self.listOfDates objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    [self.tableView cellForRowAtIndexPath: self.tableView.indexPathForSelectedRow].selected = NO;
}

@end
