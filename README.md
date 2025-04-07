# Cat Man Zero

#### Video Demo: [YouTube Link](https://youtu.be/VXkO3j-_Ie4)

#### Description:

##### Cat Man Zero is a small game prototyped based off the NES era "Mega Man" games. Within this prototype the player fights against a single enemy, if the enemy reaches 0 hp, the player wins, if the player reaches 0 hp, the player loses. You can walk with a and d, jump with space bar, and shoot with left mouse click.

### Main.lua:

##### Main.lua is the heart of the program. This is where the pieces are glued together to make the game run and look the way it does.

### Player.lua

##### Within player.lua I defined all the aspects of the player character. The health values, movement values and controls, the position of the screen, and the collider for collision and damage calculation.

### Cop.lua

##### This is the file in which I defined the computer enemy. Within this file I gave hp values, defined a movement function, added damage values from the player's attack, gave a collider for collision and damage calculation, and assigned x and y values to draw the position of the character to the screen.

### Conf.lua

##### In this configure file I added the title of the game to the window's title bar, and enabled vsync.

### Game.lua (Within the "states" directory)

##### Within game.lua I assigned boolean values to variables so create game states.

### Libraries folder

##### Within the "libraries" folder there are quite a few things. These libraries were found via GitHub and Love2D's wiki page for libraries. Within this folder we have the following:

#### HUMP

##### This library was used to easily calculate vectors to help with character movement (mostly the ai) and position on screen.

#### STI

##### This library was used to help implement the tilemap that was created via a tool called "Tiled". This let me access layers of the tilemap to give certain objects physics (such as walls).

#### Windfield

##### This is a physics library which greatly helped with the creation of this prototype. This is where all the colliders come from, collision as a whole, as well as the gravity calculations.

#### Anim8.lua

##### This library makes it easier to create character animations via spritesheets. Using this library with a spritesheet you can create "grids" to more or less slice pieces of the image into smaller images.

#### Camera.lua

##### This library makes it easier to create the effect of a camera in the game, following the player character at a certain distance.

#### Push.lua

##### This library helps with changing the resolution of the game.

### Sounds folder

##### Within this folder are all the sound effects and music used in the game.

### Sprites folder

##### Sprite sheets for the characters and abilities.

### Maps folder

##### Includes the tilesheet for the level.

### background6.lua

##### This file is the 6th version of the background I made via the "Tiled" program using the spritesheets I got from [opengameart.org](opengameart.org)

### Artist Credits.txt

##### Links to the artists that whose work I borrowed from opengameart. All of these are free to use however I wanted to include credits to the artists in my project as these things are not easy to make and they all did a great job.

### SHIPPING_DOCKS_AREA.png

##### This is the sprite sheet used for the background.
