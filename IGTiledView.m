//
//  IGTiledView.m
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IGTiledView.h"
#import "IGTile.h"

#define SELECTION_OVERLAY_TAG 38491

@interface IGTiledView ()
-(void)updateContentSize;
-(int)tilesPerRow;
-(int)rowCount;
-(int)topRow;

-(void)layoutTiles;

-(IGTile *)tileAtIndex:(int)index;

@end

@implementation IGTiledView
@synthesize dataSource, tiledViewDelegate, verticalTilePadding;

#pragma mark -
#pragma mark Init and Dealloc

-(void)dealloc {
	[reloadDataTimer release];
	[tiles release];
	[reuseQueue release];
	[super dealloc];
}

-(id)initWithFrame:(CGRect)frame dataSource:(NSObject<IGTiledViewDataSource> *)aDataSource {
	if(self = [super initWithFrame:frame]) {
		self.dataSource = aDataSource;
		self.delegate = self; // scroll view delegate
		
		self.delaysContentTouches = NO;
		
		tiles = [[NSMutableDictionary alloc] initWithCapacity:50];
		reuseQueue = [[NSMutableArray alloc] initWithCapacity:10];
		verticalTilePadding = 50.0f;
		
		[self reloadData];
		[self updateContentSize];
		[self layoutTiles];
	}
	return self;
}

#pragma mark -
#pragma mark Layout helper methods

// updates the scroll view's content size
-(void)updateContentSize {
	float height = ((tileSize.height + verticalTilePadding)*[self rowCount]) + verticalTilePadding;
	self.contentSize = CGSizeMake(self.bounds.size.width, height);
}

// how many tiles can fit on one row at the current sizes.
-(int)tilesPerRow {
	return self.bounds.size.width / tileSize.width;
}

// the total number of rows in this tiled view
-(int)rowCount {
	return (int)ceil( (float)tileCount/(float)[self tilesPerRow] );
}

// the topmost row visble at the moment
-(int)topRow {
	int currentRow = (self.contentOffset.y-verticalTilePadding) / (tileSize.height+verticalTilePadding); // the first row that needs to be drawn
	if(currentRow < 0)
		currentRow = 0;
	return currentRow;
}

#pragma mark -
#pragma mark Laying out the tiles

// lays out all the tiles. this is called *all the time* as the user scrolls, so don't do anything slow here.
-(void)layoutTiles {
	// first, remove all existing tiles!
	for(UIView *subview in self.subviews)
		if([subview isKindOfClass:[IGTile class]])
			[subview removeFromSuperview];
	
	// so here's how this bit works: we set an X and Y offset, and a row number. as we add tiles,
	// we increment the Y offset until it rolls off the screen. then we stop.
	
	int tilesPerRow = [self tilesPerRow];
	int scrollOffset = self.contentOffset.y;
	
	int currentRow = [self topRow];
	
	int currentYOffset = ((currentRow * (tileSize.height+verticalTilePadding)) - scrollOffset) + verticalTilePadding; // where to start laying out tiles
	int currentXOffset = 0;
	
	// padding between cells
	int tilesWidth = [self tilesPerRow]*tileSize.width;
	int cellHorizontalPadding = (self.bounds.size.width - tilesWidth)/(tilesPerRow+1);
	
	// this is to keep a collection of tiles that don't get rendered. these will be added to the reuse queue.
	NSMutableDictionary *tilesCopy = [tiles mutableCopy];
	
	while(currentYOffset <= self.bounds.size.height) {
		currentXOffset += cellHorizontalPadding; // absolute leftmost padding
		
		for(int i=0;i<[self tilesPerRow];i++) {
		
			int currentTileIndex = (currentRow * tilesPerRow) + i; 
			if(currentTileIndex > tileCount-1)
				break;
			
			IGTile *tile = [self tileAtIndex:currentTileIndex];
			tile.frame = CGRectMake(currentXOffset, currentYOffset+scrollOffset, tileSize.width, tileSize.height);
			
			[self insertSubview:tile atIndex:0];
			
			currentXOffset += tileSize.width;
			currentXOffset += cellHorizontalPadding; // padding to the right of each cell
			
			[tilesCopy removeObjectForKey:[NSString stringWithFormat:@"%i",currentTileIndex]];
		}
		currentRow += 1;
		currentYOffset += tileSize.height + verticalTilePadding;
		currentXOffset = 0;
	}
	
	// add the unrendered tiles to the reuse queue
	for(NSString *key in tilesCopy) {
		[tiles removeObjectForKey:key];
		
		IGTile *tile = [tilesCopy objectForKey:key];
		[reuseQueue addObject:tile];
	}
	[tilesCopy release];
}

