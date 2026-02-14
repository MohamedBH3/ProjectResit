PersonalityQuiz – IT8108 Mobile Programming (Re-Assessment)
Project Overview

PersonalityQuiz is an iOS application built using Swift (UIKit and Storyboards) that allows users to complete interactive personality quizzes across multiple categories.

The app follows the full mobile development workflow including:

UI/UX prototyping in Figma

MVC architecture implementation

AutoLayout for responsive design

Local data persistence

Stretch goal feature implementation

This project fulfills Part 1 – Guided Project: Personality Quiz of the IT8108 re-assessment.

Figma Prototype

High-fidelity interactive prototype:

https://www.figma.com/design/aY5Lh9Rc1fHD5DJszYGUbr/Resit-Project?node-id=7-125&t=NL8eNbRxye6yvXQj-1

The prototype includes:

All main screens

Screen transitions

Interactive flows

Stretch goal screens

Final visual design matching the implementation

Architecture and Standards

Setup Instructions
Requirements

macOS

Xcode 15 or 16

iOS 17.0 or later (Simulator target)

Steps to Run

Clone the repository:

git clone https://github.com/YOUR-USERNAME/PersonalityQuiz.git


Open the project:

open PersonalityQuiz.xcodeproj


Select:

Simulator: iPhone 15 / iPhone 16 Pro (or any iOS 17+ device)

Build target: PersonalityQuiz

Press Run (▶) in Xcode.

The app runs fully in the iOS Simulator with:

No crashes

No runtime errors

No compiler warnings

Features Implemented
Base Guided Project Features

Single choice questions

Multiple choice questions

Ranged (slider) questions

Result calculation based on dominant personality type

Results display screen

Stretch Goals / Required Features
Multiple Quiz Categories

Users can choose between:

Food Quiz

Animal Quiz

Music Quiz

Each category contains:

10 questions

4 single choice

3 multiple choice

3 ranged questions

Randomized Questions & Answers

Questions are shuffled every time a quiz starts.

Single and multiple choice answers are also shuffled.

Ranged questions maintain correct endpoint logic.

Dynamic Answer Count (Stack Views)

Stack views dynamically handle different numbers of answer options.

UI adapts automatically without hardcoding layouts.

Fully AutoLayout compliant.

Quiz History Screen (Local Storage)

Completed quizzes are stored locally using UserDefaults.

History screen displays:

Quiz title

Result title

Completion date

Empty state view appears when no history exists.

Users can navigate from Results to History.

Quiz Timer

Each question has a countdown timer.

Timer resets for each new question.

If time expires:

The current answer is committed (if applicable).

The quiz proceeds automatically to the next question.

UI / UX Design Implementation

The app follows the design principles specified in the assessment:

Balance

Consistent spacing and symmetrical layout using card-based design for the history screen.

Contrast

Primary actions use a blue accent color. Secondary elements use lighter tones for hierarchy.

Alignment

All elements are aligned using AutoLayout constraints and Safe Area guides.

Simplicity

Minimal interface with clear hierarchy and no unnecessary visual elements.

Proximity

Related content grouped using stack views for clarity and readability.

Rhythm and Repetition

Reusable button styles, consistent typography, and repeated card design elements.

Visibility and Feedback

Button press animations

Highlighted answer selections

Disabled Start button until a quiz is selected

Visible countdown timer feedback

MVC Design Pattern

UIKit (Storyboards)

AutoLayout Constraints

Clean naming conventions

Structured file organization:

Controllers

Models

Views

Resources

Sharing Feature

The results screen includes share functionality using UIActivityViewController.

Users can share:

Quiz title

Personality result

Result description

App Icon and Launch Screen

Custom 1024x1024 square app icon

Properly configured AppIcon asset set

Launch screen includes:

Centered app icon

App title label

Safe Area constraints

External Resources / References

Apple – Develop with Swift Fundamentals

Apple SF Symbols

Apple UIKit Documentation

Figma (UI prototyping tool)

No third-party libraries were used.

App Stability

No crashes

No runtime forced unwrap errors

No duplicate segues

Fully tested in iOS Simulator

All navigation flows functional

Summary

This project demonstrates:

UI/UX design implementation

Dynamic UI using stack views

Randomized quiz logic

Local data persistence

Timer functionality

Clean architecture and industry coding standards
