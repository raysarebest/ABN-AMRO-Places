#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>
#import "NSUserActivity+WMFExtensions.h"


@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@property (nonatomic, readonly) CLLocationCoordinate2D sanFranciscoCoordinate;
- (nonnull NSURL *)placesURLWithCoordinate:(CLLocationCoordinate2D)coordinate name:(nullable NSString *)name;
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testHistoryURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://history"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeHistory);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testPlacesURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

- (void)testLoadsPlacesLocationURL {
    const CLLocationCoordinate2D sanFranciscoCoordinate = self.sanFranciscoCoordinate;
    static NSString * const sanFranciscoName = @"San Francisco";
    
    NSURL * const testURL = [self placesURLWithCoordinate:sanFranciscoCoordinate name:sanFranciscoName];
    
    const NSUserActivity * const testActivity = [NSUserActivity wmf_activityForWikipediaScheme:testURL];
    
    XCTAssertEqual(testActivity.wmf_type, WMFUserActivityTypePlaces);
    
    XCTAssertEqualObjects(testActivity.title, sanFranciscoName);
    XCTAssertEqualObjects(testActivity.mapItem.name, sanFranciscoName);
    
    XCTAssertEqualWithAccuracy(testActivity.mapItem.placemark.coordinate.latitude, sanFranciscoCoordinate.latitude, 0.00009);
    XCTAssertEqualWithAccuracy(testActivity.mapItem.placemark.coordinate.longitude, sanFranciscoCoordinate.longitude, 0.00009);
}

- (void)testPlacesURLDropsInvalidCoordinate {
    NSURL * const testURL = [self placesURLWithCoordinate:kCLLocationCoordinate2DInvalid name:nil];
    
    const NSUserActivity * const testActivity = [NSUserActivity wmf_activityForWikipediaScheme:testURL];
    
    XCTAssertEqual(testActivity.wmf_type, WMFUserActivityTypePlaces);
    
    XCTAssertNil(testActivity.mapItem);
}

- (void)testPlacesURLUsesLastCoordinate {
    const CLLocationCoordinate2D sanFranciscoCoordinate = self.sanFranciscoCoordinate;
    
    NSURL * const testURL = [self placesURLWithCoordinate:kCLLocationCoordinate2DInvalid name:nil];
    
    NSURLComponents * const testBaseComponents = [NSURLComponents componentsWithURL:testURL resolvingAgainstBaseURL:NO];
    testBaseComponents.queryItems = [testBaseComponents.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"latitude" value:@(sanFranciscoCoordinate.latitude).stringValue]];
    testBaseComponents.queryItems = [testBaseComponents.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"longitude" value:@(sanFranciscoCoordinate.longitude).stringValue]];
    
    const NSUserActivity * const testActivity = [NSUserActivity wmf_activityForWikipediaScheme:testBaseComponents.URL];
    
    XCTAssertEqual(testActivity.wmf_type, WMFUserActivityTypePlaces);
    
    XCTAssertEqualWithAccuracy(testActivity.mapItem.placemark.coordinate.latitude, sanFranciscoCoordinate.latitude, 0.00009);
    XCTAssertEqualWithAccuracy(testActivity.mapItem.placemark.coordinate.longitude, sanFranciscoCoordinate.longitude, 0.00009);
    
}

#pragma mark - Helpers

- (NSURL *)placesURLWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name {
    NSURLComponents *testURLComponents = [NSURLComponents componentsWithString:@"wikipedia://places"];
    testURLComponents.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"latitude" value:@(coordinate.latitude).stringValue],
        [NSURLQueryItem queryItemWithName:@"longitude" value:@(coordinate.longitude).stringValue]
    ];
    
    if (name) {
        testURLComponents.queryItems = [testURLComponents.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"name" value:name]];
    }
    
    return testURLComponents.URL;
}

- (CLLocationCoordinate2D)sanFranciscoCoordinate {
    static CLLocationCoordinate2D coordinate = {0, 0};
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinate = CLLocationCoordinate2DMake(37.7775, -122.416389);
    });
    
    return coordinate;
}

@end

