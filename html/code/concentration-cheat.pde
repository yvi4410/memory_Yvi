//Cheats

gameVersion += "-cheat";

void keyPressed() {
  // Press 7 to flip all the tiles
  if (screenCount == 1) {
    if (key == '7') {
      for (int i = 0; i <b; i++) {
        tile[i].flip();
      }
    }

    // Press q to unflip all the tiles
    if (key == 'q') {
      for (int i= 0; i<b; i++) {
        tile[i].unflip();
      }
    }
  }

  // these are just used for myself, to examine each step of the game
  if (key =='0') {
    screenCount =0;
  } else if (key == '1') {
    screenCount = 1;
  } else if (key == '2') {
    screenCount = 2;
  } else if (key == '3') {
    screenCount = 3;
  } else if (key == '4') {
    screenCount = 4;
  } else if (key == '5') {
    screenCount = 5;
  }
}

