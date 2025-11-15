# 📱 Task Manager App  
A Flutter-based mobile application with full CRUD functionality, powered by Back4App (Parse Server) as the backend.

---

## 📌 Project Overview
The **Task Manager App** is designed to help users efficiently manage their daily tasks.  
It uses **Flutter** for building the cross-platform UI and **Back4App (Parse Server)** for cloud storage, authentication, and session management.

The app allows users to:
- Register and log in  
- Create new tasks  
- View all tasks  
- Edit and update task details  
- Delete tasks from cloud storage  

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) |
| **Backend (BaaS)** | Back4App (Parse Server) |
| **Database** | Back4App Cloud Database |
| **IDE** | Android Studio / VS Code |
| **Platform** | Android |

---

## 🗄️ Database Structure (Back4App - Parse Class: `Task`)
| Field Name | Type | Description |
|-----------|-------|-------------|
| `title` | String | Title of the task |
| `description` | String | Task details |
| `dueDate` | Date | Deadline for the task |
| `isDone` | Boolean | Completion status |
| `owner` | Pointer<_User> | The user who created the task |

---

## 🔐 Authentication Flow

- User enters **email & password**  
- Flutter sends request using `ParseUser.login()` or `ParseUser.signUp()`  
- Back4App validates the credentials  
- A **session token** is returned  
- Token is used for all CRUD operations  
- Logout clears the session and resets UI

---

## 🔄 CRUD Operations

### **Create**
Users can add new tasks by providing title, description, and due date.  
Stored using:
```dart
ParseObject('Task')..set('title', ...)..save();
```

### **Read**
All tasks belonging to the logged-in user are fetched using:
```dart
QueryBuilder(ParseObject('Task'));
```

### **Update**
Task fields can be edited and saved:
```dart
taskObject.set('description', ...);
taskObject.save();
```

### **Delete**
Removes the task permanently:
```dart
taskObject.delete();
```

---

## 📂 Project Structure

```
lib/
 ├── main.dart
 ├── models/
 │     └── task.dart
 ├── screens/
 │     ├── login_screen.dart
 │     ├── register_screen.dart
 │     ├── task_list_screen.dart
 │     └── task_editor_screen.dart
 └── services/
       └── parse_config.dart
```

---

## ⚙️ Setup Instructions

### **1. Clone the repository**
```
git clone https://github.com/Akshay-Bodhankar/task_manager_app.git
```

### **2. Install Flutter dependencies**
```
flutter pub get
```

### **3. Configure Back4App**
Insert your keys in `parse_config.dart`:

```dart
const String keyApplicationId = "YOUR_APP_ID";
const String keyClientKey = "YOUR_CLIENT_KEY";
const String keyParseServerUrl = "https://parseapi.back4app.com/";
```

### **4. Run the app**
```
flutter run
```





---

## 🎥 Demo Video  
```
https://github.com/Akshay-Bodhankar/task_manager_app.git
```

---

## 🛠️ Future Enhancements

- Task reminders and notifications  
- Task categories and priority levels  
- Calendar-based task view  
- Offline mode using local storage  
- Dark mode support  
- Task analytics dashboard  

---

## 🧑‍💻 Author
Name: *Akshay Vilas Bodhankar*  
Roll Number: *2024TM93303*  
Course: Cross Platform Application Development  

---

## ⭐ Acknowledgments
- Flutter documentation  
- Back4App documentation  
- Faculty guidance  

---

## 📄 License
This project is for academic and learning purposes only.
