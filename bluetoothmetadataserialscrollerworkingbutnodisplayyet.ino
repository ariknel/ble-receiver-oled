/* Arik Nel 2021 june   
 */

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "BluetoothA2DPSink.h"
#define SCREEN_WIDTH 128 // OLED display width in pixels
#define SCREEN_HEIGHT 32 // OLED display height in pixels
#define OLED_RESET     4 // Reset pin # 
#define SCREEN_ADDRESS 0x3C // 0x3D for 128x64, 0x3C for 128x32 (some x64 models also use 0x3C)

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

BluetoothA2DPSink a2dp_sink;

bool is_active = true;

void avrc_metadata_callback(uint8_t data1, const uint8_t *data2) {
  Serial.printf("0x%x, %s\n", data1, data2);
}

   char message[]="arikarikarikarikarik";
   int x, minX;
   
  void setup(){
  Serial.begin(9600);
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setTextWrap(false);
 
  x = display.width();
  minX = -12 * strlen(message);  // 12 = 6 pixels/character * text size 2
  
  Serial.begin(115200);
  a2dp_sink.set_avrc_metadata_callback(avrc_metadata_callback);
  a2dp_sink.start("audio");  
  }

  void loop(){
       
   display.clearDisplay();
   display.setCursor(0,0);
   display.setTextSize(1);
   display.print("bluetooth receiver by"); // display song author
   display.setTextSize(2);
   display.setCursor(-x,10); // (x,10) -> right to left (-x,10) left to right
   display.print(message);
   display.display();
   x=x-1; // scroll speed, to increase change x=x-2; to x=x-1 // to increase change x=x-1; to x=x-2 for example
   if(x < minX) x= display.width();
}
