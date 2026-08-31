# E-commerce APP

A modern Flutter e-commerce application built with Clean Architecture and Riverpod, featuring offline-first capabilities and a sleek UI.

##  Architecture Explanation

The project follows a simplified **Clean Architecture** pattern, each containing three layers:

1.  **Domain Layer**
2.  **Data Layer**
3.  **Presentation Layer**: The UI and State Management. 

##  State Management Approach


## Offline Storage Approach

The app implements an **Offline-First** strategy using **sqflite** (SQLite):

*   **Caching**: Every time the app successfully fetches products from the API, it automatically updates a local SQLite database.
*   **Fallback Logic**: If a network request fails (no internet), the app seamlessly switches to the local cache so the user can still browse the catalog.
*   **Offline Search**: The search functionality is specifically designed to query the local database, ensuring ultra-fast results regardless of connectivity.
*   **Persistent Wishlist**: User "likes" are stored permanently in the database, meaning your favorites are remembered across app restarts and even without an internet connection.

## 🚀 Steps to Run the Application

Follow these steps to get the project running on your local machine:

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   An Android Emulator, iOS Simulator, or a physical device connected.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd ecommerce_project
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

---

###  Key Features Summary
*   **Auth**: Dummy login with persistence via `SharedPreferences`.
*   **Network**: `Dio` integrated with a 10s timeout and a manual **3-retry mechanism** with SnackBar feedback.
*   **UI/UX**: Hero animations for product images, themed loading states, and specialized "No Internet" and "Empty Wishlist" screens.
*   **Styling**: Centralized `AppColors`, `AppFonts`, and `AppSpacing` for consistent design across the app.
