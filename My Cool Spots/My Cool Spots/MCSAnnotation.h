//
//  MCSAnnotation.h
//  My Cool Spots
//
//  Created by Shane Sniteman on 8/18/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MCSAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly,copy) NSString * title;

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

-(void)setTitle:(NSString *)title;

@end
