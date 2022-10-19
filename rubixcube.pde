import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import peasy.*;

public class Cube
{
    public float[][] x;
    public float[][] y;
    public float[][] z;
    
    public Cube(float[][] x, float[][] y, float[][] z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}

Cube[][][] cubes;
int size = 3;

void drawCube(Cube cube) {
  int scale = 100;
  for (int i = 0; i < 6; i++) {
    beginShape(QUADS);
    switch(i) {
      case 0 :
        fill(0, 255, 0);
        break;
      case 1:
        fill(0, 0, 255);
        break;
      case 2:
        fill(255, 0, 0);
        break;
      case 3 :
        fill(255, 165,0);
        break;
      case 4:
        fill(255, 255, 255);
        break;
      case 5:
        fill(255, 255, 0);
        break;
      default:
        break;
    }
    strokeWeight(5);
    //noStroke();
    //stroke(127);
    
    vertex(cube.x[i][0] * scale, cube.y[i][0] * scale, cube.z[i][0] * scale);
    vertex(cube.x[i][1] * scale, cube.y[i][1] * scale, cube.z[i][1] * scale);
    vertex(cube.x[i][2] * scale, cube.y[i][2] * scale, cube.z[i][2] * scale);
    vertex(cube.x[i][3] * scale, cube.y[i][3] * scale, cube.z[i][3] * scale);
    endShape();
  }
}

void generateRubix(int size) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        float scale = 2.0/size;
        float posX = -1 + k * scale;
        float posY = -1 + i * scale;
        float posZ = -1 + j * scale;
        float[][] x = {{posX, posX + scale, posX + scale, posX},
                       {posX, posX + scale, posX + scale, posX},
                       {posX, posX + scale, posX + scale, posX},
                       {posX, posX + scale, posX + scale, posX},
                       {posX, posX, posX, posX},
                       {posX + scale, posX + scale, posX + scale, posX + scale}};
        float[][] y = {{posY, posY, posY + scale, posY + scale},
                       {posY, posY, posY + scale, posY + scale},
                       {posY, posY, posY, posY},
                       {posY + scale, posY + scale, posY + scale, posY + scale},
                       {posY, posY, posY + scale, posY + scale},
                       {posY, posY, posY + scale, posY + scale}};
        float[][] z = {{posZ, posZ, posZ, posZ},
                       {posZ + scale, posZ + scale, posZ + scale, posZ + scale},
                       {posZ, posZ, posZ + scale, posZ + scale},
                       {posZ, posZ, posZ + scale, posZ + scale},
                       {posZ, posZ + scale, posZ + scale, posZ},
                       {posZ, posZ + scale, posZ + scale, posZ},};
                       
        cubes[i][j][k] = new Cube(x, y, z);
        
      }
    }
  }
}

void rotateYY(int l, float angle) {
  for (int i = 0; i < size * size; i++) {
    for (int j = 0; j < 6; j ++) {
      for (int k = 0; k < 4; k++) {
         float x = cubes[l][i / size][i % size].x[j][k];
         float z = cubes[l][i / size][i % size].z[j][k];
         cubes[l][i / size][i % size].x[j][k] =  x * cos(angle) + z * sin(angle);
         cubes[l][i / size][i % size].z[j][k] =  -x * sin(angle) + z * cos(angle);
      }
    }
  }
}

void rotateXX(int l, float angle) {
  for (int i = 0; i < size * size; i++) {
    for (int j = 0; j < 6; j ++) {
      for (int k = 0; k < 4; k++) {
         float y = cubes[i / size][i % size][l].y[j][k];
         float z = cubes[i / size][i % size][l].z[j][k];
         cubes[i / size][i % size][l].y[j][k] =  y * cos(angle) - z * sin(angle);
         cubes[i / size][i % size][l].z[j][k] =  y * sin(angle) + z * cos(angle);
      }
    }
  }
}

void rotateZZ(int l, float angle) {
  for (int i = 0; i < size * size; i++) {
    for (int j = 0; j < 6; j ++) {
      for (int k = 0; k < 4; k++) {
         float x = cubes[i % size][l][i / size].x[j][k];
         float y = cubes[i % size][l][i / size].y[j][k];
         cubes[i % size][l][i / size].x[j][k] =  x * cos(angle) - y * sin(angle);
         cubes[i % size][l][i / size].y[j][k] =  x * sin(angle) + y * cos(angle);
      }
    }
  }
}

void scramble() {
  if (!animation) {
    animation = true;
    scrambleFace = ThreadLocalRandom.current().nextInt(0, 3);
    sfl = ThreadLocalRandom.current().nextInt(0, size);
  }
}

PeasyCam cam;

void setup() {
  size(600, 600, P3D);
  cubes = new Cube[size][size][size];
  generateRubix(size);
  cam = new PeasyCam(this, 300, 300, 0, 500);
}

float animeCount = 0;
boolean animation = false;
int scrambleFace = 0;
int sfl = 0;
int numOfScrambles = 0;
boolean scramble = false;
int maxNumOfScrambles = 30;
int animationSpeed = 15;
boolean scrambled = false;

int[][] moves = new int[maxNumOfScrambles][2];

void draw() {
  background(127);
  translate(width/2, height/2);
  rotateX(-PI/6);
  rotateY(-PI/6);
  //lights();
  
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        drawCube(cubes[i][j][k]);
      }
    }
  }
  
  if (scramble && numOfScrambles < maxNumOfScrambles) {
    scramble();
  } else if (scramble) {
    scramble = false;
    scrambled = true;
  }
  
  if (animation && animeCount < 1 * animationSpeed) {
    if (scrambleFace == 0) {
      rotateXX(sfl, PI/(2 * animationSpeed));
    } else if (scrambleFace == 1) {
      rotateYY(sfl, PI/(2 * animationSpeed));
    } else if (scrambleFace == 2) {
      rotateZZ(sfl, PI/(2 * animationSpeed));
    }
    animeCount++;
  } else if (animation) {
    moves[numOfScrambles][0] = scrambleFace;
    moves[numOfScrambles][1] = sfl;
    numOfScrambles++;
    Cube[][][] cubesCopy = new Cube[size][size][size];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        for (int k = 0; k < size; k++) {
          cubesCopy[i][j][k] = cubes[i][j][k];
        }
      }
    }
    if (scrambleFace == 0) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          cubes[i][j][sfl] = cubesCopy[j][size - 1 - i][sfl];
        }
      }
    } else if (scrambleFace == 1) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          cubes[sfl][i][j] = cubesCopy[sfl][j][size - 1 - i];
        }
      }
    } else if (scrambleFace == 2) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          cubes[i][sfl][j] = cubesCopy[size - 1 - j][sfl][i];
        }
      }
    }
    animation = false;
    animeCount = 0;
    scrambleFace = ThreadLocalRandom.current().nextInt(0, 3);
    sfl = ThreadLocalRandom.current().nextInt(0, size);
  }

  
  //noLoop();
}

void keyPressed() {
  scramble = true;
  numOfScrambles = 0;
  //rotateYY(0, PI/2);
}
