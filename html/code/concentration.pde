/*
 Concentration Game
 @milan.ghosh
 */

/* @pjs preload="data/0.jpg,data/1.jpg,data/2.jpg,data/3.jpg,data/4.jpg,data/5.jpg,data/6.jpg,data/7.jpg,\
data/8.jpg,data/9.jpg,data/10.jpg,data/11.jpg,data/12.jpg,data/13.jpg,data/14.jpg,data/15.jpg, \
data/16.jpg, \
data/17.jpg, \
data/18.jpg, \
data/19.jpg, \
data/20.jpg, \
data/21.jpg, \
data/22.jpg, \
data/23.jpg, \
data/24.jpg, \
data/25.jpg, \
data/26.jpg, \
data/27.jpg, \
data/28.jpg, \
data/29.jpg, \
data/30.jpg, \
data/31.jpg, \
data/prize0.jpg, \
data/prize1.jpg, \
data/prize2.jpg, \
data/prize3.jpg, \
data/prize4.jpg, \
data/prize5.jpg, \
data/prize6.jpg, \
data/prize7.jpg, \
data/prize8.jpg, \
data/prize9.jpg
"
*/

// used to keep track of which pictures are currently flipped
int flipped1 = -1;    
int flipped2 = -1;
// number of pictures currently flipped
int quantityflipped;
// number of pictures that have been vanished, or matched
int vanishedTileCount;



// used to start with start screen and move on
int screenCount = 0;


// number of boxes, only use square numbers
int b = 16;
// Current difficulty setting, initial settings are easy, used for displaying difficulty
String d = "Easy";
// time allowed to finish game in seconds, initial easy setting is 60
int timeLimit = 45;

// records number of clicks to win game, 
int clickCount;


// initialize tile array to largest possible size
Tile [] tile = new Tile[64];

// initialize image array to largest possible size
PImage [] pics = new PImage [64];
// initialize image int array to largest possible size
// sthis is used to compare 2 pictures
int [] compics = new int [64];

// hidden background picture
PImage [] prize = new PImage [10];
// which prize is going to be shown
int prizepic;


// Used to keep track of time throughout the game

// records the time game is started
int start;
// just keeps track of the current time
int now;
// game time elapsed, time limit timer, basically now - start
int gameTime;



/* Record time at which there are two tiles displayed, then compare it to the now time 
 to set them to flip back over at a certain amount of time
 */
int tileTime;

// used to proceed to win screen after game has been won
int endClick;

// Version of the game
String gameVersion = "1.0";



// Load soundfile, use this for sound when a pair of tiles are vanished  
// import processing.sound.*;
// SoundFile success;
// sound for when sound is turned on
// SoundFile sclickedon;
// sound on or off, default is on
boolean soundSet = false;




void setup() {
  // background(255);
  size(500, 550);
  fill(0);


  // **** cite photos from the website pexels.com
  // load the prize images
  for (int i = 0; i <10; i++) {
    prize[i] = loadImage("data/prize" + i + ".jpg");
  }



  /*
  // two different sounds that get played
  success = new SoundFile(this, "success.wav");   this sound is 
   from https://www.freesound.org/people/fins/sounds/171670/

  sclickedon = new SoundFile(this, "sclickedon.wav");  this sound 
   is from https://www.freesound.org/people/NenadSimic/sounds/171697/

   */
}



void draw() {
  background(255); 

  if (screenCount == 0) {
    startScreen();
  } else if (screenCount == 1) {   // actually game playing part
    image(prize[prizepic], 0, 0, width, height);  // random prize picture in background

    for (int i = 0; i < b; i++) {
      tile[i].render(i);    // draw all the tiles
    }
    if ((now-tileTime)>1) {   // if two have been flipped for more than 1 second
      gameController();   // run gamecontroller to vanish or flip it
    }
    gameTimer();  // used to keep track of how much time has passed, and set time limit
  } else if (screenCount == 2) {
    background(255);
    optionMenu();
  } else if (screenCount == 3) {
    creditsScreen();  // gives credit for sound and images
  } else if (screenCount == 4 ) {
    winScreen();
  } else if (screenCount == 5) {
    loseScreen();
  }
}

