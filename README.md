# FetchRecipesApp

# Summary: Include screen shots or a video of your app highlighting its features
I wrote this app using Clean architecuture in mind. The network layer is a reusable component that simply uses URLSession to fetch raw data. The Repository layer defined by the different repository files are a simplified interface in that use the networkservice and the either conform the data to a decodable object or to an image. The image repository also handles internally all the data caching for images with the DataCache class. App shows a list of all the recipes in the order they are received, showing the name, cuisine type, and the image itself. The top of the screen shows a series of buttons that are determined by all the cuisine types that come in the API request. They all initially start off with lower opacity to indicate they are not selected. When selected, they are set to 0 opacity and then initiates a filter for that type in alphabetical order. You can select and deselect as many types as you wish for filtering. There is a pull to refresh functionality that will refetch the API when you pull down on the recipe list. All views have their respective viewmodels for business logic and separation of concerns and bindings. In the event of an error, a custom UI will be shown and a different custom UI will be shown for an empty list result. All loading views have state management in place from their viewmodels. All code is written with SwiftConcurrency and all non UI code has numerous unit tests covering it for various workflows. The app also is designed for the color suite to consider dark mode as well.

# Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
The areas I prioritized on the project were the architecture, the networking, UI, and flow of the app for the user experience.
    -The networking is important to be streamlined and easy to use in order for the rest of the app to work correctly.
    -UI and the UX is critical to focus on as that is how the user sees the app. If the experience is bad, no one will want to use the app, so it needs to look good and be intuitive to understand what does what.
    -Architecture is important for the overall communication of the app. If you do not desing things in mind, then adding or altering components becomes unnecessarily complicated.

# Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Approximately 4-5 hours was spent into creating this application in 3 different sittings. First was getting the basics of the app working and together, then getting extra features with crisper UI completed and adhering to optimized lazy loading techniques, and lastly writing unit tests getting over 80% code coverage and most non UI files written for.

# Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
The choice to take a pure Clean Architecture approach to the architecture made the time it took create the app a little longer as well as the different tests needed as a con, but the pro to doing this is now the code is far more maintainable, testable, and reusable in nature.

# Weakest Part of the Project: What do you think is the weakest part of your project?
In my personal opinion, the weekest part of the project is the structure of the RecupeListViewModel. It has a few too many bits of functionality to it that could likely be separated into different components.

# Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
    -Dark Mode is fully accounted for with visual design, including the error image shown. 
    -Unique UI is shown when either the recipeList encounters and error or if it is empty
    -Custom AsyncImage like view created that utilizes a caching system to fetch images with a progress view to show case it is loading.
    -State management system for the RecipeListView and the RecipeImageView from their respective viewmodels.

# Screenshots
Dark Mode Image Error Icon
![DarkModeImageErrorIcon](https://github.com/user-attachments/assets/f4f7662d-8e72-4294-b298-a592d775cc38)
