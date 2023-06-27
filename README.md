# iOS Assignment Wikipedia
A repository for a test app that opens universal link in Wikipedia app and shows the place details on map

## iOS Assessment | Albert Heijn

### App Demo

https://github.com/jayesh15111988/WikipediaLocationsNavigator/assets/6687735/252b2883-e671-46ab-99b9-55193ea2d4c4


### Overview
The aim of this project was to create a simple test app with a list of locations. App fetches locations from https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json.
Tapping on a location calls the Wikipedia app in this new way to demonstrate the functionality.
The user can also enter a custom location and open the Wikipedia app with place details.

### Features
This app has only one screen. User can either enter place name and trigger the search by tapping "Search" button or select the location from pre-existing list

![simulator_screenshot_270C6A55-B538-42A8-A845-9E5F6D896CBB](https://github.com/jayesh15111988/WikipediaLocationsNavigator/assets/6687735/4d079771-e308-444d-96d1-65cf23418796)


### Architecture
The app uses MVVM architecture. The reason is, I wanted to separate out all the business and data transformation logic away from the view layer. 
The view model is responsible for getting network models (Decodable models) from network service and converting them into local view models to be consumed by the view layer.

The view model interacts with the network layer through protocols and gets the required data with network calls via interfaces.

I ruled out MVC due to it polluting the view layer and making it difficult to just test the business logic due to intermixing with a view. 
I also thought about VIPER architecture, but it seemed an overkill for a feature this small given the boilerplate code it tends to add. 
Finally, I decided to use MVVM as a middle ground between these two possible alternatives.

### How to run the app?
The app can be run simply by cloning the project, opening "WikipediaLocationsNavigator.xcodeproj" file and pressing CMD + R to run it

### Unit Tests
I have written unit tests to test the view model layer. Tests are written with the mindset to test the business logic. That way, we can catch bugs in business logic. 
Not everything can be tested with Unit tests, so this can be complemented by UI or snapshot tests in the future.

### UI/Automated tests
No UI or automated tests have been added, but can be included as the improvement in the future.

### Test Coverage
The app has a total test coverage of 73.5%

### Device support
This app is currently supported only on iPhone (Any model) in portrait mode.

### Handling of failures
The app is designed to handle any kind of failure originating from network request handling. 
In case a network request fails, the user can also retry the previous request. This acts as protection against one-off failures and network glitches.

### Styles and Designs
I have used very minimal styles and designs but still kept things consistent across screens. I decided to instead focus on architecture, error handling, and testable app 
design instead of adding fancy UI. However, that shouldn't be an issue if we want to enhance design in the future. The way the app is set up, it is very easy to centralize
all the style elements and apply them throughout the app.

### Third-party images used
No third party images have been used in the app

### Usage of 3rd party library
App is not using any 3rd party library in this app.

### Deployment Target
The app needs a minimum version of iOS 13 for the deployment

### Xcode version
The app was compiled and run on Xcode version 14.2

### API used
I am using the previously provided API  tohttps://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json fetch the list of existing locations that user can choose from

### Future enhancements
The project can be extended in several ways in the future

- Support for multiline location name
- Adding styles and better UI
- Adding UI / snapshot tests
- Accessibility
- Support to show previously searched locations

### Swift version used
Swift 5.0

