# ABN AMRO Code Challenge
## Michael Hulet

---

### Challenge:

 - [x] Modify the [Wikipedia app](https://github.com/wikimedia/wikipedia-ios) so that it can be called in a way so that, when started, it directly goes to the ‘Places’ tab and shows the location specified by the calling app (e.g. via coordinates), instead of the current location

- [x] Create a simple test app with a list of locations
    - [x] Should fetch locations from [remote server](https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json)
    - [x] Tapping on a location should call the Wikipedia app in this new way to
demonstrate the functionality
    - [x] The user of the test app should be allowed to enter a custom location and open
the Wikipedia app there

### Additional Requirements:

- [x] Use SwiftUI for the "Places" app
- [x] Make a README
- [x] Unit tests
- [x] Demonstrate knowledge of:
    - [x] Swift Concurrency
    - [x] Accessibility

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

The app is split across 2 screens in a tab view to fulfill the requirement of being able to select both from a list of preset locations and a custom location entered by the user. The list of presets loads automatically the first time the user views that screen, and can be refreshed by pulling down on the list. Tapping a row opens the Wikipedia app

The custom location screen is marginally more interesting, as it contains a map view and an editor for the individual coordinate parts. Once you've either selected a location by tapping on the map or typing it into the text fields, a button appears that allows you to open that location in Wikipedia

#### Testing

The app is architected in a very vanilla MV-style manner, which is typically perceived as not particularly conducive to unit testing, but that's actually not the case. If you conceptualize what SwiftUI calls a `View` as what an MVVM architect would call a "view model", and solely the implementation of `body` as the typical "view" layer, it becomes significantly easier to isolate functionality that should be tested elsewhere. The simple priciple is that while it's alright to have some view-specific code for purposes like layout in the `body`, business logic should always live elsewhere and simply be referenced in the `body`

You can see this philosophy in practice in cases such as the `wikipediaURL(at:)` method being implemented as a static extention on URL, or network interaction being implemented in terms of a `DataLoader` (which is then injected as a dependency into the environment, and erases a protocol `Networker` that can be easily mocked in tests). Doing this allows for near-total coverage of critical logic by unit tests while leaving the tests for the view code for the UI tests (which are out-of-scope for this particular challenge)

Alternatively, for a more complex app or one where I'm not working alone, I could've chosen a more traditionally-popular architecture like The Composable Architecture or MVVM, which has stronger rules and opinions around things like project layout and data flow, which allows for easier coordination between engineers (both on different teams and across time). However, given that this is a simple, one-off app, and SwiftUI itself already has many strong opinions, keeping the architecture similarly simple allowed me to build quickly instead of fighting SwiftUI so frequently (as you often do when straying from Apple's beaten path)

#### Accessibility

This app was also designed with accessibility in mind. While I don't have any motor/vision/hearing disabilities myself, I of course it was tested with things like VoiceOver and Voice Control. Even the map selection features are functional through assistive technology. Furthermore, I tried to get all the details right, including things like:

- Switching the label layouts to be above the coordinate text fields on the custom location selection screen instead of next to them to avoid truncation when the user has an accessibility dynamic type size selected
- Allowing both text fields to be incremented and decremented with the corresponding actions through the accessibility system
- Disabled many animations when the user turned on the "reduce motion" setting
- Ensured sufficient contrast throughout for readability
- Added extra hints/values/etc for extra context for screen readers
- Added appropriate traits to various interface elements for navigation
- Supports both light mode and dark mode
- Appropriately hid and modified interface elements in the accessibility system to avoid distraction
- Ran audit of all screens with built-in accessibility inspector and ensured only warnings are false-positives

Lastly, the app is fully internationalized, including supporting things like right-to-left layouts, so it can be trivially localized into any other culture just by exporting the strings archive, translating it, and importing it again to enable that localization. That includes all user-facing text, including that which is only exposed to the accessibility system