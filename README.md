
## Base information

Created using MVVM, SwiftUI.
This project is using Chibli API.

_Base version of this project is based on tutorial made ny Karin Prater._
Later updates are done for testing and check out purpose of different features.

New features may by added later.

##### Tech details 
- This app doesn't contain any 3rd party dependencies. All the features are implemented using a native SwiftUI element.
- Cuncurrency implementation for all the requests, `async await`
- `iOS Deployment Target` version 18.2
- Native `URLSession` for client-server connection
- Concentricity
- `User Defaults` as a storage for settings and favorites
- `XCTest` added for some of the logic
- MVVM based architecture
- Remote `Notifications Permission` added as a test feature, no remote server
- `Theme switching` for the whole app feature, native themes
- Xcode 26.2

## Currently, the project contains next features:

#### Films List

Here user can browse the list of films with basic data. 
Its possible to add favorites here too.
Score is colored depending on how it is rated.

> The list of data is loaded using swift cuncurrency, `async await` features.
> Saving favorites is done via `UserDefaults` wrapped in service.

<img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/films-1.png" width="200"> <img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/films-2.png" width="200">

##### Film Details 

This screen is available from tabs like Favorites, Films list or Search. 
It shows detailed information of the selected item. Favorites can be added or removed here too.
List of cast is loaded at the bottom part of the screen.

<img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/film-details-1.png" width="200"> <img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/film-details-2.png" width="200">

#### Favorites

The list of user favorites. 
Empty if nothing is favorite.

<img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/favorites-1.png" width="200"> 

#### Settings

Here is the list of customizations and options for the user.
Change of the theme, notification, localization, showing/hiding part of the UI.
Here we also have an option to `reset to defaults` and clean all favorites or settings changes.

<img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/settings-1.png" width="200"> 

#### Search

Adds option to search for a film. 

> This is not based on the server, as Chibli doesn't provide a search API.
> This feature added locally with the loaded list of films.

<img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/search-1.png" width="200">  <img src="https://github.com/hellensoloviy/iOSGhibliApp/blob/main/read-me-files/search-2.png" width="200"> 

#### The end.

Thank you for reading this far :)
