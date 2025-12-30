# Personal Expense Tracker

A modern Flutter application for tracking personal expenses with authentication, data visualization, and comprehensive expense management features.

## Features

- **User Authentication**: Secure signup and login using Supabase authentication
- **Expense Management**: Add, edit, and delete expenses with categories
- **Budget Tracking**: Monitor spending against a defined income limit
- **Statistics Dashboard**: Visualize spending patterns with interactive charts
- **Category Classification**: Organize expenses into Food, Travel, Shopping, Bills, and Others
- **Responsive Design**: Optimized for both mobile and tablet devices
- **Real-time Updates**: Instant synchronization with Supabase backend

## Screenshots

The app includes:
- Onboarding screen with attractive UI
- Login and signup screens with validation
- Home screen displaying total balance, income, and expenses
- Statistics screen with line charts and top spending analysis
- Add/Edit expense screens with date picker and category selector

## Tech Stack

- **Framework**: Flutter 3.4.4+
- **State Management**: Provider
- **Backend**: Supabase (Authentication & Database)
- **Routing**: GoRouter
- **Charts**: FL Chart
- **Date Formatting**: Intl

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── constants.dart          # App constants (total income)
│   │   └── supabase_config.dart    # Supabase credentials
│   ├── router/
│   │   └── app_router.dart         # Route configuration
│   └── utils/
│       └── snackbar.dart           # Global snackbar utility
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart  # Authentication state management
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── signup_screen.dart
│   ├── expenses/
│   │   ├── models/
│   │   │   ├── expense_model.dart
│   │   │   └── expense_model.g.dart
│   │   ├── providers/
│   │   │   └── expense_provider.dart
│   │   └── screens/
│   │       ├── add_expense_screen.dart
│   │       ├── edit_expense_screen.dart
│   │       ├── home_screen.dart
│   │       └── statistics_screen.dart
│   ├── onboard/
│   │   └── screens/
│   │       └── onboard_screen.dart
│   └── root.dart                   # Bottom navigation root
└── main.dart                       # App entry point
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.4.4 or higher)
- Dart SDK
- Supabase account
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd personal_expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   
   Create a Supabase project and set up the following:

   a. Create an `expenses` table with the following schema:
   ```sql
   CREATE TABLE expenses (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id) NOT NULL,
     title TEXT NOT NULL,
     amount DECIMAL NOT NULL,
     category TEXT NOT NULL,
     expense_date TIMESTAMP NOT NULL,
     created_at TIMESTAMP DEFAULT NOW()
   );
   ```

   b. Enable Row Level Security (RLS) policies:
   ```sql
   -- Users can only read their own expenses
   CREATE POLICY "Users can view own expenses"
   ON expenses FOR SELECT
   USING (auth.uid() = user_id);

   -- Users can only insert their own expenses
   CREATE POLICY "Users can insert own expenses"
   ON expenses FOR INSERT
   WITH CHECK (auth.uid() = user_id);

   -- Users can only update their own expenses
   CREATE POLICY "Users can update own expenses"
   ON expenses FOR UPDATE
   USING (auth.uid() = user_id);

   -- Users can only delete their own expenses
   CREATE POLICY "Users can delete own expenses"
   ON expenses FOR DELETE
   USING (auth.uid() = user_id);
   ```

4. **Add Supabase credentials**
   
   Update `lib/core/config/supabase_config.dart`:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

5. **Configure total income**
   
   Update `lib/core/config/constants.dart`:
   ```dart
   final totalIncomeUser = 5000.0; // Set your income amount
   ```

6. **Add assets**
   
   Place the onboarding image at `assets/onboard1.png`

7. **Generate JSON serialization code**
   ```bash
   flutter pub run build_runner build
   ```

8. **Run the app**
   ```bash
   flutter run
   ```

## Usage

1. **First Time Setup**
   - Open the app and view the onboarding screen
   - Tap "Get Started" to create an account
   - Enter your email and password to sign up

2. **Adding Expenses**
   - Tap the floating action button (+)
   - Fill in expense details (name, amount, date, category)
   - The app will validate that expenses don't exceed your income
   - Tap "Add Expense" to save

3. **Managing Expenses**
   - View all expenses on the home screen
   - Tap an expense to edit it
   - Swipe or tap delete icon to remove an expense

4. **Viewing Statistics**
   - Navigate to the Statistics tab
   - View monthly spending trends on the line chart
   - Check top spending items by category

## Configuration

### Customizing Income
Edit `lib/core/config/constants.dart` to change the total income amount.

### Changing Theme
Update the theme configuration in `lib/main.dart` to customize colors and styles.

### Adding Categories
Modify the `ExpenseCategory` enum in `lib/features/expenses/models/expense_model.dart` to add new categories.

## Dependencies

```yaml
dependencies:
  flutter: sdk
  supabase_flutter: ^2.8.0
  go_router: ^14.6.2
  provider: ^6.1.1
  json_annotation: ^4.9.0
  intl: ^0.19.0
  fl_chart: ^0.66.0
  cupertino_icons: ^1.0.6
  flutter_native_splash: ^2.4.1

dev_dependencies:
  flutter_lints: ^3.0.0
  build_runner: ^2.4.9
  json_serializable: ^6.8.0
```


## License

This project is licensed under the MIT License - see the LICENSE file for details.

Made By Nikhil Yadav.
