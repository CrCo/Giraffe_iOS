//
//  SearchController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"
#import <Parse/Parse.h>
#import "DateInfoCell.h"

@interface SearchController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSArray *results;

@end

@implementation SearchController
@synthesize tableView, searchTerm, results;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage imageNamed:@"searchbutton"] tag:3];
        self.results = [NSArray array];
        self.searchTerm = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *formattedTerm = [NSString stringWithFormat:@".*%@.*", self.searchTerm];
    
    PFQuery *inTags = [PFQuery queryWithClassName:@"Date"];
    [inTags whereKey:@"themes" matchesRegex:formattedTerm modifiers:@"i"];

    PFQuery *inDescription = [PFQuery queryWithClassName:@"Date"];
    [inDescription whereKey:@"description" matchesRegex:formattedTerm modifiers:@"i"];

    
    [[PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:inTags, inDescription, nil]] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.results = objects;
        [self.tableView reloadData];
    }];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchTerm = searchText;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DateInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResult"];
    cell.date = [self.results objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

@end
