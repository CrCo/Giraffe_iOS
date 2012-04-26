//
//  ProfileController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import <Parse/Parse.h>
#import "MyDateCell.h"
#import "Giraffe.h"

@interface ProfileController ()
{
    NSMutableDictionary *queryResults;
    NSString *selectedQuery;
}
  
@property (weak, nonatomic) IBOutlet ProfileHeaderView *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileController
@synthesize header;
@synthesize tableView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        queryResults = [NSMutableDictionary dictionaryWithCapacity:4];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"ProfileButton"] tag:2];
        
        //When a new date is created, we should update our dates page so this newest date
        //is reflected
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDate:) name: GFCreatedDate object:nil];
    }
    return self;
}

- (void) addDate: (id) sender
{
    PFQuery *dates = [PFQuery queryWithClassName:@"Date"];
    [dates whereKey:@"user" equalTo:[PFUser currentUser]];
    [dates findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [queryResults setObject:objects forKey:@"dates"];
        [self.header setNumber:[objects count] forHeader:@"dates"];
        //If we are currently displaying the dates, we should reload the table
        if ([selectedQuery isEqualToString:@"dates"])
        {
            [self.tableView reloadData];
        }
    }];
}

- (void)didPressButton:(NSString *)title
{
    [self.header selectHeader:title];
    selectedQuery = title;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{    
    self.header.delegate = self;
    [self.header addHeader:@"dates"];
    [self.header addHeader:@"herd"];
    [self.header addHeader:@"news"];
    [self.header addHeader:@"liked"];
    
    PFQuery *dates = [PFQuery queryWithClassName:@"Date"];
    [dates whereKey:@"user" equalTo:[PFUser currentUser]];
    [dates findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [queryResults setObject:objects forKey:@"dates"];
        [self.header setNumber:[objects count] forHeader:@"dates"];
        selectedQuery = @"dates";
        [self.tableView reloadData];
        [self.header selectHeader:@"dates"];
    }];
    
    NSArray *following = [[PFUser currentUser] objectForKey:@"following"];
    if (following)
    {
        [queryResults setObject:following forKey:@"herd"];
        [self.header setNumber:[following count] forHeader:@"herd"];
    }
    
    PFQuery *news = [PFQuery queryWithClassName:@"NewsItem"];
    [news findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [queryResults setObject:objects forKey:@"news"];
        [self.header setNumber:[objects count] forHeader:@"news"];
    }];

    NSArray *likes = [[PFUser currentUser] objectForKey:@"likes"];
    if (!likes)
    {
        likes = [NSArray array];
    }
    [queryResults setObject:likes forKey:@"liked"];
    [self.header setNumber:[likes count] forHeader:@"liked"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopBarLogo"]];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setHeader:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedQuery)
    {
        NSArray *objects = [queryResults objectForKey:selectedQuery];
        if (objects)
        {
            return [objects count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedQuery isEqualToString:@"dates"])
    {
        MyDateCell *cell = [self.tableView dequeueReusableCellWithIdentifier:selectedQuery];
        NSArray *allDates = [queryResults objectForKey:selectedQuery];
        cell.date = [allDates objectAtIndex:indexPath.row];
        return cell;        
    }
    else if ([selectedQuery isEqualToString:@"liked"])
    {
        MyDateCell *cell = [self.tableView dequeueReusableCellWithIdentifier:selectedQuery];
        NSArray *allDates = [queryResults objectForKey:selectedQuery];
        cell.date = [allDates objectAtIndex:indexPath.row];
        return cell;        
    }
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
