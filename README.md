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
