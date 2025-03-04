# Echo Journal: AI-Powered Journal
Echo Journal is a mobile journaling app designe to help users write down their thoughts, track their emotions, and gain actionable insight into their mental well-being. By combining reflective writing with AI-driven emotion analysis, the app fosters self-awareness and provides personalized recommendations to improve emotional resilience.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [AI Integration](#ai-integration)

## Features

- **AI-Powered Emotion Analysis**: Analyze journal entries to detect emotions like happiness, sadness, anger, and calmness.
- **Personalized Recommendations**: Receive tailored suggestions based on your emotional state.
- **Mood Board Visualization**: Track emotional trends over time with an interactive calendar.
- **Photo Integration**: Attach images to your entries for a richer journaling experience.
- **Night Mode**: Enjoy a visually comfortable interface with a customizable night mode.
- **Duplicate Entry Prevention**: Avoid accidental duplicate entries for the same date.

## Installation

### Prerequisites
- macOS or iOS device
- Xcode 14+ installed
- Swift 5.7+

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/rs-dkd/EchoJournal.git

2. Open project in Xcode:
   File > Open > EchoJournal

3. Resolve Dependencies:
   ```bash
   swift package resolve

4. Build and Run:
   Click Run button in Xcode

## Usage

1. **Create a New Entry**:
   - Tap the "+" button to start a new journal entry.
   - Write down your thoughts.
   - Add photos to complement your entry.

2. **Analyze Your Mood**:
   - After saving your entry, choose to analyze your mood.
   - The app will display the detected emotion, an emoji representation, and personalized recommendations.

3. **Track Trends**:
   - Visit the "Mood Board" tab to view your emotional trends over time.
   - Use the calendar to navigate through past entries and reflect on your journey.
   - Enjoy all of the images you included in your entries throughout the month.

## AI Integration

Echo Journal leverages CoreML and a custom-trained machine learning model (`toneDetectorAI`) to analyze the emotional tone of journal entries. Here's how it works:

1. **Text Processing**: The app processes the text of each entry using Natural Language Processing (NLP) techniques.
2. **Emotion Detection**: The AI model predicts one of four emotions—Happy, Sad, Angry, or Calm—based on the content.
3. **Recommendations**: Based on the detected emotion, the app provides actionable suggestions to help users manage their feelings.

This integration transforms simple journaling into a powerful tool for emotional exploration and growth.
