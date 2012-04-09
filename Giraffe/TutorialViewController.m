//
//  TutorialViewController.m
//  Giraffe
//
//  Created by Stephen Visser on 12-03-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialViewController.h"

#define CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(child, index) child.frame = CGRectApplyAffineTransform(child.frame, CGAffineTransformMakeTranslation(CGRectGetWidth(child.superview.bounds) * index + (CGRectGetWidth(child.superview.bounds) - CGRectGetWidth(child.frame)) / 2, (CGRectGetHeight(child.superview.bounds) - CGRectGetHeight(child.frame)) / 2))


@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TutorialViewController

@synthesize pageControl;
@synthesize scrollView = _scrollView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *content1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content1"]];
    UIImageView *content2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content2"]];
    UIImageView *content3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content3"]];
    UIImageView *content4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content4"]];
    UIImageView *content5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content5"]];
        
    [self.scrollView addSubview:content1];
    [self.scrollView addSubview:content2];
    [self.scrollView addSubview:content3];
    [self.scrollView addSubview:content4];
    [self.scrollView addSubview:content5];
    
    CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(content1, 0);
    CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(content2, 1);
    CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(content3, 2);
    CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(content4, 3);
    CENTER_FRAME_IN_PARENT_WITH_MULTIPLE(content5, 4);
    
    self.scrollView.contentSize = CGSizeApplyAffineTransform(self.scrollView.bounds.size, CGAffineTransformMakeScale(5, 1));
}

- (void)viewDidUnload
{
    [self setPageControl:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = roundl(scrollView.contentOffset.x /scrollView.bounds.size.width);
}

@end
