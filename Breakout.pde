// constants
final int totalWidth = 800;
final int totalHeight = 600;
final int ballSize = 15;
final int platformWidth = 100;
final int platformHeight = 25;
final int mouseOffset = (int) (platformWidth / 2);

// variables
int ballX = (int) (totalWidth * 0.50);
int ballY = (int) (totalHeight * 0.80);
int platformX = (int) (totalWidth * 0.50);
int platformY = (int) (totalHeight * 0.80);
int ballMovement = 5;
int ballVelocityX = 0;
int ballVelocityY = 0;
boolean lost = false;
int score = 0;

void setup() {
  // totalWidth & totalHeight, because variables can't be used.
  size(800, 600);
  // textSize based on window size.
  textSize(min(totalWidth, totalHeight) / 30);
  // makes ball move when game is started.
  ballVelocityY = -ballMovement;
  ballVelocityX = ballMovement;
}

void draw() {
  // Changes ball speed based on score.
  ballMovement = min(5 + (score / 3), 15);
  
  clear();
  if (!lost) {
    movement();
  
    // Draw
    text("Score: " + score, 10, 20);
    circle(ballX, ballY, ballSize);
    rect(platformX, platformY, platformWidth, platformHeight);
  }
  else {
    text("You lost!", totalWidth / 2 - 50, totalHeight / 2);
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
    score++;
  }
}

void keyPressed() {
  if (key == 'r') {
    lost = false;
    score /= 2;
  }
}
