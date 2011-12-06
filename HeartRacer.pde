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
int minLeft = 20;
int secLeft = 0;
float playerX = 68;
float playerX_old = 68;
int playerY = 70;
int playerY_old = 68;
int score = 0;
float playerXvel = 0;
float playerXaccel = 0;
float playerSpeed = 0;
float playerAccel = 0;

TVout tv;

void setup(){
  tv.begin(_NTSC, W, H);
  tv.select_font(font4x6);

  //test truck
  tv.draw_rect(50,20,10,18,1);
}

void loop(){
  handleInput();
  drawRoads();
  drawPlayer();
  drawStatusBar();
  delay(10);
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
}






