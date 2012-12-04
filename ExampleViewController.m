//
//  DTGridViewExampleDataSourceAndDelegate.m
//  DTKit
//
//  Created by Daniel Tull on 19.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "ExampleViewController.h"
#import "DTGridViewCell.h"

@implementation ExampleViewController

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
		
	// TODO: incorporate this into superclass
	self.gridView.gridDelegate = self;
	self.gridView.dataSource = self;
	self.gridView.bounces = YES;
}

#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Tiled view data source

- (NSInteger)spacingBetweenRowsInGridView:(DTGridView *)gridView {
	return 7;
}

- (NSInteger)spacingBetweenColumnsInGridView:(DTGridView *)gridView {
	return 4;
}
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 25;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index {
	return 25;
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	return 100.0;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return 100.0;
}

- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	DTGridViewCell *view = [[gv dequeueReusableCellWithIdentifier:@"cell"] retain];
	if (!view) {
		view = [[DTGridViewCell alloc] initWithReuseIdentifier:@"cell"];
	}

	float r1 = random() / (float)RAND_MAX;
	float r2 = random() / (float)RAND_MAX;
	float r3 = random() / (float)RAND_MAX;
	
	view.backgroundColor = [UIColor colorWithRed:r1 green:r2 blue:r3 alpha:1.0];

	return [view autorelease];
}
@end
