# 🌱 Smart AquaGrid

**AI-powered IoT Precision Farming System for Small & Marginal Farmers**  
Empowering agriculture with smart irrigation, real-time analytics, and human-centric innovation.

---

## 📌 Overview

**Smart AquaGrid** is a next-gen precision farming platform that uses **ESP32 IoT sensors**, **AI-powered decision-making**, and **real-time heatmaps** to optimize irrigation, crop planning, and yield prediction. Built with accessibility in mind, the system supports **multilingual chatbot guidance**, enabling even tech-illiterate farmers to benefit from smart agriculture.

> *“We don’t just automate irrigation—we empower the roots of our nation with intelligence, equity, and dignity.”*

---

## 🔍 Features

- 🌾 **Smart Irrigation** using soil moisture sensors (ESP32-based)
- 📊 **Heatmap Visualization** of moisture zones for precision watering
- 🤖 **AI Crop Yield Prediction** based on sensor and weather data
- 🌦️ **Integrated Weather Analysis** for climate-resilient farming
- 📈 **Market Price Forecasting** for smart crop selling
- 🗣️ **Multilingual Chatbot** with voice/text interface for low-literacy users
- 💧 Saves **up to 50% water** while boosting productivity

---

## 🏗️ System Architecture

---
                 
IoT sensors (ESP32 with soil moisture and DHT11) capture live field data and transmit it to Firebase in real time.

Data Storage & Sync
Firebase Realtime Database or Firestore stores historical and real-time data. Firebase Authentication manages user roles.

Dashboard Access
Farmers and admins access the Flutter-powered dashboard to monitor field health, crop status, and system alerts.

AI Intelligence Layer
Python-based machine learning models hosted on Google IDX analyze incoming data to:

Predict crop yield

Identify potential diseases

Forecast market prices

Heatmap Generation
MATLAB scripts process sensor data and produce dynamic moisture heatmaps that guide smart irrigation.

Weather Integration
Real-time weather data helps optimize watering schedules and alerts farmers of adverse climate conditions.

Multilingual Chatbot
A conversational assistant provides support via voice/text, making smart insights accessible even for non-literate users.

## 🧠 Tech Stack

| Layer           | Tools/Tech                           |
|----------------|---------------------------------------|
| Microcontroller| ESP32 DevKit V1                       |
| Sensors        | Capacitive Soil Moisture Sensor, DHT11|
| Programming    | Arduino IDE (C++), PlatformIO         |
| AI & Backend   | Python (Flask or Firebase Functions)  |
| Frontend       | Flutter (for mobile/web app)          |
| Database       | Firebase Realtime DB / Firestore      |
| Visualization  | Dynamic Heatmaps (Flutter + Firebase) |
| Hosting        | Firebase Hosting / Vercel             |


---

## ⚙️ Getting Started

### 1. Hardware Setup
- Use 4x ESP32 boards and soil moisture + DHT11 sensors
- Flash using Arduino IDE (see `/iot-code` folder)
- Upload data to Firebase Realtime Database

### 2. Flutter App
- Clone the repo and open in VSCode or Android Studio
- Update Firebase config in `lib/firebase_options.dart`
- Run:  
```bash
flutter pub get
flutter run

