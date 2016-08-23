//Going Underground: a game of everyday awkwardness
//April 2013
//Tom Curtis
//http://www.dinosaursandmoustaches.com/goingUnderground
//
//Released under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported licence
//http://creativecommons.org/licenses/by-nc-sa/3.0/

/* @pjs preload="bigTube.png"; font="slkscr.ttf"; */

//where you're looking
PVector focusLocation;
PVector focusVelocity;
float focusSpeed = 0.7;
float startMillis = 0;
float highScore = 0;
PVector centre;

int pressedTime = 0; //keep track of when last pressed a key, so you can nudge if needed
String[] loseMessages = ["You lose!", "Stop it!", "Oh dear!"]; 

PFont smallFont;
PFont mediumFont;
PFont bigFont;

PImage backgroundPic;
PGraphics carriage;

boolean startScreen = true;

//keep track of current list of passengers
ArrayList<passenger> passengers;

void setup() {
  size(400, 200, P2D);
  frameRate(60);
  
  centre = new PVector(width / 2, (height - 14) / 2);
  focusLocation = new PVector(centre.x, centre.y);
  focusVelocity = new PVector(0, 0);
  
  smallFont = createFont("slkscr.ttf", 12, true);
  mediumFont = createFont("slkscr.ttf", 36, false);
  bigFont = createFont("slkscr.ttf", 72, false);
  
  backgroundPic = loadImage("bigTube.png");
  carriage = createGraphics(backgroundPic.width, backgroundPic.height);
  
  passengers = new ArrayList<passenger>();
  
  ellipseMode(CENTER);
}

void draw() {
  if (startScreen) {
    background(255);
    noStroke();
    fill(255, 1, 15);
    ellipse(width / 2, height / 2, height, height);
    fill(255);
    ellipse(width / 2, height / 2, (height / 2), (height / 2));
    fill(0, 22, 255);
    rectMode(CENTER);
    rect(width / 2, height / 2, 300, 75);
    rectMode(CORNER);
    fill(255);
    textFont(mediumFont);
    textAlign(CENTER);
    text("Going", width / 2, (height / 2) - 5);
    text("Underground", width / 2, (height / 2) + 30);
    fill(0);
    textFont(smallFont);
    text("A game of everyday awkwardness", width / 2, 20);
    text("Press space to start", width / 2, 160);
    text("Use the arrow keys to avoid eye contact", width / 2, 180);
    pushStyle();
    fill(200);
    translate(width, height);
    rotate(1.5 * PI);
    text("@dinosaurs_rarr", 70, -5);
    popStyle();
  }
  else {
    background(0);
    noStroke();
    
    //work out where to draw the pic
    PVector picLocation = new PVector(-focusLocation.x, -focusLocation.y); //default to focus  
    image(carriage, picLocation.x, picLocation.y + 14);
    
    passenger nearestPassenger = null;
    float minDistance = 999999;
    
    //draw passengers
    for (int i = 0; i < passengers.size(); i++) {
      passenger thisPassenger = passengers.get(i);
      PVector thisEye = new PVector(thisPassenger.eyeLocation.x - focusLocation.x, thisPassenger.eyeLocation.y - focusLocation.y + 14);
      
      if (thisPassenger.active) {
        float thisDistance = PVector.dist(thisEye, centre);
        if (thisDistance < minDistance) {
          nearestPassenger = thisPassenger;
          minDistance = thisDistance;
        }
      }
    }
    
    if (nearestPassenger != null) {
      PVector nearestEye = new PVector(nearestPassenger.eyeLocation.x - focusLocation.x, nearestPassenger.eyeLocation.y - focusLocation.y + 14);
      attract(nearestEye, centre);
    }
    
    //move focus manually - exert willpower
    focusLocation.add(focusVelocity);
    
    //not touched a key for a while, so nudge for fun
    if ((millis() - pressedTime) > 5000) {
      focusVelocity.x = 0;
      focusVelocity.y = 0;
      pressedTime = millis();
    }
    
    //eye focus
    strokeWeight(2);
    noFill();
    stroke(0, 255, 0);
    ellipse(width / 2, (height - 14) / 2, 30, 30); 
    
    //top bit
    noStroke();
    fill(0);
    rect(0, 0, width, 14);
    fill(255);
    float timePlayed = millis() - startMillis;
    int seconds = floor(timePlayed / 1000);
    int partsofSeconds = floor(timePlayed % 1000);
    textFont(smallFont);
    textAlign(LEFT);
    text(nf(seconds, 2) + "." + nf(partsofSeconds, 3), 2, 12);
    text("seconds", 52, 12);
    
    //high score!
    if (timePlayed > highScore) {
      highScore = timePlayed;
    }
    seconds = floor(highScore / 1000);
    partsofSeconds = floor(highScore % 1000);
    text("High score: " + nf(seconds, 2) + "." + nf(partsofSeconds, 3), 190, 12);
    text("seconds", 330, 12);
    
    //stay within the limits
    if (focusLocation.x < 0) {
      focusLocation.x = 0;
      focusVelocity.x = -focusVelocity.x;
    }
    if (focusLocation.x > width) {
      focusLocation.x = width;
      focusVelocity.x = -focusVelocity.x;
    }
    if (focusLocation.y < 0) {
      focusLocation.y = 0;
      focusVelocity.y = 5 * focusSpeed;
    }
    if (focusLocation.y > height) {
      focusLocation.y = height;
      focusVelocity.y = -5 * focusSpeed;
    }
    
    if (minDistance < 15) {
      focusVelocity = new PVector(0, 0);
      noLoop();
      textFont(bigFont);
      
      textAlign(CENTER);
      fill(255);
      String loseMessage = loseMessages[int(random(0, loseMessages.length))];
      
      text(loseMessage, (width / 2) - 2, (height / 2) - 2);
      text(loseMessage, (width / 2) - 2, (height / 2) + 2);
      text(loseMessage, (width / 2) + 2, (height / 2) - 2);
      text(loseMessage, (width / 2) + 2, (height / 2) + 2);
      fill(0);
      text(loseMessage, width / 2, height / 2);
      
      
      textFont(mediumFont);
      fill(255);
      text("Space to restart", (width / 2) - 2, (height / 2) + 34);
      text("Space to restart", (width / 2) - 2, (height / 2) + 38);
      text("Space to restart", (width / 2) + 2, (height / 2) + 34);
      text("Space to restart", (width / 2) + 2, (height / 2) + 38);
      fill(0);
      text("Space to restart", width / 2, (height / 2) + 36);
    }
  }
}

