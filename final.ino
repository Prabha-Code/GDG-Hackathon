#include <WiFi.h>
#include <FirebaseESP32.h>

// Wi-Fi Credentials
#define WIFI_SSID "FREESPOT"
#define WIFI_PASSWORD "sudharsanam.A"

// Firebase Credentials
#define FIREBASE_HOST "https://gdg00-d79b5-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "ZzlRHYKPBDO97SiQ3xhRg9046HtOAZksvy8bJdIj"

// Sensor and Relay Pin Configuration
#define MOISTURE_SENSOR_1 34
#define MOISTURE_SENSOR_2 35
#define MOISTURE_SENSOR_3 32
#define MOISTURE_SENSOR_4 33
#define RELAY_PIN 23

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Convert raw analog to % moisture
int rawToPercentage(int raw) {
    int wet = 1000;  // Calibrated value for wet soil
    int dry = 3500;  // Calibrated value for dry soil

    // Clamp within range
    if (raw < wet) raw = wet;
    if (raw > dry) raw = dry;

    // Map to 0–100%
    return map(raw, dry, wet, 100, 0);
}

void setup() {
    Serial.begin(115200);

    // Pin Modes
    pinMode(MOISTURE_SENSOR_1, INPUT);
    pinMode(MOISTURE_SENSOR_2, INPUT);
    pinMode(MOISTURE_SENSOR_3, INPUT);
    pinMode(MOISTURE_SENSOR_4, INPUT);
    pinMode(RELAY_PIN, OUTPUT);
    digitalWrite(RELAY_PIN, HIGH); // Motor OFF initially

    // Wi-Fi Connection
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(1000);
    }
    Serial.println("\nConnected to Wi-Fi");

    // Firebase Setup
    config.host = FIREBASE_HOST;
    config.signer.tokens.legacy_token = FIREBASE_AUTH;
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
}

void loop() {
    // Raw readings
    int raw1 = analogRead(MOISTURE_SENSOR_1);
    int raw2 = analogRead(MOISTURE_SENSOR_2);
    int raw3 = analogRead(MOISTURE_SENSOR_3);
    int raw4 = analogRead(MOISTURE_SENSOR_4);

    // Convert to percentage
    int moisture1 = rawToPercentage(raw1);
    int moisture2 = rawToPercentage(raw2);
    int moisture3 = rawToPercentage(raw3);
    int moisture4 = rawToPercentage(raw4);

    // Print to Serial Monitor
    Serial.print("Moisture Level 1 (%): "); Serial.println(moisture1);
    Serial.print("Moisture Level 2 (%): "); Serial.println(moisture2);
    Serial.print("Moisture Level 3 (%): "); Serial.println(moisture3);
    Serial.print("Moisture Level 4 (%): "); Serial.println(moisture4);

    // Send to Firebase
    Firebase.setInt(fbdo, "/moisture1", moisture1);
    Firebase.setInt(fbdo, "/moisture2", moisture2);
    Firebase.setInt(fbdo, "/moisture3", moisture3);
    Firebase.setInt(fbdo, "/moisture4", moisture4);

    // Motor Control based on threshold %
    int threshold = 30;
    if (moisture1 < threshold || moisture2 < threshold || moisture3 < threshold || moisture4 < threshold) {
        digitalWrite(RELAY_PIN, LOW); // Turn ON motor
        Firebase.setBool(fbdo, "/motor_status", true);
    } else {
        digitalWrite(RELAY_PIN, HIGH); // Turn OFF motor
        Firebase.setBool(fbdo, "/motor_status", false);
    }

    delay(500); // Wait 5 seconds before next reading
}
