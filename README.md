# Pani Bagh Pro

> An industrial-grade Flutter IoT dashboard for live water tank monitoring and smarter irrigation management.

![Project Logo](assets/logo-placeholder.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11%2B-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](#license)

## Overview

Pani Bagh Pro is designed for real-time water tank monitoring using Flutter and IoT services. It combines live BLE sensor data, a fluid tank widget, analytics charts, and on-device ML predictions to help farmers and home gardeners manage water resources more intelligently.

## 🚀 Features

- **Live Monitoring** – Real-time water level display with a custom liquid tank widget.
- **ML Predictions** – Uses `model.tflite` to estimate time-to-empty based on recent usage patterns.
- **Analytics & History** – Visual charts powered by `fl_chart` for usage trends and historical insights.
- **Bluetooth Connectivity** – BLE integration for real-time sensor updates using `flutter_blue_plus`.
- **Data Logging** – Save sensor logs to CSV and export to a PC via `share_plus`.
- **Modern Dashboard UI** – Includes a collapsing `SliverAppBar`, drawer navigation, and industrial design.

## 📁 Project Structure

- `lib/dashboard.dart` – Main dashboard UI and widget layout.
- `lib/services/mock_service.dart` – Mock data stream for water-level testing.
- `lib/widgets/water_tank.dart` – Custom tank visualization.
- `lib/widgets/history_chart.dart` – Live history graph implementation.
- `assets/model.tflite` – ML model for predicting water depletion.

## 🧠 ML Prediction Logic

Pani Bagh Pro uses an on-device TFLite model for water depletion forecasting:

1. **Inputs**: recent water-level readings and usage trends.
2. **Inference**: the model predicts how many hours until the tank is expected to empty.
3. **Output**: the dashboard displays a time-to-empty estimate so users can act before water runs out.

This lets the app move beyond simple monitoring to proactive water management.

## ⚙️ Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/<your-org>/pani_bagh.git
   cd pani_bagh
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

> If you need desktop support, run `flutter config --enable-linux-desktop` (or the equivalent for macOS/Windows).

## 🖼️ Screenshots

| Dashboard View | Analytics | History Log |
|---|---|---|
| ![Dashboard](assets/screenshot-dashboard.png) | ![Analytics](assets/screenshot-analytics.png) | ![History](assets/screenshot-history.png) |

> Replace the placeholder screenshot paths with the actual images from your project.

## 📦 Dependencies

- `flutter_blue_plus` – Bluetooth LE connectivity
- `path_provider` – File storage for CSV logs
- `share_plus` – Export logs to PC/devices
- `google_fonts` – Custom typography support
- `fl_chart` – Line and bar chart visualizations

## 🛠️ Recommended Workflow

- Use the `MockService` while developing UI and chart flows.
- Connect BLE hardware only when testing real sensor data.
- Keep `model.tflite` in `assets/` and update the model path if needed.

## ✅ License

This project is released under the MIT License. See `LICENSE` for details.
