#include <Arduino.h>
#include <EnableInterrupt.h>
#include <RotaryEncoder.h>
#include <EEPROM.h>

#define ROTARY_A A0
#define ROTARY_B A1
#define ROTARY_MIN 0
#define ROTARY_MAX 255
#define TACHOMETER_PIN 3
#define SPEED_PIN 5
#define MINUTE_MS 60000
#define DEBOUNCE_MS 1000
#define EE_ENCODER_IDX 0

volatile int tach_value = 0;
volatile int prev_time = 0;
volatile int last_pos = 128;
volatile int ms_since_db = 0;
volatile bool update = false;

RotaryEncoder encoder(ROTARY_A, ROTARY_B);

void tach_change() {
    if (prev_time == 0) {
        prev_time = millis();
        return;
    }

    int now = millis();
    tach_value = now - prev_time;
    prev_time = now;
}

int clamp(int val, int min, int max) {
    if (val < min) {
        return min;
    }
    if (val > max) {
        return max;
    }
    return val;
}

int clamp_rotary(int val) {
    return clamp(val, ROTARY_MIN, ROTARY_MAX);
}

void setup() {
    Serial.begin(115200);
    enableInterrupt(TACHOMETER_PIN, tach_change, CHANGE);

    // time since last output
    ms_since_db = millis();

    last_pos = clamp_rotary(EEPROM.read(EE_ENCODER_IDX));
    encoder.setPosition(last_pos);
    analogWrite(SPEED_PIN, last_pos);
    Serial.print("restored pos: ");
    Serial.println(last_pos);
}

int ms_to_rpm(int ms) {
    return MINUTE_MS / ms;
}

int tach_value_to_rpm(int tach) {
    return ms_to_rpm(tach * 2);
}

void loop() {
    encoder.tick();
    int now = millis();

    if (now - ms_since_db > DEBOUNCE_MS) {
        Serial.print("rpm: ");
        Serial.println(tach_value_to_rpm(tach_value));
        ms_since_db = now;
        if (update) {
            EEPROM.write(EE_ENCODER_IDX, last_pos);
            update = false;
            Serial.print("saved value: ");
            Serial.println(last_pos);
        }
    }

    int new_pos = encoder.getPosition();
    int clamped = clamp_rotary(new_pos);
    if (new_pos != clamped) {
        new_pos = clamped;
        encoder.setPosition(clamped);
    }

    if (new_pos != last_pos) {
        last_pos = new_pos;
        analogWrite(SPEED_PIN, last_pos);
        Serial.print("new position: ");
        Serial.println(last_pos);
        update = true;
    }
}

