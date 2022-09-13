// constants
final int totalWidth = 800;
final int totalHeight = 600;
final int ballSize = 15;
final int platformWidth = 75;
final int platformHeight = 25;
final int mouseOffset = (int) (platformWidth / 2);
final int brickWidth = 100;
final int brickHeight = 25;
final int brickAmount = 17;

// variables
int ballX = (int) (totalWidth * 0.50);
int ballY = (int) (totalHeight * 0.80);
int platformX = (int) (totalWidth * 0.50);
int platformY = (int) (totalHeight * 0.80);
int ballMovement = 5;
int ballVelocityX = 0;
int ballVelocityY = 0;
boolean lost = false;
boolean won = false;
int score = 0;
ArrayList<Brick> bricks = new ArrayList<>();

void setup() {
  // totalWidth & totalHeight, because variables can't be used.
  size(800, 600);
  // textSize based on window size.
  textSize(min(totalWidth, totalHeight) / 30);
  // makes ball move when game is started.
  ballVelocityY = -ballMovement;
  ballVelocityX = ballMovement;
  
  colorMode(HSB, 360, 100, 100);
  
  setBricks();
}

void draw() {
  // Changes ball speed based on score.
  ballMovement = min(5 + (score / 3), 15);
  
  if (score == brickAmount) won = true;
  
  clear();
  fill(0, 0, 100);
  if (!lost && !won) {
    movement();
  
    // Draw
    text("Score: " + score, 10, 20);
    circle(ballX, ballY, ballSize);
    rect(platformX, platformY, platformWidth, platformHeight);
    
    for (Brick brick : bricks) {
      fill(brick.hashCode() % 360, 100, 100);
      rect(brick.x, brick.y, brickWidth, brickHeight);
    }
  }
  else {
    String message = "You " + (won ? "won" : ("lost with " + score + " point" + (score != 1 ? "s" : ""))) + "! Press R to play again!";
    // Centers text
    text(message, totalWidth / 2 - (message.length() * (totalWidth / 200)), totalHeight / 2);
  }
}

void movement() {
  // Apply movement to ball.
  ballX += ballVelocityX;
  ballY += ballVelocityY;

  // Move platform with mouse.
  platformX = mouseX - mouseOffset;
  
  // Border collision
  // Left side of screen.
  if (ballX < 0) {
    ballVelocityX = ballMovement; 
  }
  // Right side of screen.
  else if (ballX > totalWidth) {
    ballVelocityX = -ballMovement;
  }
  // Top of screen.
  if (ballY < 0) {
    ballVelocityY = ballMovement;
  }
  // Bottom of screen.
  else if (ballY > totalHeight) {
    ballVelocityY = -ballMovement;
    lost = true;
  }
  
  // Platform collision
  boolean platformCollisionX = (ballX + ballSize / 2) >= platformX && (ballX - ballSize / 2) <= (platformX + platformWidth);
  boolean platformCollisionY = (ballY + ballSize / 2) >= platformY && (ballY - ballSize / 2) <= (platformY + platformHeight);
  if (platformCollisionX && platformCollisionY) {
    ballVelocityY = -ballMovement;
  }
  
  // Brick collision
  for (Brick brick : bricks) {
    boolean brickCollisionX = (ballX + ballSize / 2) >= brick.x && (ballX - ballSize / 2) <= (brick.x + brickWidth); 
    boolean brickCollisionY = (ballY + ballSize / 2) >= brick.y && (ballY - ballSize / 2) <= (brick.y + brickHeight);
    if (brickCollisionX && brickCollisionY) {
      brick.hit();
      ballVelocityY = -ballVelocityY;
      break;
    }
  }
}

class Brick {
   final int x;
   final int y;
   
   Brick(int x, int y) {
     this.x = x;
     this.y = y;
   }
   
   void hit() {
     bricks.remove(this);
     score += 1;
   }
}

void setBricks() {
  bricks.clear();
  for (int i = brickAmount * 2; i > 0; i -= 2) {
    int x = (i - 1) % 5;
    int y = (i - 1) / 5;
    bricks.add(new Brick(x * (width / 6) + 80, y * (height / 10) + 10));
  }
}

void keyPressed() {
  if (key == 'r') {
    lost = false;
    won = false;
    score = 0;
    setBricks();
  }
}