void resetGame() {
  passengers.clear();
  
  //ensure no one overlaps
  int tryLimit = 50;
  int leftCount = 0;
  int leftAttempt = 0;
  int rightCount = 0;
  int rightAttempt = 0;
  int middleCount = 0;
  int middleAttempt = 0;
  
  //either side of the aisle
  while ((leftCount < random(2, 5)) && (leftAttempt < tryLimit)) {
    leftAttempt++;
    if (addPassenger(random(0, 150), random(112, 126), false)) {
      leftCount++;
    }
  }
  while ((rightCount < random(2, 5)) && (rightAttempt < tryLimit)) {
    rightAttempt++;
    if (addPassenger(random(600, 750), random(112, 126), false)) {
      rightCount++;
    }
  }
  
  //main game
  while ((middleCount < random(4, 6)) && (middleAttempt < tryLimit)) {
    middleAttempt++;
    if (addPassenger(random(175, 575), random(112, 126), true)) {
      middleCount++;
    }
  }
  
  carriage.image(backgroundPic, 0, 0);
  for (int i = 0; i < passengers.size(); i++) {
    passenger thisPassenger = passengers.get(i);
    thisPassenger.draw(carriage);
  }
  
  loop();
  startScreen = false;
  focusLocation = new PVector(width / 2, (height - 14) / 2);
  focusVelocity = new PVector(0, 0);
  startMillis = millis();
  pressedTime = millis();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      focusVelocity.x -= focusSpeed;
      pressedTime = millis();
    }
    if (keyCode == RIGHT) {
      focusVelocity.x += focusSpeed;
      pressedTime = millis();
    }
    if (keyCode == UP) {
      focusVelocity.y -= focusSpeed;
      pressedTime = millis();
    }
    if (keyCode == DOWN) {
      focusVelocity.y += focusSpeed;
      pressedTime = millis();
    }
  }
  
  if (key == ' ') {
    resetGame();
  }
}
//http://www.erdemyilmaz.com.tr/wp-content/uploads/Pantone_SkinTones.htm
color[] skinTones = {#FFDFC4, #F0D5BE, #EECEB3, #E1B899, #E5C298, #FFDCB2, #E5B887, #E5A073, #E79E6D, #DB9065, #CE967C, #C67856, #BA6C49, #A57257, #F0C8C9, #DDA8A0, #B97C6D, #A8756C, #AD6452, #5C3836, #CB8442, #BD723C, #704139, #A3866A, #870400, #710101, #430000, #5B0001, #302E2E, #000000};
//http://www.retouchpro.com/pages/haircolor.jpg
color[] hairTones = {#090806, #2C222B, #3B3024, #4E433F, #504444, #6A4E42, #554838, #A7856A, #B89778, #DCD0BA, #DEBC99, #977961, #E6CEA8, #E5C8A8, #A56B46, #91553D, #533D32, #71635A, #B7A69E, #D6C4C2, #FFF5E1, #CABFB1, #8D4A43, #B55239, #A52A2A, #D93E14};
color[] eyeTones = {color(25, 91, 17), color(25, 17, 91), #7B4A12};
color[] trouserTones = {color(25, 81, 165), #1034A6, #002387, #062A78, #1D2951, #4C516D, #555D50, #3D0C02, #123524, #253529, #232B2B, #1A1110};
color[] shoeTones = {#000000, #954535, #CD853F, #FFFFFF, #E62020};

class passenger {
  PGraphics display;
  PVector offset;
  PVector eyeLocation;
  boolean male;
  boolean skirt;
  boolean specs;
  boolean vneck;
  boolean midriff;
  boolean beard;
  boolean dress;
  boolean bald;
  boolean active;
  color skin;
  color eyes;
  color hair;
  color trousers;
  color shirt;
  color sleeves;
  color shoes;
  int sleeveLength;
  int skirtLength;
  int height;
  int torsoLength;
  int legLength;
  
  passenger(float x, float y, boolean a) {
    offset = new PVector(x, y); // where do they appear in the carriage?
    active = a; //can you be attracted to this one?
    
    //set the variable switches at random
    male = (random(1) < 0.5);
    specs = (random(1) < 0.1);
    skirt = (random(1) < 0.5);
    vneck = (random(1) < 0.3);
    midriff = (random(1) < 0.1);
    beard = (random(1) < 0.25);
    dress = (random(1) < 0.3);
    bald = (random(1) < 0.15);
    
    //colour things in
    skin = skinTones[int(random(0, skinTones.length))];
    hair = hairTones[int(random(0, hairTones.length))];
    eyes = eyeTones[int(random(0, eyeTones.length))];
    trousers = trouserTones[int(random(0, trouserTones.length))];
    int shoeOffset = male ? 1 : 0; //men don't wear red shoes
    shoes = shoeTones[int(random(0, shoeTones.length - shoeOffset))];
    
    //random color for shirt
    boolean firstShirt = true;
    shirt = color(0);
    sleeves = color(0);
    while (firstShirt || clashShirt(20)) { //check the shirt doesn't clash with other colours
      firstShirt = false;
      shirt = color(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
      
      int sleeveR = int(red(shirt) - (255 / 9)) % 255;
      int sleeveG = int(green(shirt) - (255 / 9)) % 255;
      int sleeveB = int(blue(shirt) - (255 / 9)) % 255;
      sleeves = color(sleeveR, sleeveG, sleeveB);
    }
    
    //choose sizes of things
    height = int(random(250, 292));
    torsoLength = int(0.45 * (height - 68 - 4));
    legLength = height - torsoLength - 68 - 4;
    sleeveLength = int(random(8, torsoLength));
    skirtLength = int(random(20, max(20, legLength - 40)));
    
    //adjust for moving down the height
    eyeLocation = new PVector(x + ((18 + 40) / 2.0) + 0.5, y + 28);
    eyeLocation.y += 292 - height;
    offset.y += (292 - height);
  }
  
  void draw(PGraphics display) {
    //make what they look like
    display.beginDraw();
    display.noStroke();
    
    //head
    display.fill(skin);
    display.rect(offset.x + 8, offset.y + 16, 44, 44);
    display.rect(offset.x + 22, offset.y + 60, 16, 8); //neck
    display.rect(offset.x + 16, offset.y + 8, 28, 8); //lego-style top of head
    if (male && beard) {
      display.fill(hair);
      display.rect(offset.x + 8, offset.y + 38, 44, 24);
    }
    display.fill(200, 0, 0);
    display.rect(offset.x + 18, offset.y + 44, 24, 4); //smile
    
    //eyes
    display.fill(eyes);
    display.rect(offset.x + 18, offset.y + 28, 4, 4);
    display.rect(offset.x + 38, offset.y + 28, 4, 4);

    //shirt
    display.fill(shirt); //torso
    display.rect(offset.x + 8, offset.y + 68, 44, torsoLength);
    if (vneck) {
      display.fill(skin);
      display.rect(offset.x + 18, offset.y + 68, 24, 8);
      display.rect(offset.x + 22, offset.y + 76, 16, 8);
      display.rect(offset.x + 26, offset.y + 84, 8, 8);
    }
    if (!male && midriff && !dress) {
      display.fill(skin);
      display.rect(offset.x + 8, offset.y + 60 + torsoLength, 44, 8);
    }
    display.fill(sleeves); //sleeves
    display.rect(offset.x + 0, offset.y + 68, 8, sleeveLength);
    display.rect(offset.x + 52, offset.y + 68, 8, sleeveLength);
    display.fill(skin); //hands
    display.rect(offset.x + 0, offset.y + 68 + sleeveLength, 8, (torsoLength - sleeveLength) + 8);
    display.rect(offset.x + 52, offset.y + 68 + sleeveLength, 8, (torsoLength - sleeveLength) + 8);
    
    //trousers
    if (male || !skirt) {
      display.fill(trousers);
      display.rect(offset.x + 8, offset.y + 68 + torsoLength, 20, legLength);
      display.rect(offset.x + 32, offset.y + 68 + torsoLength, 20, legLength);
      display.rect(offset.x + 8, offset.y + 68 + torsoLength, 44, 20);
    }
    else {
     display.fill(skin); //legs
     display.rect(offset.x + 8, offset.y + 68 + torsoLength, 20, legLength);
     display.rect(offset.x + 32, offset.y + 68 + torsoLength, 20, legLength);
     if (dress) {
       display.fill(shirt);
       display.rect(offset.x + 4, offset.y + 64 + torsoLength + skirtLength, 4, 4); //sticking out on the side
       display.rect(offset.x + 52, offset.y + 64 + torsoLength + skirtLength, 4, 4);
     }
     else {
       display.fill(trousers);
     }
     display.rect(offset.x + 8, offset.y + 68 + torsoLength, 44, skirtLength);
    }
    display.fill(shoes); //shoes
    display.rect(offset.x + 4, offset.y + 68 + torsoLength + legLength, 24, 4);
    display.rect(offset.x + 32, offset.y + 68 + torsoLength + legLength, 24, 4);
    
    //hair
    display.fill(hair);
    if (male) {
      if (!bald) {
        display.rect(offset.x + 14, offset.y + 0, 32, 8);
        display.rect(offset.x + 8, offset.y + 8, 44, 8);
        display.rect(offset.x + 8, offset.y + 16, 8, 8);
        display.rect(offset.x + 44, offset.y + 16, 8, 8);
      }
    } else {
      display.rect(offset.x + 14, offset.y, 32, 8);
      display.rect(offset.x + 8, offset.y + 8, 44, 8);
      display.rect(offset.x, offset.y + 16, 8, 36);
      display.rect(offset.x + 8, offset.y + 16, 8, 8);
      display.rect(offset.x + 52, offset.y + 16, 8, 36);
      display.rect(offset.x + 44, offset.y + 16, 8, 8);
    }
    
    //spectacles
    if (specs) {
      display.noFill();
      display.noSmooth();
      display.stroke(0);
      display.strokeWeight(2);
      display.strokeCap(SQUARE);
      display.rect(offset.x + 14, offset.y + 24, 12, 12);
      display.rect(offset.x + 34, offset.y + 24, 12, 12);
      display.line(offset.x + 26, offset.y + 28, offset.x + 34, offset.y + 28);
      display.line(offset.x + 14, offset.y + 28, offset.x + 8, offset.y + 28);
      display.line(offset.x + 46, offset.y + 28, offset.x + 52, offset.y + 28);
      display.noStroke();
    }
    
    display.endDraw();
  }
  
  //is this shirt colour too close to one of the others?
  boolean clashShirt(float tolerance) {
    colorMode(RGB, 255);
    color[] tests = {skin, hair, eyes, trousers, shoes};
    for (int i = 0; i < tests.length; i++) {
      color t = tests[i];
      float redDiff = abs(red(shirt) - red(t));
      float greenDiff = abs(green(shirt) - green(t));
      float blueDiff = abs(blue(shirt) - blue(t));
      if ((redDiff < tolerance) && (greenDiff < tolerance) && (blueDiff < tolerance)) {
        return true;
      }
    }
    return false;
  }
}

void attract(PVector target, PVector focus) {
  float d = PVector.dist(target, focus); //distance to the other one
  float radius = width; //limit on how far the force reaches
  float strength = 0.5; //tweakable
  float ramp = 0.9; //tweakable
  if (d > 0 && d < radius) { //if in range
    float s = pow(d / radius, 1 / ramp); //no idea how this works -> got it from the Generative Design book
    float f = s * 9 * strength * (1 / (s + 1) + ((s - 3) / 4)) / d;
    PVector df = PVector.sub(focus, target);
    df.mult(f);
    focusVelocity.x -= df.x;
    focusVelocity.y -= df.y;
  }
}

//were you able to add a passenger or not?
boolean addPassenger(float x, float y, boolean a) {
  boolean safe = true; //assume no overlap
  if (x > 350 && x < 400) {
    return false; //right next to the middle
  }
  for (int i = 0; i < passengers.size(); i++) {
    if (abs(passengers.get(i).offset.x - x) < 50) {
      safe = false;
      break;
    }
  }
  if (safe) {
    passengers.add(new passenger(x, y, a));
    return true;
  } else {
    return false;
  }
}


