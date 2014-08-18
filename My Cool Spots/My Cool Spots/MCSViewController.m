//
//  MCSViewController.m
//  My Cool Spots
//
//  Created by Shane Sniteman on 8/18/14.
//  Copyright (c) 2014 Shane Sniteman. All rights reserved.
//

#import "MCSViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MCSAnnotation.h"

@interface MCSViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@end

@implementation MCSViewController
{
    MKMapView * mapView;
    
    CLLocationManager * locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
//    mapView.userTrackingMode = YES;
    [self.view addSubview:mapView];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation * location in locations)
    {
        NSLog(@"%f %f",location.coordinate.latitude, location.coordinate.longitude);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1.0, 1.0));
        
        [mapView setRegion:region animated:YES];
        
        for (int i = 0; i < 10; i++)
        {
        
        MCSAnnotation * annotation = [[MCSAnnotation alloc] init];
        
            float randomLat = arc4random_uniform(100) / 100.0 + location.coordinate.latitude;
            float randomLong = arc4random_uniform(100) / 1000.0 + location.coordinate.longitude;
            
            CLLocationCoordinate2D randomCoordinate = CLLocationCoordinate2DMake(randomLat,randomLong);
            
            [annotation setCoordinate:randomCoordinate];
            
            CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
            
            CLLocation * randomLocation = [[CLLocation alloc] initWithLatitude:randomCoordinate.latitude longitude:randomCoordinate.longitude];
            
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                
                for (CLPlacemark * placemark in placemarks)
                {
                    [annotation setTitle:placemark.name];
                }
            }];
            
        [annotation setTitle:@"Title"];
        
        [mapView addAnnotation:annotation];
        }
    }
    
    [locationManager stopUpdatingLocation];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MCSAnnotation * ann = annotation;
    
    if (mapView.userLocation.location.coordinate.latitude == ann.coordinate.latitude && mapView.userLocation.location.coordinate.longitude == ann.coordinate.longitude)
    {
        
    } else {
        MKPinAnnotationView * annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
//        annotationView.draggable = YES;
    
        NSArray * markers = @[
                              [UIImage imageNamed:@"pin-blue-1.png"],
                              [UIImage imageNamed:@"pin-red-1.png"],
                              ];
        
        NSLog(@"%@",markers);
        
        int randomMarker = arc4random_uniform((int)markers.count);
        
        annotationView.image = markers[randomMarker];
        
        annotationView.canShowCallout = YES;
        
        UIButton * rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [rightCallout addTarget:self action:@selector(showDetailVC) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = rightCallout;
        
        return annotationView;
    }
    
    return nil;
}

-(void)showDetailVC
{
    UIViewController * detailVC = [[UIViewController alloc] init];
    
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}












- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
