# Smart Parking System: IoT & Godot Integration

## 📝 Project Overview
This project is an automated smart parking solution designed to bridge the gap between physical parking infrastructure and digital user interfaces. By utilizing **ESP32** microcontrollers as edge devices and the **Godot Engine** for a cross-platform application, the system detects parking spot occupancy in real-time and provides users with an intuitive, live-updating map to find available spaces instantly.

---

## 🚀 Key Objectives
* **Automated Detection:** Replace manual spot checking with high-accuracy IoT sensors.
* **Real-Time Synchronization:** Ensure sub-second latency between a vehicle parking and the app updating.
* **User Efficiency:** Drastically reduce "cruising time" for drivers, lowering fuel consumption and lot congestion.
* **Scalable Infrastructure:** Create a modular system where new sensor nodes can be added to the network without redesigning the UI.

---

## 🛠 Tech Stack
### **Frontend (Mobile/Desktop App)**
* **Engine:** Godot Engine 4.x
* **Logic:** GDScript
* **Features:** 2D/3D Map Rendering, HTTP/WebSocket polling, and dynamic UI state management.

### **Hardware (IoT Edge)**
* **Microcontroller:** ESP32 (Dual-core, Wi-Fi enabled)
* **Sensors:** HC-SR04 Ultrasonic Sensors (for distance-based vehicle detection).
* **Firmware:** C++ (Arduino Framework) for processing raw sensor data into occupancy states.

---

## ⚡ Core Features
* **Live Occupancy Tracking:** The app displays a visual map of the parking lot where spots change from green (vacant) to red (occupied) automatically.
* **Automatic Discovery:** The system identifies the nearest available spot based on the sensor array's data.
* **Hardware-to-Software Bridge:** Direct communication between the ESP32 web server and the Godot HTTPRequest system.
* **Cross-Platform Compatibility:** One codebase deployable to Android, iOS, Windows, and Linux.

---

## 🏗 System Architecture
1. **The Sensing Layer:** The ESP32 triggers the ultrasonic sensor to measure the distance between the floor and any overhead/ground object.
2. **The Logic Layer:** If the distance measured is below a certain threshold (e.g., < 50cm), the ESP32 flags that specific spot ID as "Occupied."
3. **The Communication Layer:** The Godot application sends a request to the IoT device network via a local network or cloud broker.
4. **The Presentation Layer:** Godot parses the incoming JSON data and updates the `modulate` property of the parking spot sprites in the user's view.

---

## 📅 Roadmap
- [ ] **GPS Integration:** Navigation from the user's current location to the specific vacant stall.
- [ ] **Cloud Dashboard:** A web-based admin panel for lot owners to view usage statistics and peak hours.
- [ ] **Reservation System:** A time-stamped booking feature to hold a spot for a set duration.

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.