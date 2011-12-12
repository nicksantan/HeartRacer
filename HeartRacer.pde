#include <font4x6.h>
#include <font6x8.h>
#include <font8x8.h>
#include <font8x8ext.h>
#include <fontALL.h>
#include <avr/pgmspace.h>
#include <TVout.h>
#include <video_gen.h>
#include <EEPROM.h>
#include <Controllers.h>

#define W 136
#define H 98

//define initial varianles

//time-related variables
int screenWidth = 115;
int minLeft = 20;
int secLeft = 0;
float playerX = 68;
float truckY = 0;
float playerX_old = 68;
int playerY = 70;
int playerY_old = 68;
int score = 0;
float playerXvel = 0;
float objSpeed = 60;
float relSpeed;
float maxPlayerXVel = 5;
float maxPlayerSpeed = 200;
float minPlayerSpeed = 0;
float playerXaccel = 0;
float playerSpeed = 0;
float playerAccel = 0;
float truckY_old = 0;
float relSpeedInPixels;
float playerSpeedInPixels;
float static1Y;
float static1Y_old;
TVout tv;

float StaticXs[] = {
  4.0,12.0,59.0,142.0,180.0};
float StaticYs[] = {
  1.0,72.0,88.0,40.0,12.0};

void setup(){
  tv.begin(_NTSC, W, H);
  tv.select_font(font4x6);

  //test truck
  // tv.draw_rect(50,20,10,18,1);
}

void loop(){
  handleInput();
  drawRoads();
  drawPlayer();
  drawStatusBar();
  enforceLimits();
  drawObjects();
  delay(10);
}
void drawObjects(){
  //for now, draw a few static pixels
  for (int i=0; i < 6; i++){
    float static1RelSpeed = - playerSpeed;
    float static1RelSpeedInPixels = static1RelSpeed / 10;
    StaticYs[i] = StaticYs[i] - static1RelSpeed;
    tv.set_pixel(StaticXs[i], StaticYs[i], 1);
  }

  static1Y_old =static1Y;
  float static1RelSpeed = - playerSpeed;
  float static1RelSpeedInPixels = static1RelSpeed / 10;
  static1Y = static1Y - static1RelSpeedInPixels; 
  tv.set_pixel(10, static1Y, 1);
  //if the player's position has changed, erase the old sprite
  if (static1Y_old != static1Y){
    tv.set_pixel(10, static1Y_old, 0);
  } 
  else
  { 
    tv.set_pixel(10, static1Y, 1);
  }

  tv.draw_rect(50,truckY,10,18,1);


  truckY_old =truckY;
  relSpeed = objSpeed - playerSpeed;
  relSpeedInPixels = relSpeed / 10;
  truckY = truckY - relSpeedInPixels; 

  //if the player's position has changed, erase the old sprite
  if (truckY_old != truckY){
    tv.draw_rect(50,truckY_old,10,18,0);
  }

  tv.draw_rect(50,truckY,10,18,1);
}
void enforceLimits(){
  //set max and min speed
  if (playerSpeed > maxPlayerSpeed){
    playerSpeed = maxPlayerSpeed;
  }
  if (playerSpeed < minPlayerSpeed){
    playerSpeed = minPlayerSpeed;
  }
  if(playerXvel > maxPlayerXVel){
    playerXvel = maxPlayerXVel;
  }
  if(playerXvel < -maxPlayerXVel){
    playerXvel = -maxPlayerXVel;
  }

  if(playerX > screenWidth){
    playerX = screenWidth;
  }
  if(playerX < 0){
    playerX = 0;
  }


}
void handleInput(){

  playerX_old =playerX;

  if (Controller.leftPressed()) {
    playerXaccel = -0.1;
  }
  else if (Controller.rightPressed()) {
    playerXaccel = 0.1;
  }
  else {
    playerXaccel = 0; 
  }

  if (Controller.upPressed()){
    playerAccel = .5; 
  }
  else if (Controller.downPressed()){
    playerAccel = -.5;
  }
  else {
    //fake friction
    playerAccel = -.05; 
  } 
}

void drawRoads(){
  tv.draw_line(45, 0, 45, 98, 1);
  tv.draw_line(91, 0, 91, 98, 1);


}

void drawPlayer(){

  //update position
  playerXvel = playerXvel + playerXaccel;
  playerX = playerX + playerXvel;
  playerSpeed = playerSpeed + playerAccel;  
  // PlayerSpeedInPixels = playerSpeed / 10;

  //if the player's position has changed, erase the old sprite
  if (playerX_old != playerX){
    tv.draw_rect(playerX_old,playerY,10,12,0);
  }

  //draw the player
  tv.draw_rect(playerX,playerY,10,12,1);
}

void drawStatusBar(){
  tv.print(2,10,"TIME:");
  //draw the time

  //draw the speed
  //put a spedometer bar here?
  //speedString = "SPEED: " + String(playerSpeed);
  tv.print(2,20,"SPEED: ");
  tv.print(playerSpeed);

  //   tv.print(2,30,"RELSPEED: ");
  // tv.print(relSpeed);
  //   tv.print(2,40,"TruckY: ");
  // tv.print(truckY);
  //   tv.print(2,50,"Static1Y: ");
  // tv.print(static1Y);
  //   tv.print(2,60,"Static1Y_old: ");
  //  tv.print(static1Y_old);
}







