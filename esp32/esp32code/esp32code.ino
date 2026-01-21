#include <WiFi.h>
#include <WiFiManager.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoJson.h>


// ===== Ultrasonic pins =====
const int trigPins[4] = {12, 27, 25, 32};
const int echoPins[4] = {13, 14, 26, 33};

// ===== AP info =====
const char* AP_SSID = "EspDomain";
const char* AP_PASS = "Password";

// ===== Detection settings =====
const int DETECT_THRESHOLD = 20; // cm
bool carDetected[4] = {false, false, false, false};
String detectTime[4];
long distances[4] = {0,0,0,0};

// ===== Time / NTP =====
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 8 * 3600;
const int daylightOffset_sec = 0;

// ===== Server / WebSocket =====
AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

// ===== Get current time =====
String getTimeString() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) return "Unknown";
  
  char buffer[30];
  strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%S%z", &timeinfo);
  return String(buffer);
}

// ===== Ultrasonic read =====
long readUltrasonic(int i) {
  digitalWrite(trigPins[i], LOW);
  delayMicroseconds(2);
  digitalWrite(trigPins[i], HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPins[i], LOW);

  long duration = pulseIn(echoPins[i], HIGH, 25000); // 25ms timeout
  if (duration == 0) return 999; // no echo
  
  return duration * 0.034 / 2;
}

// ===== Build JSON for all sensors =====
String buildJSON() {
  StaticJsonDocument<256> doc;

  for (int i = 0; i < 4; i++) {
    JsonObject sensor = doc.createNestedObject(String("sensor") + (i+1));
    sensor["distance"] = distances[i];
    sensor["detected"] = carDetected[i];
    sensor["time"] = detectTime[i];
  }

  String output;
  serializeJson(doc, output);
  return output;
}

// ===== WebSocket events =====
void onWsEvent(AsyncWebSocket *server, AsyncWebSocketClient *client,
               AwsEventType type, void *arg, uint8_t *data, size_t len) {

  if (type == WS_EVT_CONNECT) {
    Serial.printf("[WS] Client connected: %u\n", client->id());
    client->text(buildJSON());
  }
}

// ===== Setup =====
void setup() {
  Serial.begin(115200);

  for (int i = 0; i < 4; i++) {
    pinMode(trigPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
  }

  WiFi.mode(WIFI_AP_STA);

  WiFiManager wm;
  if (!wm.autoConnect("ESP32_Setup")) {
    Serial.println("WiFi failed, restarting...");
    ESP.restart();
  }

  WiFi.setSleep(false);

  Serial.print("Connected to WiFi: ");
  Serial.println(WiFi.SSID());

  WiFi.softAP(AP_SSID, AP_PASS);
  Serial.print("AP IP: ");
  Serial.println(WiFi.softAPIP());

  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println("Time synced");

  ws.onEvent(onWsEvent);
  server.addHandler(&ws);
  server.begin();
}

// ===== Main loop =====
void loop() {
  ws.cleanupClients();

  for (int i = 0; i < 4; i++) {
    distances[i] = readUltrasonic(i);
    bool detectedNow = distances[i] < DETECT_THRESHOLD;

    if (detectedNow != carDetected[i]) {
      carDetected[i] = detectedNow;

      if (detectedNow) {
        detectTime[i] = getTimeString();
        Serial.printf("🚗 Car detected at sensor %d\n", i+1);
      } else {
        Serial.printf("⬆️ Car left sensor %d\n", i+1);
      }

      ws.textAll(buildJSON());
    }
  }

  delay(50); // reduce CPU load
}
