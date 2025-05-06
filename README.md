# TopAI24 Flutter Assignment

A modern Flutter application that demonstrates user authentication and data management using Firebase and Supabase. This project showcases a clean architecture and beautiful Material Design 3 UI.

## 🌟 Features

- **Google Sign-In**: Seamless authentication using Google accounts
- **User Profile Management**: Store and manage user information
- **Modern UI**: Beautiful Material Design 3 interface with smooth animations
- **Data Persistence**: Secure data storage using Supabase
- **Form Validation**: Robust input validation for user data
- **Responsive Design**: Works on various screen sizes

## 🛠️ Technical Stack

- **Flutter**: Latest stable version
- **Firebase**: Authentication and user management
- **Supabase**: Backend database and storage
- **Provider**: State management
- **Material Design 3**: Modern UI components

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Google Cloud Console account
- Firebase project
- Supabase project

### Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Create a new Firebase project
   - Add your Android/iOS app to the project
   - Download and add the configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. **Configure Supabase**

   - Create a new Supabase project
   - Update the Supabase URL and anon key in `lib/main.dart`
   - Run the following SQL in your Supabase SQL editor:

     ```sql
     create table user_data (
       id text primary key,
       email text not null,
       address text,
       phone_number text,
       age integer,
       notes text
     );

     -- Enable Row Level Security
     alter table user_data enable row level security;

     -- Create policies
     create policy "Users can view their own data"
       on user_data for select
       using (auth.uid() = id);

     create policy "Users can insert their own data"
       on user_data for insert
       with check (auth.uid() = id);

     create policy "Users can update their own data"
       on user_data for update
       using (auth.uid() = id);

     create policy "Users can delete their own data"
       on user_data for delete
       using (auth.uid() = id);
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

- **Screens**

  - Login Screen: Google authentication
  - Home Screen: User data management
  - Profile Screen: User profile and account actions
  - Settings Screen: App settings and account management

- **Services**
  - Auth Service: Handles Firebase authentication
  - Supabase Service: Manages user data operations

## 🔒 Security

- Firebase Authentication for secure user management
- Supabase Row Level Security for data protection
- Secure storage of sensitive information
- Input validation and sanitization

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- Supabase for the backend infrastructure
- Material Design team for the beautiful UI components
