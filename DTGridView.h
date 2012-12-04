//
//  DTGridView.h
//  GridViewTester
//
//  Created by Daniel Tull on 05.12.2008.
//  Copyright 2008 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewCell.h"

typedef enum {
	DTGridViewScrollPositionNone = 0,
	DTGridViewScrollPositionTopLeft,
	DTGridViewScrollPositionTopCenter,
	DTGridViewScrollPositionTopRight,
	DTGridViewScrollPositionMiddleLeft,
	DTGridViewScrollPositionMiddleCenter,
	DTGridViewScrollPositionMiddleRight,
	DTGridViewScrollPositionBottomLeft,
	DTGridViewScrollPositionBottomCenter,
	DTGridViewScrollPositionBottomRight
} DTGridViewScrollPosition;

typedef enum {
	DTGridViewEdgeTop,
	DTGridViewEdgeBottom,
	DTGridViewEdgeLeft,
	DTGridViewEdgeRight
} DTGridViewEdge;

struct DTOutset {
	CGFloat top;
	CGFloat bottom;
	CGFloat left;
	CGFloat right;
};

@protocol DTGridViewDelegate;
@protocol DTGridViewDataSource;

@interface DTGridView : UIScrollView <UIScrollViewDelegate, DTGridViewCellDelegate> {
	
 	NSObject<DTGridViewDelegate> *gridDelegate;
	NSObject<DTGridViewDataSource> *dataSource;
	
	CGPoint cellOffset;
	
	UIEdgeInsets outset;
	
	NSMutableArray *gridCells;
	
	NSMutableArray *freeCells;
	NSMutableArray *cellInfoForCellsOnScreen;
	
	NSMutableArray *gridRows;
	NSMutableArray *rowHeights;
	NSMutableArray *rowPositions;
	
	NSMutableArray *cellsOnScreen;
	
	CGPoint oldContentOffset;
	
	BOOL hasLoadedData;
		
	NSInteger numberOfRows;
	
	NSInteger rowIndexOfSelectedCell;
	NSInteger columnIndexOfSelectedCell;
}

@property (nonatomic, assign) IBOutlet NSObject<DTGridViewDataSource> *dataSource;
@property (nonatomic, assign) IBOutlet NSObject<DTGridViewDelegate> *gridDelegate;

@property (assign) CGPoint cellOffset;
@property (assign) UIEdgeInsets outset;
@property (nonatomic, retain) NSMutableArray *gridCells;
@property (nonatomic) NSInteger numberOfRows;

- (CGFloat)findWidthForRow:(NSInteger)row column:(NSInteger)column;
- (NSInteger)findNumberOfRows;
- (NSInteger)findNumberOfColumnsForRow:(NSInteger)row;
- (CGFloat)findHeightForRow:(NSInteger)row;
- (DTGridViewCell *)findViewForRow:(NSInteger)row column:(NSInteger)column;

- (DTGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)scrollViewToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex scrollPosition:(DTGridViewScrollPosition)position animated:(BOOL)animated;

- (void)selectRow:(NSInteger)rowIndex column:(NSInteger)columnIndex scrollPosition:(DTGridViewScrollPosition)position animated:(BOOL)animated;


// This method should be used by subclasses to know when the grid did appear on screen.
- (void)gridDidLoad;

- (void)reloadData;

// ??
- (void)positionCheck;

@end

@protocol DTGridViewDelegate <UIScrollViewDelegate>

@optional
- (void)gridViewDidLoad:(DTGridView *)gridView;
- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
- (void)gridView:(DTGridView *)gridView scrolledToEdge:(DTGridViewEdge)edge;
- (void)pagedGridView:(DTGridView *)gridView didScrollToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
- (void)gridView:(DTGridView *)gridView didProgrammaticallyScrollToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;

@end


@protocol DTGridViewDataSource

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView;
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index;
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex;
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;
- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex;

@optional
- (NSInteger)spacingBetweenRowsInGridView:(DTGridView *)gridView;
- (NSInteger)spacingBetweenColumnsInGridView:(DTGridView *)gridView;

@end