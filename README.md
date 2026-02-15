# 📱 IT8108 Mobile Programming – Re-Assessment  
## PersonalityQuiz + To-Do List (UIKit)

![Swift](https://img.shields.io/badge/Swift-5-orange)
![Platform](https://img.shields.io/badge/iOS-17%2B-blue)
![Xcode](https://img.shields.io/badge/Xcode-16.4-blue)
![Architecture](https://img.shields.io/badge/Architecture-MVC-green)

This repository contains **both required guided projects** for the **IT8108 Re-Assessment**:

- 🧠 **Part 1 – PersonalityQuiz**
- 🗂 **Part 2 – To-Do List App**

Both apps were built using:

- **Swift**
- **UIKit (Storyboards)**
- **AutoLayout**
- **MVC Architecture**
- **iOS 17+**

---

# 🧠 Part 1 – PersonalityQuiz

**PersonalityQuiz** is an iOS application built using **Swift + UIKit** that lets users complete interactive quizzes across multiple categories.

## 🎨 Figma Prototype
**High-fidelity prototype:**  
https://www.figma.com/proto/aY5Lh9Rc1fHD5DJszYGUbr/Resit-Project?node-id=7-125&p=f&t=1DoCoWgzEsM2M178-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=7%3A125

---

## ✅ Core Features
- **Single choice questions**
- **Multiple choice questions**
- **Ranged (slider) questions**
- **Result calculation** (dominant personality type)
- **Results display screen**

---

## 🚀 Stretch Goals Implemented

### ✅ Multiple Quiz Categories
Users can choose between:
- **Food Quiz**
- **Animal Quiz**
- **Music Quiz**

Each category includes:
- **10 questions total**
- **4 single-choice**
- **3 multiple-choice**
- **3 ranged questions**

---

### ✅ Randomization
- **Questions shuffle** every time a quiz starts
- **Answers shuffle** (single/multiple choice)
- Ranged endpoints stay correct

---

### ✅ Dynamic UI (Stack Views)
- Answer options generated dynamically
- **No hardcoded layouts**
- Fully AutoLayout responsive

---

### ✅ Quiz History (Local Storage)
- Stored using **UserDefaults**
- History displays:
  - **Quiz title**
  - **Result**
  - **Completion date**
- Includes **empty state** when no history exists

---

### ✅ Quiz Timer
- Countdown per question
- Timer resets each question
- Auto-advances if time expires

---

### ✅ Sharing Feature
Results can be shared using **UIActivityViewController**:
- Quiz title
- Result
- Description

---

# 🗂 Part 2 – To-Do List App

A task management app built using **UIKit + Storyboards**, designed to match the provided Figma UI closely.

## 🎨 Figma Prototype
https://www.figma.com/proto/aY5Lh9Rc1fHD5DJszYGUbr/Resit-Project?node-id=152-2&p=f&t=H7p63Pz8pB6KM5ww-1&scaling=min-zoom&content-scaling=fixed&page-id=2%3A2&starting-point-node-id=152%3A2

---

## ✅ Core Features
- **Add tasks**
- **Edit tasks**
- **View tasks in a card-style list**
- **Mark tasks as completed**
- **Filter by category**
- **Local persistence (TodoStore)**
- Custom **card UI** using `UITableViewCell`

---

## 🚀 Extra / Stretch Features

### ✅ Search
- Real-time search filtering
- Matches **title + notes**
- Case-insensitive

---

### ✅ Categories & Filtering
Segments include:
- **All**
- **Work**
- **Personal**
- **Completed**

---

### ✅ Due Dates
- Custom wheel-style date picker sheet
- Displays formatted due date:
  - `MMMM d, yyyy • h:mm a`

---

### ✅ Reminders (Notifications)
- Built using **UNUserNotificationCenter**
- Automatically cancels reminders if:
  - Task is completed
  - Due date is turned off

---

### ✅ Sharing
Tasks can be shared using **UIActivityViewController**:
- Title
- Category
- Due date (if set)
- Notes (if set)

---

# 🏗 Architecture & Standards

Both apps follow:

- **MVC Design Pattern**
- **UIKit (Storyboards)**
- **AutoLayout constraints**
- Clean naming + structured folders  
  (**Controllers / Models / Views / Resources**)

✅ No third-party libraries were used.

---

# ⚙️ Setup Instructions

## ✅ Requirements
- macOS
- **Xcode 16+**
- iOS **17.0+** (Simulator)

---

## ▶️ Run the Project

Clone the repository:

```bash
git clone https://github.com/MohamedBH3/ProjectResit.git
```
Open the PersonalityQuiz or ToDoList Folder:

open To-DoList.xcodeproj or PersonalityQuiz.xcodeproj
---

## ▶️ Then in Xcode

1. **Choose a simulator**  
   *(iPhone 15 / iPhone 16 Pro recommended)*

2. **Select the target:**
   - `PersonalityQuiz` - `ToDoList`

3. Press **Run (▶)**

---

## ✅ Stability & Testing

Both apps were tested in the **iOS Simulator** and run with:

- ✅ **No crashes**
- ✅ **No runtime errors**
- ✅ **No forced unwrap issues**
- ✅ **All navigation flows fully functional**

---

## 🎨 App Icon & Launch Screen

- Custom **1024×1024 square app icon**
- Proper **AppIcon asset configuration**

**Launch screen includes:**
- Centered app icon  
- App title label  
- Safe Area AutoLayout constraints  

---

## 📚 References

- Apple – *Develop with Swift Fundamentals*
- Apple – *Develop with Swift Data Collections*
- Apple – *UIKit Documentation*
- Apple – *SF Symbols*
- Figma (UI prototyping tool)
