# 📱 REX-47 Mobile App

> **Repository `04`** · The official Flutter companion app for the REX-47 autonomous platform, offering a premium glassmorphic single-column dashboard, low-latency teleoperation HUD, and comprehensive system telemetry.

[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue)]()
[![Language](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart)]()
[![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)]()
[![Styling](https://img.shields.io/badge/UI-Glassmorphism-FF69B4)]()
[![Status](https://img.shields.io/badge/Status-Active%20Development-green)]()

---

## 📋 Table of Contents

- [Overview](#-what-is-this-repository)
- [Architecture](#-architecture)
- [Features](#-features)
- [Design Identity](#-design-identity)
- [Getting Started](#-getting-started)
- [Control Systems](#-control-systems)
- [Dependencies](#-dependencies)
- [Related Repositories](#-related-repositories)

---

## 🧭 What Is This Repository?

This is the **primary mobile interface** for controlling, monitoring, and configuring the REX-47 robotic platform on the go. Built with Flutter, it offers a deeply native, highly responsive experience across both iOS and Android.

**Key Highlights:**
- ✅ **Unified Single-Column Dashboard:** A high-fidelity, scrollable view replacing traditional tabbed navigation for a more immediate overview of robot health.
- ✅ **Teleoperation HUD:** A dedicated, landscape-only control interface featuring a live MJPEG stream and dual-joystick mobility.
- ✅ **Hybrid Connectivity:** Seamlessly switches between local BLE (Bluetooth Low Energy) for direct control and Internet via API Gateway for remote monitoring.
- ✅ **Rich Notifications:** Detailed event streams alerting the user to obstacle detection, battery warnings, and AI interactions.

---

## 🏗️ Architecture

### Directory Structure

```
04-rex-mobile-app/
├── android/                  ← Native Android build files
├── ios/                      ← Native iOS build files
├── lib/
│   ├── core/                 ← Constants, themes, routes, and utilities
│   ├── data/                 ← Models, repositories, and API clients
│   ├── features/
│   │   ├── auth/             ← Login, Onboarding, OTP Screens
│   │   ├── dashboard/        ← Main scrolling dashboard and widgets
│   │   ├── teleop/           ← Full-screen landscape HUD and joystick logic
│   │   └── settings/         ← App configuration and profile management
│   ├── shared/               ← Reusable GlassCards, Custom Buttons, Loaders
│   └── main.dart             ← Application entry point
├── assets/                   ← Fonts, animations, and image assets
├── pubspec.yaml              ← Dependencies and configuration
└── README.md                 ← This documentation
```

---

## 🎨 Features

### 🚀 **Onboarding & Authentication**

| Module | Description |
|--------|-------------|
| **Splash & Welcome** | A premium entry flow featuring the signature purple REX-47 branding. |
| **Onboarding Types** | Six distinct onboarding screens detailing the platform's capabilities (AI, Telemetry, Autonomy, etc.). |
| **Auth Flow** | Secure Login, Registration, and OTP recovery, perfectly aligned with the Glassmorphic design system. |

### 📊 **Unified Dashboard**

| Component | Description |
|-----------|-------------|
| **Status Metrics Grid** | Essential cards detailing Compute load, Sensor health, Connectivity strength, and Battery. |
| **Quick Actions** | A grid of instantly accessible commands (e.g., Return to Base, Enter Patrol Mode, Calibrate). |
| **Event Notifications** | A live feed of system events with descriptive subtitles and severity indicators. |

### 🎮 **Robot Teleoperation HUD**

| Feature | Description |
|---------|-------------|
| **Live Video Feed** | Low-latency MJPEG streaming from the robot's main camera serving as the background. |
| **Transparent Controls** | Glassmorphic dual-joystick overlays for multi-directional driving and camera panning. |
| **Precision Sliders** | Fine-tuned joint manipulation inputs for delicate operations. |
| **Safety Overrides** | Immediate E-Stop functionality prioritizing user safety. |

---

## 💜 Design Identity

The REX-47 mobile app prioritizes a **premium, "wow-factor" aesthetic**:
- **Purple-Themed Visual Identity:** A consistent, branded color palette providing a modern, professional look.
- **Glassmorphism:** Widespread use of `BackdropFilter` to create blurred, translucent cards over complex, gradient-rich backgrounds.
- **Minimalistic White Theme:** Status metrics utilize a refined white-card design with subtle color accents to ensure legibility while maintaining the premium feel.

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK:** ≥ 3.10.x
- **Dart:** ≥ 3.0.x
- Android Studio or Xcode (for emulation/deployment)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/thathsarabandara/04-rex-mobile-app.git
cd 04-rex-mobile-app

# 2. Fetch dependencies
flutter pub get

# 3. Run the application
flutter run
```

---

## 📡 Control Systems

The mobile app employs a **hybrid architecture** to ensure robust control:
1. **API Gateway (Internet):** Used for long-distance monitoring, telemetry streaming, and high-level autonomous commands. Relies on JWT authentication.
2. **Bluetooth Low Energy (BLE):** Used for ultra-low latency teleoperation when in physical proximity to the robot. Bypasses the cloud to communicate directly with the ESP32 hardware via the `02-rex-firmware` GATT server.

---

## 📦 Dependencies

### Core Plugins
- `flutter_bloc` / `provider` — State management
- `dio` — Robust HTTP client for API interactions
- `flutter_blue_plus` — BLE communication stack
- `web_socket_channel` — Real-time telemetry ingestion
- `shared_preferences` — Local storage caching

### UI & Styling
- `glassmorphism` — Premium UI effects
- `flutter_svg` — Vector asset rendering
- `google_fonts` — Modern typography integration

---

## 🔗 Related Repositories

- [01-rex-architecture](../01-rex-architecture) — REX-47 System Architecture
- [03-rex-web-dashbaord](../03-rex-web-dashbaord) — REX-47 Web Dashboard
- [05-rex-api-gateway](../05-rex-api-gateway) — REX-47 API Gateway
- [06-rex-auth-service](../06-rex-auth-service) — REX-47 Auth Service