#pragma mark -
#pragma mark Adding and removing tiles

-(void)removeTileAtIndexAnimated:(int)index {
	float firstAnimationDuration = 0.3f; // used in a few places in this method
	float secondAnimationDuration = 0.3f; // ditto.

	IGTile *tile = [self tileAtIndex:index];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:secondAnimationDuration];
	[UIView setAnimationDelay:firstAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	int maxIndex = -1;
	for(NSString *key in tiles) {
		int index = [key intValue];
		if(maxIndex < index)
			maxIndex = index;
	}
	
	// move each tile after the removed tile to the frame of the previous tile
	for(int i=maxIndex;i>index;i--) {
		IGTile *nextTile = [self tileAtIndex:i];
		IGTile *prevTile = [self tileAtIndex:i-1];
		nextTile.frame = (i-1 == index ? tile.frame : prevTile.frame);
	}
	
	[UIView commitAnimations];
	
	// now, animate the actual tile removal
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:firstAnimationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	NSLog(@"%f",tile.frame.size.width);
	tile.frame = CGRectMake(tile.frame.origin.x-(tile.frame.size.width/2.0f), tile.frame.origin.y-(tile.frame.size.height/2.0f), tile.frame.size.width, tile.frame.size.height);
	tile.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
	tile.alpha = 0.0f;
	
	[UIView commitAnimations];
	
	if(reloadDataTimer) {
		// reset the pause until reloading
		[reloadDataTimer invalidate];
		[reloadDataTimer release];
		reloadDataTimer = nil;
	}
	reloadDataTimer = [[NSTimer scheduledTimerWithTimeInterval:(firstAnimationDuration+secondAnimationDuration)
													   target:self
													 selector:@selector(reloadData) 
													 userInfo:nil 
													  repeats:NO] retain];	
}

#pragma mark -
#pragma mark Data source methods

-(IGTile *)tileAtIndex:(int)index {
	NSString *key = [NSString stringWithFormat:@"%i",index];
	IGTile *tile = [tiles objectForKey:key];
	if(!tile) {
		tile = [dataSource tiledView:self tileAtIndex:index];
		[tiles setObject:tile forKey:key];
	}
	
	// tile configuration
	tile.tiledView = self;

	return tile;
}

// every new tile should have this frame.
-(CGRect)newTileFrame {
	return CGRectMake(0, 0, tileSize.width, tileSize.height);
}

// returns a tile from the reuse queue, or creates a new one
-(IGTile *)tileFromReuseQueue {
	if([reuseQueue count]>0) {
		// the last reference will be in reuseQueue, so we should retain it for now
		IGTile *tile = [[reuseQueue lastObject] retain];
		[reuseQueue removeLastObject];
		
		[tile reset];
		return [tile autorelease]; 
	}
	return nil;
}

// reload all data from scratch
-(void)reloadData {
	tileSize = [dataSource tileSize:self];
	tileCount = [dataSource tileCount:self];
	[tiles removeAllObjects];
	
	[self layoutTiles];
}

#pragma mark -
#pragma mark Scroll view delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self layoutTiles];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	isScrolling = YES;
	
	// I don't think this is really needed. If scrolling bugs pop up, try uncommenting.
	// for(NSString *key in tiles) {
	//	[(IGTile *)[tiles objectForKey:key] hideOverlay];
	// }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	isScrolling = NO;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *superHitTest = [super hitTest:point withEvent:event];
	if(isScrolling)
		return self; // prevents tiles from being selected while scroling
	else
		return superHitTest;
}

#pragma mark -
#pragma mark Rotation

// should be called before auto-rotating.
-(void)willRotate {
	oldTopIndex = [self topRow]*[self tilesPerRow];
}

// should be called after auto-rotating.
-(void)didRotate {
	int newTopRow = oldTopIndex/[self tilesPerRow];
	int offset = (newTopRow * (tileSize.height+verticalTilePadding)) + verticalTilePadding;
	[self setContentOffset:CGPointMake(0, offset) animated:YES];
}

#pragma mark -
#pragma mark Miscellaneous

// handles tile touches by sending a message to the delegate. don't call this directly.
-(void)tileTouched:(IGTile *)tile {
	
	int index = -1;
	for(NSString *key in tiles) {
		if([tiles objectForKey:key] == tile)
			index = [key intValue];
	}
	
	if([tiledViewDelegate respondsToSelector:@selector(tiledView:didSelectTileAtIndex:)])
		[tiledViewDelegate tiledView:self didSelectTileAtIndex:index];
}

// removes all cached unneeded tiles, freeing up memory
-(void)releaseUnusedTiles {
	[reuseQueue removeAllObjects];
}

@end