void mousePressed() {
  if (screenCount==1) {

    gameController();   // function to control matching part

    /*This controls the flipping part of the game, it checks to see if the tile is still
     in play and if it was clicked on, and if it is not flipped, then flip it and set the
     flipped variables
     */

    int sl = width / sqrt(b);
    x = (int)(mouseX / sl);
    y = (int)(mouseY / sl);
    int i = (sqrt(b) * y) + x ;


    if (tile[i].clickedon()) {     // if tile has been clicked on

      console.info("Clicked on tile: " + i);

      if (tile[i].available) {   // if tile has been vanished yet
        clickCount++;
        if (tile[i].flipped) {   // if tile is currently flipped
          // tile[i].unflip();               // then flip it over
        } else {   // if tile is currently NOT flipped over
          flipped1 = flipped2;   // record previously flipped as flipped 1
          tile[i].flip();      // flip over currently clicked on tile
          flipped2 = i;        // record currently flipped as flipped 2
          quantityflipped ++;
        }
      }
    }
    /* record time when there are two tiles flipped over, this (tileTime) is used to add a slight
     delay before the program checks to see if the two are flipped over, so the user can see 
     them and either click again to unflip them, or the game will do it automatically
     */
    if (quantityflipped == 2) {
      tileTime = now;
    }
  }
}

/* this function controls the matching part of the game. whenever there are two tiles
 currently flipped over, it sees if they are the same, if they are it plays the sound
 and vanishes them and resets the variables that keep track of what is flipped over,
 if they are not the same, they get flipped back over
 */
void gameController() {   
  if (quantityflipped==2) {
    if (compics[flipped1] == compics[flipped2]) {  // if the two flipped pics are the same
      if (soundSet) {        // if sound is turned on, play sound when matched
        // success.play();
        quantityflipped==2;
      }
      console.info("Found a match!");
      tile[flipped1].vanish();                // then vanish them both
      tile[flipped2].vanish();
      flipped1 = -1;                // and reset the flipped variables
      flipped2 = -1;
      quantityflipped = 0;
      vanishedTileCount += 2;
    } else {                          // if the two flipped pics are not the smae
      console.info("Not a match :( Unflipping pics.")
      tile[flipped1].unflip();       // unflip them
      tile[flipped2].unflip();
      flipped1 = -1;              // and reset the flipped variables
      flipped2 = -1; 
      quantityflipped = 0;     
    
    }
  }
}



// controls all of the time parts of the game
// displays on screen timer and keeps track of time
void gameTimer() {
  now = millis()/1000;  // just record the current time


  // just make bottom part of screen white during gameplay
  fill(255);
  rect(0, height, width, 50);

  fill(255, 0, 0);

  // just displays instructions on bottom of screen during gameplay

  // If game has not been won yet, still playing
  if (!terminatePlay()) {     
    gameTime = now - start;  // keep track of the current elapsed game time

    // onscreen timer if still playing

    int timeLeft = timeLimit - gameTime;  

    /* just how much time is left, displayed
     on bottom of game screen
     */
    if (timeLeft == 1) {   // if there is one second left use "second"
      text("You have " + timeLeft  + " second left", width/2, 635);
    } else {   // if there is any other time say "seconds"
      text("You have " + timeLeft  + " seconds left", width/2, 635);
    }
  } else {  
    // if game has been won, let them look at prize pic, and tell them to click to proceed
    text("Click to proceed to end screen", width/2, 635);
  }
  
  
  if (gameTime >= timeLimit) {  // if you take too long
    screenCount = 5;   // go to the lose screen
  }
  
  
  // println("gameTime is " + gameTime);
}



/*Load up all the required images and tiles
 Only create as much as needed, this program to be run when play is clicked,
 once this runs, no more changes can be made
 */

