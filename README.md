# ABN AMRO Code Challenge
## Michael Hulet

---

### Challenge:

 - [x] Modify the [Wikipedia app](https://github.com/wikimedia/wikipedia-ios) so that it can be called in a way so that, when started, it directly goes to the ‘Places’ tab and shows the location specified by the calling app (e.g. via coordinates), instead of the current location

- [x] Create a simple test app with a list of locations
    - [ ] Should fetch locations from [remote server](https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json)
    - [ ] Tapping on a location should call the Wikipedia app in this new way to
demonstrate the functionality
    - [ ] The user of the test app should be allowed to enter a custom location and open
the Wikipedia app there

### Additional Requirements:

- [ ] Use SwiftUI for the "Places" app
- [x] Make a README
- [ ] Unit tests
- [ ] Demonstrate knowlege of:
    - [ ] Swift Concurrency
    - [ ] Accessibility

## Implementation
### Wikipedia Modifications

I modified the Wikipedia app to accept a location by extending its existing support for its `wikipedia://places` URL scheme. It now accepts 3 new query parameters:

- `latitude`: The decimal latitude of the coordinate the map should open to
- `longitude`: The decimal longitude of the coordinate the map should open to
- `name`: The optional label of the location the map should open to

`latitude` and `longitude` must both be passed and combine to form a valid cartographic coordinate in decimal notation for any of the 3 new properties to be used. One of my engineering philosophies is to make invalid states unrepresentable, so only including valid data past the parser instead of blindly passing it through serves that goal, and negates the need for more complex error handling further downstream. The `name` is currently largely ignored, except to identify the user activity to the system in case Spotlight indexes it in the future

The new URL parsing support is implemented in the [WMF Framework's `NSUserActivity+WMFExtensions.m`](wikipedia-ios/Wikipedia/Code/NSUserActivity+WMFExtensions.m) (specifically in `wmf_placesActivityWithURL:`), with corresponding tests [`NSUserActivity+WMFExtensionsTests.m`](wikipedia-ios/WikipediaUnitTests/Code/NSUserActivity+WMFExtensionsTest.m)

A simple logical branch was added in `processUserActivity:animated:completion:` in [`WMFAppViewController`](wikipedia-ios/Wikipedia/Code/WMFAppViewController.m) which dispatches over to the new `showCoordinate(_:)` method in [`PlacesViewController`](wikipedia-ios/Wikipedia/Code/PlacesViewController.swift), which calls existing methods to highlight the map view and adjust it to the desired location. Unfortunately Wikipedia's app doesn't include any existing tests for either of those symbols, and they aren't particularly well-architected to be testable (or fully concurrency-aware), so I'm considering such modifications to be out-of-scope for this particular assignment

### Places App

- Build target is iOS 16.6 to match the Wikipedia app
    - Also supports all the same platforms as the Wikipedia app