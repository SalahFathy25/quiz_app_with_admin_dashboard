# 🧠 Quiz App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

A beautiful and dynamic Quiz Application built with Flutter and Firebase. This app allows users to take quizzes across various categories, while administrators can easily manage categories and quizzes through a dedicated admin panel.

## ✨ Features

### 👤 User Features
*   **Browse Categories**: Explore a variety of quiz categories.
*   **Take Quizzes**: Engage in interactive quizzes with real-time feedback.
*   **Track Progress**: View your scores and performance.
*   **Beautiful UI**: Enjoy a modern, polished user interface with smooth animations.

### 🛡️ Admin Features
*   **Dashboard**: Overview of app content.
*   **Manage Categories**: Add, edit, and delete quiz categories.
*   **Manage Quizzes**: Create and organize quizzes within categories.
*   **Question Bank**: Add multiple-choice questions with customizable options.

## 📱 Screenshots

| Home Screen | Quiz Screen | Admin Dashboard |
|:-----------:|:-----------:|:---------------:|
| *(Add Screenshot)* | *(Add Screenshot)* | *(Add Screenshot)* |

## 🛠️ Tech Stack

*   **Frontend**: Flutter (Dart)
*   **Backend**: Firebase (Firestore, Auth)
*   **State Management**: `setState` / `StreamBuilder` (Reactive UI)
*   **Styling**: Custom Theme with Google Fonts (`Poppins`)
*   **Animations**: `flutter_animate`

## 🚀 Getting Started

### Prerequisites
*   [Flutter SDK](https://flutter.dev/docs/get-started/install)
*   [Firebase Account](https://firebase.google.com/)

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
    *   Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    *   Configure Android/iOS apps in Firebase.
    *   Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in their respective directories.
    *   Enable **Cloud Firestore** in your Firebase project.

4.  **Run the App**
    ```bash
    flutter run
    ```

## 📂 Project Structure

```
lib/
├── model/          # Data models (Category, Question, Quiz)
├── theme/          # App theme and styling constants
├── view/           # UI Screens
│   ├── admin/      # Admin panel screens (Add Category, Manage Quizzes)
│   └── user/       # User-facing screens
├── main.dart       # Entry point
└── firebase_options.dart # Firebase configuration
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
