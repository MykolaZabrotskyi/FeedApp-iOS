# FeedApp-iOS
Hello! This is my project called FeedApp. I built this application to practice my skills in iOS development, focusing on working with networking, complex UI layouts, and the MVVM architecture.
# About the App
FeedApp is a simple news feed application where you can:
* View a list of posts with titles and short descriptions.
* Expand/Collapse long descriptions directly in the list.
* Tap on a post to see full details, including a high-quality image.
# Tech Stack & Tools
I decided to build this app without Storyboards (programmatically) because I wanted to understand how UIKit works under the hood.
* Language: Swift
* UI Framework: UIKit (Code-only)
* Architecture: MVVM (Model-View-ViewModel)
* Layout: Auto Layout & UICollectionView Compositional Layout
* Networking: Async/Await with URLSession
* Version Control: Git (I followed a simple Gitflow: feature branches -> develop -> main)
# What I implemented in this project
1. Compositional Layout: I used the modern UICollectionLayoutListConfiguration to create a clean list.
2. Custom Cells: Created PostCell with dynamic height. The "Expand" button only appears if the text is longer than 2 lines.
3. Error Handling: If the internet is off or the API fails, the app shows an error alert and a "broken image" icon.
# Challenges I faced
* Cell Animations: It was tricky to make the "Expand" animation smooth without the title "blinking." I solved this by using performBatchUpdates and isolating the update logic.
* Auto Layout: Since I didn't use Storyboards, I had to learn how to activate constraints manually and handle the safeAreaLayoutGuide.
