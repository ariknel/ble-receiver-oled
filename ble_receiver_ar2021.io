/* Arik Nel 2021 june
https://www.youtube.com/watch?v=awKqiN6pbCQ&t=21s
*/
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "BluetoothA2DPSink.h"
#define SCREEN_WIDTH 128 // OLED display width in pixels
#define SCREEN_HEIGHT 32 // OLED display height in pixels
#define OLED_RESET     4 // Reset pin # 
#define SCREEN_ADDRESS 0x3C // 0x3D for 128x64, 0x3C for 128x32 (some x64 models also use 0x3C)
unsigned long minutes = 60000; //60k ms -> 1 minute
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
BluetoothA2DPSink a2dp_sink;

bool is_active = true;

void data_received_callback() {
  Serial.println("Data packet received");
}
void avrc_metadata_callback(uint8_t data1, const uint8_t *data2) {
  Serial.printf("0x%x, %s\n", data1, data2);
}

char message[] = "GoeGoeGaGa";
int x, minX;

void setup() {
  pinMode(2, OUTPUT);
  Serial.begin(9600);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setTextWrap(false);
  x = display.width();
  minX = -12 * strlen(message);  // 12 = 6 pixels/character * text size 2

  Serial.begin(115200);
  i2s_pin_config_t my_pin_config = {
    .bck_io_num = 26,      //BCK -> IO26
    .ws_io_num = 25,       //LCK / LRCK -> IO25
    .data_out_num = 18,    //DIN - > IO18
    .data_in_num = I2S_PIN_NO_CHANGE
  };
  a2dp_sink.set_pin_config(my_pin_config);
  a2dp_sink.set_avrc_metadata_callback(avrc_metadata_callback);
  a2dp_sink.start("GoeGoeGaGa");
}

void loop() {
  digitalWrite(2, (millis() / 400) % 2);
  display.clearDisplay();
  display.setCursor(0, 0);
  display.setTextSize(1);
  display.print("bluetooth name:"); // display song author
  display.setTextSize(2);
  display.setCursor(-x, 10); // (x,10) -> right to left (-x,10) left to right
  display.print(message);
  display.display();
  x = x - 1; // scroll speed, to increase change x=x-2; to x=x-1 // to increase change x=x-1; to x=x-2 for example
  if (x < minX) x = display.width();

}
