# Currency Converter App

 This currency converter app provides a straightforward utility for converting currencies using live exchange rates fetched from an online API.

## Design Pattern

### 1. Model-View-Intent (MVI)

#### Overview:

 MVI is an architectural pattern emerging from the reactive programming paradigm, which emphasizes a unidirectional data flow. In MVI, the Model represents the app's state, the View displays this state, and the Intent (similar to a ViewModel in MVVM) manages the state transitions based on user actions or external events.

#### Implementation:

* Model: Encapsulates the application state and is immutable. Each state change results in a new instance of the Model, ensuring predictability and simplifying debugging. The Model in our app, CurrencyState, includes fields like input amount, base and target currencies, current exchange rate, loading indicators, error messages, and the computed output.
* View: The View layer in SwiftUI observes changes to the Model via the Intent and reacts by updating the UI accordingly. It's responsible solely for presentation and user interactions, forwarding actions to the Intent to handle.
* Intent: Serves as the orchestrator of the application logic. It interprets user actions as intents to change the state of the app. The Intent communicates with repositories to fetch or update data and applies business logic to update the state based on the results.

### 2. Repository Pattern

#### Overview:

 The Repository pattern abstracts the data layer from the rest of the application, providing a cleaner separation of concerns and an organized way to access data sources. It acts as a middleman between the domain and data mapping layers, providing a collection-like interface for accessing domain objects.

#### Implementation:

* Repository Handler: In the Currency Converter app, Repository handle is used to handle data operations abstractly. They encapsulate the logic needed to access data sources, whether fetching from a remote server via an API or local storage using UserDefaults.

* Local Repository: Implements caching mechanisms, storing responses locally to minimize API calls and provide offline access to data.

* Remote Repository: Manages network requests, fetching live data from the currency exchange API as required.

