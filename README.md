## Setup Instructions

1. Clone the repository:
   git clone https://github.com/sandulwimalaweera/expense_tracker.git

2. Open the project folder:
   cd expense_tracker

3. Install Flutter dependencies:
   flutter pub get

4. Configure Firebase:
   - Make sure Firebase is configured for the project.
   - The project includes the required Firebase configuration files.

5. Run the application:
   flutter run


   # Expense Tracker

A simple and clean Expense Tracker mobile application built with Flutter and Firebase. The application allows users to securely manage their expenses, organize them by category, search and filter expenses, and view spending summaries and statistics.

## Features

### Authentication
- User authentication using Firebase Authentication
- User-specific expense data
- Account screen for managing the user account

### Expense Management
- Add new expenses
- Edit existing expenses
- Delete expenses
- Enter expense title, amount, category, date, and description
- Expense categories:
  - Food
  - Transport
  - Shopping
  - Bills
  - Entertainment
  - Health
  - Other

### Expense Filtering
- View all expenses
- Filter expenses by a specific date
- Filter expenses by month
- Filter expenses by category
- Search expenses by title or relevant expense information
- Clear the search field easily

### Expense Summary
- Display total expenses for the selected period
- Display the number of expenses
- Display category-based expense summaries
- View spending distribution through charts

### User Experience
- Clean and simple user interface
- Responsive Flutter UI
- Loading states
- Empty expense states
- Error handling and user-friendly error messages
- Confirmation dialog before deleting an expense
- Success/error feedback using SnackBars

### Testing
- Unit tests for expense filtering functionality
- Flutter widget tests

---

## Technologies Used

### Framework
- Flutter
- Dart

### Backend
- Firebase
- Firebase Authentication
- Cloud Firestore

### Development Tools
- Android Studio
- Visual Studio Code / PhpStorm
- Git
- GitHub

---

## Packages Used

The project uses the following Flutter/Dart packages:

- `firebase_core` - Firebase initialization
- `firebase_auth` - User authentication
- `cloud_firestore` - Store and retrieve expense data
- `fl_chart` - Expense statistics and charts
- `intl` - Date and number formatting
- `cupertino_icons` - iOS-style icons

The exact package versions can be found in `pubspec.yaml`.

---

## Project Structure

```text
expense_tracker/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│   └── icon/
│
├── lib/
│   ├── models/
│   │   └── expense.dart
│   │
│   ├── screens/
│   │   ├── account_screen.dart
│   │   ├── add_expense_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── home_screen.dart
│   │   ├── main_screen.dart
│   │   └── statistics_screen.dart
│   │
│   ├── services/
│   │   └── expense_service.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── error_message.dart
│   │   └── expense_filter.dart
│   │
│   ├── widgets/
│   │   ├── empty_expense_state.dart
│   │   ├── expense_card.dart
│   │   ├── expense_category_chart.dart
│   │   ├── expense_category_summary.dart
│   │   ├── expense_error_state.dart
│   │   ├── expense_filter_bar.dart
│   │   └── expense_summary.dart
│   │
│   ├── firebase_options.dart
│   └── main.dart
│
├── test/
│   ├── expense_filter_test.dart
│   └── widget_test.dart
│
├── firebase.json
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md



## AI-Assisted Development

AI tools were used selectively as development assistants throughout the project to improve productivity, debugging, documentation, and problem-solving.

- GitHub Copilot – Assisted with code suggestions, repetitive implementation tasks, debugging, and exploring alternative coding approaches.

- ChatGPT – Assisted with technical research, Flutter/Dart troubleshooting, Firebase-related issues, code review, documentation, and development guidance.

AI-generated suggestions were reviewed, adapted, and tested before being incorporated into the application. The final architecture, feature implementation, integration decisions, testing, and validation were carried out as part of the development process.

AI was therefore used as a productivity and learning tool, while development decisions and the final implementation remained under the developer's control.