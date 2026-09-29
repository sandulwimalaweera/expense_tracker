# Expense Tracker

A clean and responsive Expense Tracker mobile application built with Flutter and Firebase.

The application allows users to securely manage their personal expenses, view spending summaries, filter and search expenses, and analyze spending by category.

## 1. Project Setup

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / Android SDK
- VS Code or another Flutter-compatible IDE
- Firebase project


## Features

- User registration and sign in
- Firebase Authentication
- Secure user-specific expense storage with Cloud Firestore
- Add new expenses
- Edit existing expenses
- Delete expenses
- Expense categories
- Expense date selection
- Optional notes
- Search expenses
- Filter by:
  - All Time
  - Date
  - Month
  - Category
- Total expense calculation
- Expense count
- Category spending summary
- Spending visualization with a pie chart
- Statistics screen
- Loading, empty, and error states
- Responsive Material 3 UI
- Guest account upgrade to a permanent account

## Expense Fields

Each expense contains:

- Title
- Amount
- Category
- Date
- Optional note

## Technology Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- fl_chart
- Material 3

## Project Structure

```text
lib/
├── models/
│   └── expense.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_expense_screen.dart
│   ├── statistics_screen.dart
│   ├── main_screen.dart
│   ├── auth_screen.dart
│   └── account_screen.dart
├── services/
│   └── expense_service.dart
├── utils/
│   ├── date_utils.dart
│   ├── error_message.dart
│   └── expense_filter.dart
├── widgets/
│   ├── empty_expense_state.dart
│   ├── expense_card.dart
│   ├── expense_error_state.dart
│   ├── expense_filter_bar.dart
│   ├── expense_summary.dart
│   ├── expense_category_summary.dart
│   └── expense_category_chart.dart
└── main.dart