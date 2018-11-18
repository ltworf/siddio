#define TEMPPIN A0
#define LIGHTPIN A1

void setup() {
    Serial.begin(9600);
}

float read_temperature() {
    int sensorValue = analogRead(TEMPPIN);
    float voltage = (sensorValue / 1024.0) * 5.0;
    float temperature = (voltage - 0.5) * 100;
    return temperature;
}

void loop() {
    delay(200);
    float temperature = read_temperature();
    Serial.print("Temp: ");
    Serial.print(temperature);
    Serial.print("\n");

    Serial.print("Light: ");
    Serial.print(analogRead(LIGHTPIN));
    Serial.print("\n");
}
