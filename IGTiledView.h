//
//  IGTiledView.h
//  IGTiledView
//
//  Created by Ishaan Gulrajani on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 
 **IGTiledView** displays a scrollable grid of tiles (see: IGTile). Provide IGTiledView with
 a data source (similar to UITableViewDataSource), and it lays out the tiles in a memory-efficient
 way, fetching them as needed and allowing you to reuse old tiles to create new ones.
 
 Getting Started
 ===============
 
 1. Implement the methods in the IGTiledViewDataSource protocol: 
     tileSize: returns the size of each tile
     tileCount: returns the number of tiles in the view
     tiledView:tileAtIndex: returns the nth tile in the grid. See the default implementation in
       IGTiledView.m for an example on how to do this one.
 
 2. Create a new IGTiledView, set its data source, and add it to your view hierarchy.
 
 */

#import <Foundation/Foundation.h>

@class IGTiledView, IGTile;

@protocol IGTiledViewDataSource

-(CGSize)tileSize:(IGTiledView *)tiledView;
-(int)tileCount:(IGTiledView *)tiledView;
-(IGTile *)tiledView:(IGTiledView *)tiledView tileAtIndex:(int)index;

@end

@protocol IGTiledViewDelegate

@optional
	-(void)tiledView:(IGTiledView *)tiledView didSelectTileAtIndex:(int)index;

@end


@interface IGTiledView : UIScrollView <UIScrollViewDelegate> {	
	NSObject<IGTiledViewDataSource> *dataSource;
	NSObject<IGTiledViewDelegate> *tiledViewDelegate; // "delegate" would be the scroll view delegate
	float verticalTilePadding;
	
	CGSize tileSize;
	int tileCount;
	NSMutableDictionary *tiles;
	NSMutableArray *reuseQueue;
	
	int oldTopIndex;
	BOOL isScrolling;
	NSTimer *reloadDataTimer;
}
@property(nonatomic,assign) NSObject<IGTiledViewDataSource> *dataSource;
@property(nonatomic,assign) NSObject<IGTiledViewDelegate> *tiledViewDelegate;
@property(nonatomic) float verticalTilePadding;

// every tiled view needs a data source. use this init method only.
-(id)initWithFrame:(CGRect)frame dataSource:(NSObject<IGTiledViewDataSource> *)aDataSource;


// removes the specified tile from the view with a nice animation
-(void)removeTileAtIndexAnimated:(int)index;

// reload all data and updates the display accordingly.
-(void)reloadData;

// all new tiles should be init'ed with this frame
-(CGRect)newTileFrame;

// fetches an offscreen tile. use this in tileView:tileAtIndex: instead of just making another new tile
-(IGTile *)tileFromReuseQueue;

// clears the reuse queue- use this is you need to free up some memory
-(void)releaseUnusedTiles;




// call these methods from your view controller at the appropriate times (see IGTiledViewController)
-(void)willRotate;
-(void)didRotate;

// this is called by IGTile; you shouldn't call it directly.
-(void)tileTouched:(IGTile *)tile;

@end