// ***** cite photos from the website pexels.coms
void setPlay() {

  console.info("starting to set play");

  // create all the tiles 
  for (int i = 0; i < b; i++) {
    tile[i] = new Tile(i);
  }

  // load up all of the required images
  for (int i = 0; i < b; i++) {
    console.info("load image: data/" + (int)(i/2) + ".jpg")
    pics [i] = loadImage("data/" + (int)(i/2) + ".jpg");
    compics [i] = (int)(i/2);
  }
  console.info("finished setting play");
}

// shuffle the images using a three way swap, shuffle the compics the exact same way
// gets run when play is pressed
void imageShuffle() {
  console.info("Starting image shuffle");
  for (int n = 0; n < 10000; n++) {
    int i = (int)(random(b));
    int j = (int)(random(b));

    PImage temp = pics[i];
    pics [i] = pics [j];
    pics [j] = temp;

    // this follows the movement of the PImage, necessary to compare locations of pictures
    // because pictures themselves couldn't be compared
    int comtemp = compics [i];
    compics [i] = compics [j];
    compics [j] = comtemp;
  }
  console.info("Finished image shuffle");
  
}




// everything that is displayed at the start of the game
// the home screen with options to play, go to options screen, or credit screen
void startScreen() {        // screenCount = 0
  rectMode(CORNER);
  background(#E75535);
  fill(255);  // title color
  textAlign(CENTER);
  textSize(40);
  text("Jeu du Memory", width/2, height/5);
  textSize(20);
  text("Trouvez les paires de cartes identiques \navant la fin du temps imparti", width/2, height*3/10);

  // two boxes for play and options button
  fill(#2C23B7); // box color
  rect(width/6, height*5/7, width/4, height/8);
  rect((width-(width/4)-(width/6)), height*5/7, width/4, height/8);

  // two texts for play and options button
  int buttonTextSize = 30;
  textAlign(CENTER, CENTER);
  textSize(buttonTextSize);
  fill(255);
  text("Play", (width/6) + (width/8), (height*5/7)+(height/16));
  text("Options", (width-(width/4)-(width/6)) + (width/8), (height*5/7)+(height/16));



  // Credits button

  // credits box, beneath the other two
  fill(#2C23B7); // box color
  rect((width/2-width/12), height*8/9, width/6, height/12);

  // credits text 
  fill(255);
  textSize(20);
  text("Credits", ((width/2-width/12) + width/12), (height*8/9 + height/24));




  // if any of the buttons are clicked on
  if (mousePressed) {
    if (mouseX>width/6 && mouseX<(width/6+width/4) && mouseY>height*5/7 && mouseY<(height*5/7+height/8)) { /* if play is clicked 
     load up all the images and tiles and shuffle them, record start time, and begin playing  
     */
      console.info("clicked to start play");
      setPlay();   // inputs values for the arrays and loads up the pictures into the array
      imageShuffle();   // shuffle images
      start = millis()/1000;  // set the start time variable
      screenCount = 1;   // start playing
      prizepic = int(random(10));  // choose one random picture as the prize
      console.info("play has been started");
    }
    if (mouseX>(width-(width/4)-(width/6)) && mouseX<((width-(width/4)-(width/6))+width/4) && mouseY>height*5/7 && mouseY<(height*5/7+height/8)) {  // if options is clicked
      console.info("clicked to option menu");
      screenCount = 2;    // go to option menu
    }
    if ( mouseX > (width/2-width/12) && mouseX<((width/2-width/12)+width/6) && mouseY> height*8/9 && mouseY < (height*8/9 + height/12)) { // if credits is clicked
      console.info("clicked to credits menu");
      screenCount = 3; //  go to credits menu
    }
  }


  // current difficulty gets displayed on the screen
  textAlign(CENTER);
  textSize(28);
  fill(255);
  text("Current Difficulty is " + d, width/2, height*3/5);
}







void optionMenu() {    // screenCount ==2
  background(#DA47A6);
  textAlign(CENTER);

  fill(0);
  textSize(40);
  text("Options", width/2, height/5);

  textSize(25);
  text("Current Difficulty:", width/4, height/3);

  // rectangles for options

  rectMode(CORNER);
  fill(0, 0, 0, 30);
  rect(width/7, height*9/20, 100, 40);
  fill(0, 0, 0, 50);
  rect(width/7, height*11/20, 100, 40);
  fill(0, 0, 0, 70);
  rect(width/7, height*13/20, 100, 40);


  // text for options
  textSize(20);
  textMode(CENTER, CENTER);
  fill(0);
  text("Easy", width/4, height*9/20 + 30);
  text("Medium", width/4, height*11/20 +30);
  text("Hard", width/4, height*13/20 +30);
  // current difficulty

  // write out current difficulty 
  text(d, width/4, height*2/5);

  // back button
  fill(0, 0, 0, 20);
  rect(width/16, height/16, width/5, height/10);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Back", (width/16 + width/10), (height/16 + height/20));

  // changing difficulty
  if (mousePressed) {
    if (mouseX > width/7 && mouseX < (width/7 + 100) && mouseY > height*9/20 && mouseY < (height*9/20 + 40)) {
      console.info("easy difficulty selected");
      b = 16;  // easy
      d = "Easy";
      timeLimit = 45;
    } else if (mouseX > width/7 && mouseX < (width/7 + 100) && mouseY > height*11/20 && mouseY < (height*11/20 + 40)) {
      console.info("medium difficulty selected");
      b = 36;  // medium
      d = "Medium";
      timeLimit = 90;
    } else if (mouseX > width/7 && mouseX < (width/7 + 100) && mouseY > height*13/20 && mouseY < (height*13/20 + 40)) {
      console.info("hard difficulty selected");
      b = 64;  // hard
      d = "Hard";
      timeLimit = 150;
    } 
    // back button
    if (mouseX > width/16 && mouseX < (width/16 + width/5) && mouseY > height/16 && mouseY < (height/16 + height/10)) {
      screenCount = 0;
    }
  }
  int t = 20;  
  rectMode(CENTER);
  // Sound on or off
  textSize(25);
  text("Sound", width*3/4, height/3);


  String sound = "";    // initialize to nothing
  String oppsound = "";  // opposite of sound
  if (soundSet == false) {   // if sound is off
    t = 70;
    sound = ("on");      // give the on option
    oppsound = ("off");
  } else if (soundSet == true) {
    t = 20;
    sound = ("off");
    oppsound = ("on");
  }
  // draw the sound change box
  rectMode(CORNER);
  fill(0, 0, 0, t);
  rect(width*5/8, height/2, width/4, height/9);

  textSize(20);
  fill(0);   // write out current sound
  text("Sound is " + oppsound, width*3/4, height/3+50); 

  // text for inside sound change box
  fill(0);
  textSize(17);
  textAlign(CENTER, CENTER);
  text("Turn sound " + sound, width*3/4, height/2 + height/18);
}

// used to control certain clicks that had to be done at the end of click
void mouseClicked() {
  if (screenCount == 2) {   // if option screen
    if (mouseX > width*5/8 && mouseX < (width*5/8 + width/4) && mouseY > (height/2) && mouseY < (height/2 + height/9)) {
      if (soundSet == false) {  // just do the opposite of current
        soundSet = true;
        // sclickedon.play();
      } else if (soundSet == true) {
        soundSet = false;
      }
    }
  }

  // put in here so it is not clicked by accident at the end of game
  if (screenCount == 4 || screenCount ==5) {  // if win screen
    // click on return to home screen button
    if (mouseX > width/5 && mouseX < (width/5 + width*3/5) && mouseY > height*2/5 && mouseY < (height*2/5 + height/10)) { 
      screenCount = 0;   // go back to home screen if box clicked
      // reset all the other counter variables
      clickCount = 0;
      quantityflipped = 0;
      flipped1 = -1;
      flipped2 = -1;
      vanishedTileCount = 0;
    }
  }

  if (screenCount == 1) {
    if (terminatePlay()) {
      endClick ++;
    }

    // if mouse is pressed when game has been won, go to homescreen
    if (terminatePlay()) {
      if (endClick > 1) {
        screenCount = 4;
      }
    }
  }
}




void creditsScreen() {  // screenCount == 3
  background(217, 12, 232);

  // back button
  rectMode(CORNER);
  fill(0, 0, 0, 20);
  rect(width/16, height/16, width/5, height/10);
  // back text
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Back", (width/16 + width/10), (height/16 + height/20));
  if (mousePressed) {
    if (mouseX > width/16 && mouseX < (width/16 + width/5) && mouseY > height/16 && mouseY < (height/16 + height/10)) {
      screenCount = 0;
    }
  }

  textSize(40);
  text("Credits", width/2, height/5);

  // actual credits text
  // Photos downloaded from pexels.com
  // Sound downloaded from freesound.org

  textSize(20);
  text("Written and designed by Milan Ghosh\nAdapted by Dorian Voets", width/2, height*2/5);
  text("All sounds legally obtained from freesound.org under \n Creative Commons 0 License", width/2, height*3/5);
  text("All photos legally obtained from pexels.com under \n Creative Commons 0 License or taken by Milan Ghosh", width/2, height*4/5);

  textSize(12);
  text("Version: " + gameVersion, width/2, height*9.5/10);
}



boolean terminatePlay() {  // run inside other programs to see if game has been won yet
  if (screenCount == 1) {
    if (vanishedTileCount == b) {    // if all tiles are vanished, if game is won
      console.info("all tiles are vanished");
      return true;
    } else {
      return false;
    }
  } else {
    return false;   // if not on play screen return false
  }
}



void winScreen() {  // screenCount == 4
  background(#666666);  // or display prize picture in background
  textSize(25);
  fill(#FF7992);
  text("Congratulations!", width/2, height/5);
  text("You win absolutely nothing!", width/2, height*3/10);
  text("It took you " + gameTime.toPrecision(4)  + " seconds and \n " +  clickCount + " clicks to finish the game.", width/2, height*3/4);

  fill(255);
  textMode(CENTER, CENTER);
  text("Return to home screen", width/2, height*4.65/10);
  rectMode(CORNER);
  fill(0, 0, 0, 50);
  rect(width/5, height*2/5, width*3/5, height/10);
}

void loseScreen() {
  // text saying you lose, you're done

  background(255, 75, 70);
  fill(0);
  textSize(25);
  text("You lose", width/2, height/4);

  fill(0);
  textSize(25);
  textMode(CENTER, CENTER);
  text("Return to home screen", width/2, height*4.65/10);
  rectMode(CORNER);
  fill(0, 0, 0, 50);
  rect(width/5, height*2/5, width*3/5, height/10);

}



class Tile {
  // position and dimensions
  float x;  
  float y;
  float sl;  // side length, only need one, because they are squares


  boolean flipped; // if flipped or not
  boolean available;  // if still in play or not


  Tile(int i) { // int i used to differentiate coordinates for each box
    int p = i%int(sqrt(b));
    int q = (int)(i / int(sqrt(b)));
    sl = width / sqrt(b);
    available = true;
    flipped = false;

    // set the x and y variables by where it is going across and down
    for (int j = 0; j<sqrt(b); j++) {
      if (p==j) {
        x = sl * j;
      }
      if (q==j) {
        y = sl * j;
      }
    }

  }


  void render(int n) {  // have to take input for which image to draw
    if (available) {
      if (flipped) {
        image(pics [n], x, y, sl, sl);
      
      } else {
        // the blank tile, looks the same for them all
        fill(#666666); // fill the rectangles gray
        strokeWeight(2);
        stroke(0);
        rect(x, y, sl, sl);
      }
    }
  }

  boolean clickedon() {
    return(mouseX>x && mouseX<(x+sl) && mouseY>y && mouseY<(y+sl));
  }

  void vanish() {
    console.info("Vanished tile at x:" + x + " y: " + y);
    available = false;
  }

  void flip() {
    console.info("Flipped tile at x:" + x + " y: " + y);
    flipped = true;
  }


  void unflip() {
    console.info("Unflipped tile at x:" + x + " y: " + y);
    flipped = false;
  }
}