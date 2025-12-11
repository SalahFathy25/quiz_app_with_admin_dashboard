# 🧠 Quiz App with Admin Dashboard

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Bloc](https://img.shields.io/badge/bloc-%23151515.svg?style=for-the-badge&logo=bloc&logoColor=white)

A comprehensive and dynamic Quiz Application built with **Flutter** and **Firebase**. This project features a dual-role system (Admin & User), allowing administrators to manage content seamlessly while users enjoy an interactive quiz experience. The app is fully localized (English & Arabic) and supports Light/Dark themes.

---

## ✨ Key Features

### 🛡️ Admin Dashboard
The admin panel provides full control over the application's content:
*   **Dashboard Overview**: Quick stats and navigation.
*   **Category Management**: Create, update, and delete quiz categories.
*   **Quiz Management**: Create quizzes within categories with difficulty levels.
*   **Question Bank**: Add multiple-choice questions with dynamic options and correct answer selection.
*   **Settings**: Manage app preferences.

### 👤 User Experience
*   **Category Browser**: Explore various quiz categories.
*   **Interactive Quizzes**: Take quizzes with a timer and progress tracking.
*   **Instant Results**: View scores immediately after completion.
*   **Progressive UI**: Smooth animations and responsive design.

### 🌍 Universal Features
*   **Authentication**: Secure login with role-based redirection (Admin vs User).
*   **Localization**: Full support for **English** and **Arabic** (RTL support).
*   **Theme Support**: Toggle between **Light** and **Dark** modes.

---

## 📱 Screenshots

| Admin Dashboard | Manage Categories | Add Quiz |
|:---:|:---:|:---:|
| *(Add your screenshot)* | *(Add your screenshot)* | *(Add your screenshot)* |

| User Home | Quiz Interface | Results Screen |
|:---:|:---:|:---:|
| *(Add your screenshot)* | *(Add your screenshot)* | *(Add your screenshot)* |

---

## 🛠️ Tech Stack & Architecture

The application is built using a clean, scalable architecture separating Logic, View, and Services.

*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **Backend**: [Firebase](https://firebase.google.com/) (Firestore, Authentication)
*   **State Management**: `flutter_bloc` (Cubit pattern)
*   **Dependency Injection**: `get_it`
*   **Localization**: `easy_localization`
*   **UI/UX**: 
    *   `flutter_screenutil` (Responsive sizing)
    *   `flutter_animate` (Animations)
    *   `google_fonts`
    *   `percent_indicator`
*   **Navigation**: Named Routes (`onGenerateRoute`)

---

## 📂 Project Structure

```
lib/
├── core/               # Core utilities (DI, Routes, Theme)
├── logic/              # Business Logic (Cubits for Auth, Admin, Home, Quiz)
├── model/              # Data Models (Category, Question, Quiz)
├── services/           # Firebase Services & Repositories
├── view/               # UI Layer
│   ├── admin/          # Admin specific screens
│   ├── auth/           # Login & specific screens
│   ├── user/           # User specific screens
│   └── widgets/        # Reusable widgets
├── main.dart           # Application Entry Point
└── firebase_options.dart # Firebase Configuration
```

---

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   A [Firebase](https://console.firebase.google.com/) project.

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/quiz_app.git
    cd quiz_app
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup**
    *   Create a new project in the Firebase Console.
    *   Enable **Authentication** (Email/Password) and **Cloud Firestore**.
    *   Download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in `android/app/` and `ios/Runner/` respectively.

4.  **Run the App**
    ```bash
    flutter run
    ```

### 🌍 Localization Setup
To add or modify translations, edit the JSON files in:
`assets/translations/en.json` or `assets/translations/ar.json`
Then run:
```bash
flutter pub run easy_localization:generate -S assets/translations
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:
1.  Fork the project.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
