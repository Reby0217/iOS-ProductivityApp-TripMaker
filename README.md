# TripMaker

TripMaker is a dynamic productivity app that enhances focus and motivation through the thrill of virtual travel. Users set a focus timer and advance through global locations, gamifying productivity with immersive travel experiences. Ideal for students, professionals, or anyone looking to boost concentration while exploring the world, TripMaker combines work with pleasure, keeping users engaged, motivated and informed as they achieve their goals. This app promises an enjoyable and educational way to stay focused and meet objectives.

## Setup and Configuration

1. **Apple ID**: Ensure you are logged in with your Apple ID in the simulator to utilize iCloud services.

2. **Xcode Configuration**:
   - Open `TripMaker.xcodeproj` in Xcode.
   - Go to the "Signing & Capabilities" tab.
   - Confirm "Automatically manage signing" is enabled.
   - Select your development team from the drop-down menu.
   - Check the `Bundle Identifier` is correct.
   - Under "iCloud," ensure services are enabled and containers are correctly set.

3. **Database Initialization**: The `DBManager` class handles the database setup automatically when you launch the app for the first time.


## iCloud Integration

When running TripMaker in a simulator logged in with an Apple ID, the following iCloud features are available:

- **iCloud Drive Sync**: After building and running the project, a `MyDocs` directory is created on your iCloud Drive. This directory includes a file named `db.sqlite3`.
- **Accessing Database on iCloud**: You can visit [icloud.com](https://www.icloud.com/) and log in with the same Apple ID used in the simulator. Once logged in, you can access the `MyDocs` directory in iCloud Drive to find the `db.sqlite3` file. This allows you to see your database synced across devices.

**Important**: To open and view the `.sqlite3` file, you need to download the `DB Browser for SQLite` application from [https://sqlitebrowser.org](https://sqlitebrowser.org), which is available for various operating systems. This tool will allow you to open and interact with the SQLite database.


## Key Features

- **Profile Customization**: Personalize your profile with a username and a picture.

- **Map Interactions**: Discover new places through an interactive map experience.

- **Route and Locations Discovery**: Unlock and explore various routes and their associated locations.

- **Focus Sessions**: Improve concentration with dedicated focus sessions, contributing to unlocking new locations.

- **Stat Tracking**: Visualize your focus time with stats, enhancing your motivation.

- **Reward System**: Earn rewards by achieving focus time milestones and exploring locations.

- **SpriteKit Integration**: Incorporate SpriteKit within a SwiftUI framework, facilitating the creation of a dynamic and interactive map scene.

### External APIs and Services 
- **Unsplash API**: Used in the function `fetchLocationPicture(route, for)` which retrieves images for locations to enhance the virtual travel experience. 
- **Wikipedia API**: Used in the function `fetchLocationDescription(for)` which provides descriptions for landmarks, contributing to the educational aspect of the app.

### Third-Party Libraries
- **SQLite.swift 0.15.0**: A Swift framework for interacting with the SQLite database, simplifying SQL operations in Swift.

- **Lottie 4.4.1** <br>
    (1) A library for iOS that parses Adobe After Effects animations exported as json with Bodymovin and renders them natively on mobile.<br>
    (2) To enhance the UI with complex animations, making the user experience more engaging.

### iCloud Integration
- **iCloud Documents** <br>
    (1) Utilizes iCloud's document storage capabilities for data backup and synchronization across devices. <br>
    (2) Leverages `NSUbiquitousKeyValueStore` for seamless iCloud integration with the app's document- based data model.
    
## Function List
### Database Management Functions

1. **Initialization and Setup**
    - `setupDatabase()`: Initializes and connects to the SQLite database. It checks for an existing database at the iCloud-specified path or creates a new one if none exists, then populates it with initial data.
    - `createTables()`: Creates the necessary tables in the database if they do not already exist. This includes tables for routes, locations, tags, rewards, user profiles, user routes, focus sessions, visited locations, and user rewards.
   - `insertInitialData()`: Populates the database with initial data including routes, locations, tags, and rewards. This function is a high-level orchestrator that calls other functions to handle specific types of data insertion.

2. **Data Manipulation**
   - `addRoute(name, mapPicture)`: Adds new travel routes.
   - `addLocationToRoute(index:routeName:name:realPicture:description:isLocked:)`: Adds new locations to specified routes.
   - `addTagToLocation(name:tag)`: Associates tags with locations.
   - `addReward(name:picture,isClaimed)`: Adds rewards into the database.
   - `createUserProfile(username, image)`: Creates a new user profile with a unique identifier.
   - `createFocusSession(userID, startTime, duration)`: Registers a new focus session with start time and duration.
   - `updateVisitedLocations(sessionID, visitedLocations)`: Updates locations visited during a specific focus session.
   - `claimReward(userID, rewardName)`: Marks rewards as claimed by the user.

3. **Data Retrieval**
   - `fetchRouteDetails(route:)`: Retrieves complete details for a specified route.
   - `fetchLocationsForRoute(routeName)`: Gets all locations for a given route.
   - `fetchAllLocationsInOrder(routeName)`: Retrieves all locations in sequence from a route for ordered display.
   - `fetchReward(by)`: Fetches specific reward details using the reward's name.
   - `fetchUserProfile(userID)`: Gathers complete profile details for a user including linked routes, focus sessions, and claimed rewards.
   - `fetchFocusSessionsForUser(userID)`: Retrieves all focus session identifiers linked to a user.
   - `fetchFocusSessionDetails(sessionID)`: Obtains details for a specific focus session.

4. **Data Updates**
   - `updateReward(name, newName, newPicture:isClaimed)`: Modifies details of existing rewards.
   - `updateLocation(name, newName, newRealPicture, newDescription, newIsLocked)`: Changes attributes of an existing location.
   - `updateUserProfile(userID, newUsername, newImage)`: Updates user profile information.
   - `updateUserStats(userID, focusTime)`: Refreshes user statistics with new focus session time and potentially triggers reward claims based on total focus time.

## Operating Instructions

### Getting Started
The map view is the home base, showing your active route. Use the side menu for navigation through the app to view your stats, profile, and your travel passport.

### Profile Management
Edit your profile to change your picture or username. After editing, don't forget to save your changes.

### Focus Sessions
Initiate focus sessions in the Timer view. Completed sessions contribute to your profile's stats and may unlock new locations based on the session's length.

### Achievement Tracking
Your profile showcases your achievements, which are tied to focus time milestones and location visits.

### Routes and Locations Exploration
The app lists various routes, each with several locations. Select a location to see more details, such as images and descriptions.


## Troubleshooting

- **Log into iCloud account in the simulator**: If you're unable to log into your iCloud account in the simulator, navigate to [icloud.com](https://www.icloud.com) and agree to the Terms & Conditions (T&C) there.
- **iCloud Sync**: For synchronization problems, check the Apple ID settings and iCloud configuration in Xcode.

