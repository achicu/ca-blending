//
//  LayerSource.m
//  CABlending
//
//  Created by Chiculita Alexandru on 10/21/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "LayerSource.h"

@implementation LayerSource


- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSLog(@"outlineView=%@ - numberOfChildrenOfItem=%@", outlineView, item);
    if (item == nil)
        return 1;
    return [[(CALayer*)item sublayers] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    NSLog(@"outlineView=%@ - isItemExpandable=%@", outlineView, item);
    if (item == nil)
        return YES;
    return [[(CALayer*)item sublayers] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSLog(@"outlineView=%@ - child=%ld - item=%@", outlineView, index, item);
    if (item == nil)
        return self.baseView.layer;
    return [[(CALayer*)item sublayers] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return [(CALayer*)item description];
}

@end
