# 📱 Article App

## 🚀 Overview

This application fetches and displays articles from a mock API. It includes list and detail screens with a modern Liquid Glass UI. The app includes Sign in with Apple for secure and seamless authentication.

---

## 🛠 Tech Stack

* Swift / SwiftUI
* Alamofire (API)
* Kingfisher (Images)
* Cache (Data caching)
* ReachabilitySwift (Network monitoring)
* Swinject (Dependency Injection)
* XCGLogger (Logging)

---

## 📡 API

https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264

---

## 📦 Installation

### 1. Clone Repository

```bash
git clone https://github.com/your-username/article-app.git
cd article-app
```

### 2. Install Pods

```bash
pod install
```

### 3. Open Project

```bash
open ArticleApp.xcworkspace
```

---

## ▶️ Run Application

* Select iPhone / iPad simulator
* Press **Cmd + R**

---

## 📱 Features

* Uses Apple's Authentication Services framework
* Handles credential state (authorized, revoked, not found)
* Maintains user session securely
* Automatically logs out if credentials are revoked
* Article List (Grid + List)
* Article Detail Screen
* Pull to Refresh
* Offline Mode Handling
* Placeholder Images
* Smooth UI Animations

---

## 🧱 Architecture

Project is structured into layers:

### Models

* Article model (Codable)

### Provider

* Handles API calls using Alamofire

### Managers

* Business logic + caching

### Views

* SwiftUI screens

---

## 📶 Offline Handling

* Detects network using Reachability
* Shows retry option when offline

---

## 🎨 UI Design

* Liquid Glass style
* Adaptive layout for iPhone & iPad

---

## 📂 Folder Structure

* Models
* Providers
* Managers
* Views
* Resources

---

## 👨‍💻 Author

Mohanraj Gopi
