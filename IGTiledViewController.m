//
//  TiledExampleViewController.m
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IGTiledViewController.h"

@implementation IGTiledViewController
@synthesize tiledView;

#pragma mark -
#pragma mark Memory management

-(void)dealloc {
	self.tiledView = nil;
	[tiles release];
    [super dealloc];
}

-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	[tiledView releaseUnusedTiles];
}

#pragma mark -
#pragma mark View lifecycle

-(void)viewDidLoad {
	[tiles release];
	tiles = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",
			 @"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",
			 @"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",
			 @"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",
			 @"48",@"49",nil];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
	
	// Create and configure the tiled view
	IGTiledView *aTiledView = [[IGTiledView alloc] initWithFrame:self.view.bounds dataSource:self];
	aTiledView.tiledViewDelegate = self;
	self.tiledView = aTiledView;
	[aTiledView release];
	
	tiledView.autoresizingMask = self.view.autoresizingMask;
	[self.view addSubview:tiledView];
	
	// background color
	self.view.backgroundColor = [UIColor whiteColor];
	
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

-(void)viewDidUnload {
	self.tiledView = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[tiledView willRotate];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[tiledView didRotate];
}


#pragma mark -
#pragma mark Tiled view data source

-(CGSize)tileSize:(IGTiledView *)tiledView {
	return CGSizeMake(300, 200);
}

-(int)tileCount:(IGTiledView *)tiledView {
	return [tiles count];
}

-(IGTile *)tiledView:(IGTiledView *)aTiledView tileAtIndex:(int)index {
	IGTile *tile = [aTiledView tileFromReuseQueue];
	if(!tile)
		tile = [[IGTile alloc] initWithFrame:[aTiledView newTileFrame]];
	
	srand((unsigned)[[tiles objectAtIndex:index] intValue]);
	tile.backgroundColor = [UIColor colorWithRed:rand()/((float)(RAND_MAX)) green:rand()/((float)(RAND_MAX)) blue:rand()/((float)(RAND_MAX)) alpha:1.000];
	
	for(UIView *subview in [tile subviews])
		[subview removeFromSuperview];
	
	UILabel *title = [[UILabel alloc] initWithFrame:tile.bounds];	
	title.text = [NSString stringWithFormat:@"Tile %@",[tiles objectAtIndex:index]];
	title.opaque = NO;
	title.backgroundColor = [UIColor clearColor];
	[tile addSubview:title];
	[title release];
	
	return tile;
}

#pragma mark -
#pragma mark Tiled view delegate

-(void)tiledView:(IGTiledView *)aTiledView didSelectTileAtIndex:(int)index {
	[tiledView removeTileAtIndexAnimated:index];
	[tiles removeObjectAtIndex:index];
}

@end
