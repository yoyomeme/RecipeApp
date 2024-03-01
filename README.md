# RecipeApp
 An app for you to share your secret recipes~

Welcome to RecipeApp, a comprehensive iOS application designed to showcase a variety of recipes, allowing users to browse, add, edit, and delete recipes. This personal project aims to demonstrate my proficiency in iOS development, adherence to Apple's Human Interface Guidelines, and implementation of modern app development practices.
Features

To get start:
Clone the Repository: Clone this repository to your local machine to get started with the project.
Open the Project: Open the RecipeApp.xcodeproj file in Xcode.
Install Dependencies: Run pod install from the terminal in the project directory to install any third-party libraries.
Run the App: Select an iOS simulator or connect an iOS device and run the app using Xcode.


Language: Developed using Swift, leveraging modern language features for clean and efficient code.
Data Model: Utilizes an XML file (recipetypes.xml) to define recipe types, which populate a UIPickerView control for recipe categorization.
Recipe Listing: A dedicated page lists all recipes, with functionality to filter recipes by type as defined in recipetypes.xml.
Sample Data: The app comes pre-populated with sample recipes that comply with the structure defined in recipetypes.xml.
Add Recipe: Users can add new recipes, specifying the recipe type, an image, ingredients, and cooking steps. New recipes dynamically update the existing list.
Recipe Detail: Each recipe has a detail page displaying the recipe image, ingredients, and steps. Users can update any of these details or delete the recipe.
Persistence: Implements CoreData for data persistence, ensuring recipe data persists across app restarts.
Responsive Design: The UI adapts to various screen sizes and orientations, adhering to safe area constraints to ensure a great user experience on all devices.
Stability: The app is designed to perform normal operations without crashing, ensuring a reliable user experience.
Additional Features

Reactive Programming: Utilizes RxSwift for reactive programming, demonstrating component/value binding with minimal use of delegates.
Architecture: Adopts the MVVM architecture pattern for clean and maintainable code.
Authentication: Features a login and logout system with session persistency until logout, enhancing app security.
Networking: Includes an API layer to fetch data from online or self-hosted sources, showcasing the app's ability to interact with external data.
Dependency Injection: Implements dependency injection using the Swinject library for improved modularity, reusability, maintainability, and scalability.
Testing: Incorporates unit tests and UI tests to detect changes that could break the code design and reduce defects, ensuring code quality.
Getting Started


Contributing:
Contributions to RecipeApp are welcome! Please feel free to submit pull requests or open issues to discuss potential improvements or report bugs.
License

RecipeApp is released under the MIT License. See the LICENSE file for more information. This README provides an overview of the RecipeApp project, its features, and instructions for getting started. It's designed to give potential users and contributors a clear understanding of what the app does and how it demonstrates modern iOS app development practices.

## MinChat💬
<p float="">
  <img src= "https://github.com/maykhid/min_chat/blob/main/screenshots/header.png?raw=true" />
</p>

A MINimalist chat application.

Leave a star⭐️ if you like what you see.

Contributions are highly welcome!

<a href="https://drive.google.com/file/d/18sy49tN9OuTGA6b2BSEyy3HHYSuPOQOI/view?usp=sharing"><img src="https://playerzon.com/asset/download.png" width="200"></img></a>

## 🖼 Screenshots
| ![Auth Image](https://github.com/maykhid/min_chat/blob/main/screenshots/auth.png?raw=true) | ![No Chat Image](https://github.com/maykhid/min_chat/blob/main/screenshots/no_chat.png?raw=true) | ![Start Conversation Image](https://github.com/maykhid/min_chat/blob/main/screenshots/start_conversation.png?raw=true) |
|---|---|---|
| ![Messages Image](https://github.com/maykhid/min_chat/blob/main/screenshots/messages.png?raw=true) | ![Chat Voice Modal Image](https://github.com/maykhid/min_chat/blob/main/screenshots/chat_voice_modal.png?raw=true) | ![Chat Image](https://github.com/maykhid/min_chat/blob/main/screenshots/chat.png?raw=true) |


## 💫 Features
* Basic p2p chat
* Voice message
* Group chat 
## Todo
* Block user
* Media sharing like Images, Video (Still under consideration)

## ✨ Requirements
* Any Operating System (ie. MacOS X, Linux, Windows)
* IDE of choice with Flutter SDK installed (ie. IntelliJ, Android Studio, VSCode etc)
* Knowledge of Dart and Flutter

## ⚙️ Setup
1. Clone the project.

2. Configure FlutterFire.

    * Set up FirebaseCLI if you haven't already, [here](https://firebase.google.com/docs/cli#setup_update_cli)
    
    * Navigate to your project's root directory in the terminal and run:
    
      ```flutterfire configure --project=<your-firebase-project-name>```
    
    * Replace ```<your-firebase-project-name>``` with the actual name of your Firebase project. 
    
    * Follow the prompts to select platforms and provide any necessary credentials.

    After completing the setup, please make sure your google_services.json, GoogleService-Info.plist and firebase_options.dart files are generated.
    
3.  Make sure the following are enabled on your Firebase project
    * Authentication
    * Firestore Database
    * Storage
  
Troubleshooting:

If you have any issues, please consult the FlutterFire documentation to check the issues or create a new one. 

## ⚙️ How to use
Recipe App is simple to use. 

To begin a normal conversation (p2p chat), you must have the recipient's mID or the email they used during registration (You can find your mID on the user page which can be found when you click the user profile picture). Click the floating action button to show an expanded floating action button, select the user icon enter the user's mID or email address and press `OK`.

To begin a group chat/conversation, the group participants you can add are people you have started a regular chat (p2p chat) with (You cannot add any participants if you haven't any persons you chat with). Click the floating action button to show expanded floating action buttons, and select the group icon, a list of people you started a conversation with is shown, select the ones to add to the group then press `Start Conversation`, then you're prompted to enter a desired name for this group.

## ✍️ Author
Zheng Qing Sia
