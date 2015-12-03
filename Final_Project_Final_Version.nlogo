;Shantanu Jha and Dana Yang 
;SmashBash
;IntroCS1 Period 9
;1/15/2015



globals [ mushroom-x mushroom-y player-number game column make-state mushroom-state points coins world game-level update-points lives reset-game new-level game-time game-screen flag-score flag-state]

;mushroom-x and mushroom-y help in raising the prize out from under a question or diguised block ... they can be seen in prize-condition
;player-number stores the who of the player so that functions like move-jump can ask that specific turtle (player player-number) to do something
;game is a variable that helps make sure the infinity button go is pressed
;column is a variable that helps setup-column-level-one cycle through different columns to generate
;make-state is a variable that makes sure all of the columns in setup-column-level-one will not be generated at once
;mushroom-state is a global variable that controls what type of prize the player gets depending on whether the player is in normal, leveled-up, or super-leveled-up mode
;points stores the total points the player has collected 
;coins stores the total number of coins the player has collected
;world and game-level store the world and level the game is on
;lives is the number of lives the player has
;reset-game is variable that acts as a boolean variable (because we only store 0 and 1 in it) and this controls the reseting of the game after player death


;BREEDS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
breed [mushrooms mushroom]
breed [flags flag]
breed [above-ground-blocks above-ground-block]
breed [castles castle]
breed [players player]
breed [question-blocks question-block]
breed [empty-blocks empty-block]
breed [ground-blocks ground-block]
breed [disguised-blocks disguised-block]
breed [hidden-blocks hidden-block]
breed [bullets bullet]
breed [used-blocks used-block]
breed [pipe-blocks pipe-block]
breed [enemies enemy]
breed [platforms platform]
breed [princesses princess]


;order of breed creation matters because if two turtles are ontop of each other the one with the breed that was created later will appear on the top
;this is essential in that the mushrooms are able to hide behind the question-blocks or disguised-blocks ... until they are forced out

;Attributes----------------------------------------------------------------------------------------------------------------------------------------------------------------------
pipe-blocks-own [entrance exit]
;entrance is an attribute that contains either the value 0 or 1 .... 1 means the pipe-block is an enterance to the underground secret world
;exit is the same as entrance except for exiting the underground world
;both are used in the movement conditions and functions

players-own [move-state height-adjust level invincibility invincibility-time]

;level is an attribute that controls the level of the player (either normal, leveled-up, or super-leveled-up .... 0, 1, and 2 respectively)
;^helps in both enemy test

;height-adjust accounts for the height of the player shape .... visual fix attribute
;move-state is necessary in the setting up of columns 


to go ;makes sure players fall from heights down to the ground
  ask players [movement-conditions]
  ifelse game-screen = 10
  [game-conditions]
  [game-screen-set] 
  if (update-points mod 6000) = 0 ;so that the output doesn't keep flashing
  [
    update-output
  ]
  set update-points update-points + 1
end

to game-conditions 
  if lives = 0 [gameover stop]
  if reset-game = 1 and lives > 0 [ask turtles [die] wait 5 if game-level = 0 or game-level = .5 [setup-level-one] if game-level = 1 [setup-level-two] set reset-game 0]
  if game-level = 0 and world = 0
  [if new-level = 0 [ask turtles [die] setup-level-one] setup-column-level-one-world-one]
  if game-level = .6 and world = 0 [ifelse flag-state = 1 [level-two-ending] [level-one-ending]]
  if game-level = .5 and world = 0 
  [setup-underworld-level-one-world-one]
  if game-level = 1 and world = 0
  [if new-level = 0 [ask turtles [die] setup-level-two] setup-column-level-two-world-one]
  if game-level = 2.5 and world = 0
  [setup-underworld-level-two-world-one]
  if game-level = 1.9 and world = 0
  [if new-level = 0 [setup-abovegound-level-two] setup-column-level-two-world-one]
  if game-level = 1.95 and world = 0 [level-two-ending]
  if game-level = 10 and world = 0 
  [setup-final-ending]
  if game-level = 100 and world = 0
  [You-win]
end

to game-screen-set 
  if game-screen = 0 [import-drawing "TitleScreen.jpg" game-screen-conditions]
  if game-screen = 1 [import-drawing "instructionDown.png" game-screen-conditions]
  if game-screen = 2 [import-drawing "instructionUp.png" game-screen-conditions]
  if game-screen = 3 [import-drawing "instructionRight.png" game-screen-conditions]
  if game-screen = 4 [import-drawing "instructionLeft.png" game-screen-conditions]
  if game-screen = 5 [import-drawing "story.png" game-screen-conditions]
  if game-screen = 6 [import-drawing "mario.jpg" game-screen-conditions]
  if game-screen = 7 [import-drawing "credit.jpg" game-screen-conditions]
end

to game-screen-conditions
  if game-screen = 0 
  [if mouse-down? [
    if mouse-xcor <= 10 and mouse-xcor >= 5.5 and (mouse-ycor < 7.5 and mouse-ycor >= 6.5) [set game-screen 1 wait 1] 
    if mouse-xcor <= 9 and mouse-xcor >= 7 and (mouse-ycor < 6 and mouse-ycor > 5) [set game-screen 5 wait 1]
    if mouse-xcor <= 9 and mouse-xcor >= 7.5 and (mouse-ycor < 4.3 and mouse-ycor >= 3.5) [set game-screen 7 wait 1]]] ;replace with actual screen
  if game-screen >= 1 and game-screen <= 4 
  [if mouse-down? [
    if mouse-xcor < 16 and mouse-xcor >= 11 and (mouse-ycor < 2 and mouse-ycor >= .5) [set game-screen game-screen + 1 wait 1] 
    if mouse-xcor < 5 and mouse-xcor >= 1 and (mouse-ycor < 2 and mouse-ycor >= .5) [set game-screen game-screen - 1 wait 1]]]
  if game-screen = 5 
  [if mouse-down? [
    if mouse-xcor < 16 and mouse-xcor >= 11 and (mouse-ycor < 2 and mouse-ycor >= 0.5) [set game-screen 6 wait 1] 
    if mouse-xcor < 5 and mouse-xcor >= 1 and (mouse-ycor < 2 and mouse-ycor >= 0.5) [set game-screen 0 wait 1]]]
  if game-screen = 6 
  [if mouse-down? [
    if mouse-xcor < 16 and mouse-xcor >= 11 and (mouse-ycor <= 2 and mouse-ycor >= .5) [set game-screen 10 wait 1] 
    if mouse-xcor < 5 and mouse-xcor >= 1 and (mouse-ycor <= 2 and mouse-ycor >= .5) [set game-screen 5 wait 1]]]
  if game-screen = 7 [if mouse-down? [if mouse-xcor <= 15 and mouse-xcor >= 11 and (mouse-ycor <= 2 and mouse-ycor >= .5)   [set game-screen 0 wait 1]]]
end

to update-output
  clear-output
  set game-time game-time - 1
  output-type "Points: " output-type points output-type "  Coins: " output-type coins output-type "x" output-type "  World " output-type world + 1 output-type "-" output-type game-level + 1 
  output-type "  Lives: " output-type lives output-type "  Time: " output-type game-time
  if game-time = 0 [set reset-game 1 set lives lives - 1 ask players [die] import-drawing "times-up.png"]
  wait .1
end ;game-level and world have a "+ 1" because they -like all netlogo globals - start with the value 0. Thus since we want the display to say "1-1" we use the + 1 

    ;MAIN ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup 
  ca 
  user-message "Remember to Press Go :)"
  resize-world 0 16 0 16
  set-patch-size 26
  set lives 3
  set new-level 0
  set game-screen 0 
end

to gameover
  ask turtles [die]
  set game-time 0
  import-drawing "GameoverScreen.png"
  ca
end 
;SETUP FUNCTIONS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

;main-level-setup-functions 
to setup-level-one 
  import-drawing "bild.jpg"
  ask turtles [die]
  setup-ground-initial-level-one-world-one
  setup-player
  ask players [set move-state true]
  set game-time 401
  set game false  
  set-move-state 
  set column 0
  set new-level 1
  set flag-score 0
  set flag-state 0
end

to setup-level-two 
  import-drawing "black.jpeg"
  ask turtles [die]
  setup-ground-initial-level-two-world-one
  setup-player
  ask players [set move-state true]
  set game-time 401
  set game false
  set new-level 1
  set-move-state
  set column 0
  set flag-score 0
  set flag-state 0
end

to setup-player ;sets up the player
  create-players 1 [
    set height-adjust 1.25 set ycor min-pycor + height-adjust + 1 set xcor -15 
    set heading 90 set shape "mario" set color 28 set size 1.7 set level 0
    set player-number who 
    set mushroom-state "mushroom"] ;even though the shape is fixed set heading 90 is necessary for movement 
end

;individual
to setup-enemies [height x-coordinate enemy-shape enemy-color] 
  create-enemies 1 [set ycor height set xcor x-coordinate set shape enemy-shape set color enemy-color set heading 90]
end

to setup-ground-blocks [how-many height x-coordinate block-color]
  repeat how-many [ 
    create-ground-blocks 1 [set ycor min-pycor + height set xcor x-coordinate set shape "ground-block" set color block-color]
  set x-coordinate x-coordinate + 1
  ]
end

to setup-question-blocks [how-many height x-coordinate prize prize-color]
  repeat how-many [
    create-question-blocks 1 [set ycor min-pycor + height  set shape "question-block" set color 26 set xcor x-coordinate]
  create-mushrooms 1 [set ycor min-pycor + height set shape prize set color prize-color set xcor x-coordinate]
  set x-coordinate x-coordinate + 1
  ]
end  


to setup-empty-blocks [how-many height x-coordinate block-shape block-color]
  repeat how-many [
    create-empty-blocks 1 [set ycor height set shape block-shape set color block-color set xcor x-coordinate]
  set x-coordinate (x-coordinate + 1)
  ]
end

to setup-empty-blocks-stack [how-high height x-coordinate block-shape block-color]
  repeat how-high [
    create-empty-blocks 1 [set ycor height set shape block-shape set color block-color set xcor x-coordinate]
  set height (height + 1)
  ]
end

to setup-disguised-blocks [how-many height x-coordinate prize prize-color prize-number block-shape block-color]
  repeat how-many [
    create-disguised-blocks 1 [set ycor min-pycor + height  set shape block-shape set color block-color set xcor x-coordinate]
  repeat prize-number [
    create-mushrooms 1 [set ycor min-pycor + height set shape prize set color prize-color set xcor x-coordinate]]
  set x-coordinate x-coordinate + 1]
end

to setup-hidden-blocks [how-many height x-coordinate prize prize-color prize-number]
  repeat how-many [
    create-disguised-blocks 1 [set ycor min-pycor + height  set shape "empty-block" set color 23 set xcor x-coordinate set hidden? true]
  repeat prize-number [
    create-mushrooms 1 [set ycor min-pycor + height set shape prize set color prize-color set xcor x-coordinate set hidden? true]]
  set x-coordinate x-coordinate + 1]
end

to setup-above-ground-blocks [how-many height x-coordinate block-shape block-color]
  repeat how-many [
    create-above-ground-blocks 1 [set ycor height set shape block-shape set color block-color set xcor x-coordinate]
  set height (height + 1)
  ]
end  

to setup-pipe-left [how-high height x-coordinate]
  repeat how-high [
    create-pipe-blocks 1 [set ycor height set shape "pipe-body-left" set color green set xcor x-coordinate]
  set height (height + 1)
  ]
  create-pipe-blocks 1 [set ycor height set shape "pipe-top-left" set color green set xcor x-coordinate]
end

to setup-pipe-right [how-high height x-coordinate]
  repeat how-high [
    create-pipe-blocks 1 [set ycor height set shape "pipe-body-right" set color green set xcor x-coordinate]
  set height (height + 1)
  ]
  create-pipe-blocks 1 [set ycor height set shape "pipe-top-right" set color green set xcor x-coordinate]
end


to setup-flag
  let height 3
  repeat 9 [
    create-flags 1 [set ycor height set shape "flag-pole" set color green set xcor max-pxcor]
  set height (height + 1)
  ]
  create-flags 1 [set ycor height - 1 set shape "flag" set color green set xcor max-pxcor]
  create-flags 1 [set ycor height set shape "flag-top" set color green set xcor max-pxcor]
  setup-above-ground-blocks 1 2 max-pxcor "above-ground-block" 27
end


;MOVEMENT FUNCTIONS  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;main
to move-right ;moves player right 
  if breed = players and ((not any? turtles-at 1 0) or any? mushrooms-at 1 0 or any? (pipe-blocks-at 1 0) with [exit = 1 or exit = 2]) [ ;if there is nothing to the right of the player the player is able to move right
    if not can-move? 1 [rt 180]
    fd 1 ]
end

to move-left ;moves player left
  if breed = players and not (xcor = min-pxcor) and (not any? turtles-at -1 0 or any? mushrooms-at -1 0) [ ;if there is nothing to the left of the player the player is able to move left
    if not can-move? 1 [rt 180]
    bk 1 ]
end

to move-down ;moves player down only if there is a pipe-block entrance to the under ground world
  if breed = players 
  [if any? (pipe-blocks-at 0 (-1 * height-adjust)) with [entrance = 1] [repeat 4 [set ycor ycor - .25 wait .25] set hidden? true]]
end 

to move-jump [how-high long];main jump function made so that the position of the mouse can help move the player mid flight 
                            ;five times each
  let time 0
  repeat how-high [
    if any? players [
      wait long * time
      move-jump-up-part
      set time time + 1
      mushroom-test
      if mouse-down? 
        [
          ifelse mouse-xcor < ([xcor] of player player-number) ;checks position of clicked mouse to wether to move left or right mid flight
          [move-left mushroom-test]
          [move-right mushroom-test]]]]
  prize-condition 
  mushroom-test
  ;five times
  repeat how-high [ 
    if any? players [
      wait long * (time - 1)
      move-jump-down-part 
      set time time - 1
      mushroom-test
      if mouse-down? 
      [
        ifelse mouse-xcor < ([xcor] of player player-number) ;checks position of clicked mouse to wether to move left or right mid flight
        [move-left mushroom-test]
        [move-right mushroom-test]]]]
  set time 0
  
end

to movement-conditions
  let end-animation false
  ask players [ ;makes sure the players will fall down  or die
    if not any? turtles-at 0 (-1 * height-adjust) or (any? mushrooms-at 0 -1 and not any? question-blocks-at 0 -1 and not any? disguised-blocks-at 0 -1) [wait .05 set ycor ycor - 1]
    mushroom-test
    enemy-test
    enemy-kill
    if ycor <= .25 [set reset-game 1 set lives lives - 1 die]
    if any? pipe-blocks-here with [entrance = 1] [wait 1 set game-level game-level + .5] ;this is for the underworlds wich have game-levels of .5 and 1.5
    if any? pipe-blocks-here with [exit = 2] [wait 1 set new-level 0 set game-level 1.9 ];this is to go aboveground for level 2
    if invincibility = 1 [let old-color color flash .015 set color old-color wait .2 set game-time game-time - 1 if abs (invincibility-time - game-time) >= 40 [set invincibility 0 set invincibility-time 0]]
    let player-x xcor
    if any? flags with [xcor = player-x + 1] [set game-level .6 set flag-score ycor] 
    if any? princesses with [xcor = player-x + 1] [set game-level 100]
  ]
  ask enemies [ ;makes sure the enemies will fall or die
    if not any? turtles-at 0 -1 or any? players-at 0 -1 [ifelse ycor = min-pycor [die] [wait .05 set ycor ycor - 1]]
    enemy-move]
end

;sub-functions
to mushroom-test
  if breed = players [
    let player-x xcor
    if any? flags with [xcor = player-x + 1] [set game-level .6 set flag-score ycor]
    if any? mushrooms-here and not any? question-blocks-here and not any? disguised-blocks-here
    [
      ifelse any? mushrooms-here with [shape = "coin" or shape = "green mushroom" or shape = "star"]
      [
        if any? mushrooms-here with [shape = "star"] [set points points + 1000 set invincibility 1 ask mushrooms-here [die] set invincibility-time game-time]
        if any? mushrooms-here with [shape = "coin"] [set points points + 200 set coins (coins + 1) ask mushrooms-here [die]]
        if any? mushrooms-here with [shape = "green mushroom"] [set points points + 1000 set lives (lives + 1) ask mushrooms-here [die]]
      ]
      [
        let allow-level-up true ;makes sure that mario doesn't just atomatically become supermario2
        ask mushrooms-here [set points (points + 1000) die]
        flash .02
        if level = 0 and allow-level-up  ;makes mario supermario 
        [
          set shape "supermario" set color 28
          set mushroom-state "fire flower"
          set level 1
          set allow-level-up false
        ]
        if level >= 1 and allow-level-up ;makes supermario or supermario2 into supermario2
        [
          set shape "supermario2" set color 28 ;later replace supermario with supermario2
          set mushroom-state "fire flower"
          set level 2
          set allow-level-up false
        ] 
      ]
    ]
  ]
end

to enemy-kill ;player kills enemies
  let koopa-state  true
  if breed = players and any? enemies-at 0 (-1 * height-adjust) 
  [
    ask (enemies-at 0 -1) with [shape = "goomba" or shape = "blue goomba"] [set shape "squished goomba" wait .05 set points (points + 100) die]
    ask (enemies-at 0 -1) with [shape = "koopa"] [set shape "hit-koopa" wait .05 set points (points + 100) set koopa-state false]
    if koopa-state [
      ask (enemies-at 0 -1) with [shape = "hit-koopa"] [wait .05 set points (points + 100) die]]
    move-jump 4 .03
  ]
end

to enemy-test ;enemy kills player
  if breed = players and any? enemies-here [
    ifelse invincibility = 1 [ask enemies-here [flash .01 die]]
    [
      ifelse level > 0 [
        flash .02
        set shape "mario" set color 28 
        set mushroom-state "mushroom"
        set level 0
      ]
      [
        set reset-game 1 set lives lives - 1 die]
    ]
  ]
end

to enemy-move ;moves enemy to the left
  if breed = enemies and (shape = "goomba" or shape = "koopa" or shape = "blue goomba") and any? turtles-at 0 -1 [ifelse xcor = min-pxcor [die] [if not any? turtles-at -1 0 or any? players-at -1 0 [wait .3 bk 1  set game-time game-time - 1]]]
end



to move-jump-up-part;moves the player up until an obstacle is met (5 units)
  if breed = players and not (ycor >= max-pycor - 1) [
    if (not any? turtles-at 0  height-adjust or (any? mushrooms-at 0 height-adjust and not any? (turtles-at 0 height-adjust) with [breed != mushrooms])) and (xcor <= max-pxcor - 1) [set ycor ycor + 1]]
  
end

to move-jump-down-part ;makes sure the player falls to the ground
  if breed = players and not (ycor = min-pycor) [
    if not any? turtles-at 0 (-1 * height-adjust) and (xcor <= max-pxcor - 1)  [set ycor ycor - 1]]
end

to prize-condition ;turns question-blocks into used blocks if the player smashes into them from the bottom
  if (breed = question-blocks or breed = disguised-blocks or breed = hidden-blocks) and any? players-at 0 -2 [
    set mushroom-x xcor set mushroom-y ycor 
    set hidden? false ;for the hidden-blocks  
    let old-color color                          
    flash .01 set color old-color  
    if any? mushrooms-here [
      ask one-of mushrooms with [xcor = mushroom-x and ycor = mushroom-y] [
        ifelse shape = "coin" or shape = "green mushroom" or shape = "star"
        [
          set hidden? false 
          set ycor ycor + 1
          if shape = "coin" 
          [wait .1 set points points + 200 set coins coins + 1  die]]
        [correct-mushroom-shape set ycor ycor + 1]]] 
    if not any? mushrooms-here [ ;so that the multiple coin hidden block can keep popping out coins without turning into a used-block until all the coins are exhausted
      set breed used-blocks set shape "used-block" set color 27]]
  break-condition
end


to correct-mushroom-shape
  ifelse [level] of player player-number > 0 
  [set shape "fire flower"]
  [set shape "mushroom"]
end


to break-condition ;destroys empty blocks when mario is leveled up
  if breed = empty-blocks and any? players-at 0 -2 [
    if ([level] of player player-number) >= 1 
    [
      flash .02
      set color 23
      set shape "broken-block1"
      wait .05
      set color 23
      set shape "broken-block2"
      wait .02
      die
    ]
  ]
end

to flash [time];flashes turtle before death 
  set color blue wait time set color yellow wait time set color red wait time set color green wait time set color white wait time 
end


;Frame Changing  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

;Main all game fram change functions ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to move-grid
  if xcor >= max-pxcor - 5 and move-state
  [
    set xcor xcor - 1
    ask turtles with [xcor = min-pxcor] [die] 
    ask other turtles [set xcor xcor - 1]
    set move-state false 
    set make-state 1
  ]
end

to set-move-state
  ask players [
    set move-state true]
end

to everytime [number]
  set column number
  set make-state 0
end
;World 1 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-normal-ground-level-one
  setup-ground-blocks 1 0 max-pxcor 24
  setup-ground-blocks 1 1 max-pxcor 24
end

to kill-all
  ask turtles [die] wait 3
end  

;Level one repeat columns ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to make-plain-column-level-one [number]
  if make-state = 1 and column = number
  [
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-enemy-column-level-one [number]
  if make-state = 1 and column = number
  [
    setup-enemies 2 max-pxcor "goomba" 48
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-high_empty-column [number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks 1 10 max-pxcor "empty-block" 23
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-low_empty-column [number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks 1 6 max-pxcor "empty-block" 23
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-low_empty-high_question-column [number prize prize-color]
  if make-state = 1 and column = number
  [
    setup-question-blocks 1 10 max-pxcor prize prize-color
    setup-empty-blocks 1 6 max-pxcor "empty-block" 23
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-low_question-column [number prize prize-color]
  if make-state = 1 and column = number
  [
    setup-question-blocks 1 6 max-pxcor prize prize-color
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-pipe-left-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-left how-high 2 max-pxcor 
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-pipe-right-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-right how-high 2 max-pxcor 
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-above-ground-stack-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-above-ground-blocks how-high 2 max-pxcor "above-ground-block" 27
    setup-normal-ground-level-one
    everytime (number + 1)
  ]
end

to make-empty-column [number]
  if make-state = 1 and column = number
  [
    everytime (number + 1)
  ]
end


;Level 1 generating ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;intial setup functions ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-ground-initial-level-one-world-one ;sets up all intial ground blocks
  update-output
  setup-ground-blocks (max-pxcor + 1) 0 0 24
  setup-ground-blocks (max-pxcor + 1) 1 0 24
  set new-level 0
end
;column change ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-column-level-one-world-one
  if game-level = 0 and world = 0 and new-level = 1 [
    ask players [
      move-grid 
      set-move-state ;makes sure that the player can move the grid later
    ]
    ;-------------------- Hard-coded columns for level one
    make-low_empty-column 0
    make-plain-column-level-one 1
    make-plain-column-level-one 2
    make-plain-column-level-one 3
    make-low_empty-column 4
    if make-state = 1 and column = 5
    [
      setup-enemies 2 max-pxcor  "goomba" 48
      setup-question-blocks 1 6 max-pxcor "mushroom" red
      setup-normal-ground-level-one
      everytime 6
    ]
    make-low_empty-high_question-column 6 "coin" orange
    make-low_question-column 7 "coin" orange
    make-low_empty-column 8
    make-plain-column-level-one 9
    make-plain-column-level-one 10
    make-plain-column-level-one 11
    make-pipe-left-column 1 12
    make-pipe-right-column 1 13
    make-plain-column-level-one 14
    make-plain-column-level-one 15
    make-plain-column-level-one 16
    make-plain-column-level-one 17
    make-plain-column-level-one 18
    make-plain-column-level-one 19 
    make-plain-column-level-one 20
    make-plain-column-level-one 21
    make-pipe-left-column 2 22
    make-pipe-right-column 2 23
    make-enemy-column-level-one 24
    make-plain-column-level-one 25
    make-plain-column-level-one 26
    make-plain-column-level-one 27
    make-plain-column-level-one 28
    make-plain-column-level-one 29
    make-pipe-left-column 3 30
    make-pipe-right-column 3 31
    make-plain-column-level-one 32
    make-plain-column-level-one 33
    make-plain-column-level-one 34
    make-plain-column-level-one 35
    make-plain-column-level-one 36
    make-enemy-column-level-one 37
    make-enemy-column-level-one 38
    make-plain-column-level-one 39
    make-plain-column-level-one 40
    if make-state = 1 and column = 41
    [
      setup-pipe-left 3 2 max-pxcor 
      ask pipe-blocks with [xcor = max-pxcor and ycor = 5] [set entrance 1]
      setup-normal-ground-level-one
      everytime 42
    ]
    if make-state = 1 and column = 42
    [
      setup-pipe-right 3 2 max-pxcor 
      ask pipe-blocks with [xcor = max-pxcor and ycor = 5] [set entrance 1]
      setup-normal-ground-level-one
      everytime 43
    ]
    make-plain-column-level-one 43
    make-plain-column-level-one 44
    make-plain-column-level-one 45
    make-plain-column-level-one 46
    make-plain-column-level-one 47
    if make-state = 1 and column = 48
    [
      setup-hidden-blocks 1 7 max-pxcor "green mushroom" (green - 2) 1
      setup-normal-ground-level-one
      everytime 49
    ] 
    make-plain-column-level-one 49
    make-plain-column-level-one 50
    make-plain-column-level-one 51
    make-plain-column-level-one 52
    make-empty-column 53
    make-empty-column 54
    make-plain-column-level-one 55 
    make-plain-column-level-one 56
    make-plain-column-level-one 57
    make-plain-column-level-one 58
    make-plain-column-level-one 59
    make-plain-column-level-one 60
    make-low_empty-column 61
    make-low_question-column 62 mushroom-state red
    if make-state = 1 and column = 63
    [
      setup-enemies 8 max-pxcor  "goomba" 48
      setup-empty-blocks 1 10 max-pxcor "empty-block" 23
      setup-normal-ground-level-one
      everytime 64
    ] 
    make-low_empty-column 63
    make-high_empty-column 64
    make-high_empty-column 65
    if make-state = 1 and column = 66
    [
      setup-enemies 11 max-pxcor "goomba" 48
      setup-empty-blocks 1 10 max-pxcor "empty-block" 23
      setup-normal-ground-level-one
      everytime 67
    ] 
    make-high_empty-column 67
    make-high_empty-column 68 
    make-high_empty-column 69
    if make-state = 1 and column = 70
    [
      setup-empty-blocks 1 10 max-pxcor "empty-block" 23
      everytime 71
    ] 
    if make-state = 1 and column = 71
    [
      setup-empty-blocks 1 10 max-pxcor "empty-block" 23
      everytime 72
    ]
    make-empty-column 72
    make-plain-column-level-one 73
    make-plain-column-level-one 74
    make-high_empty-column 75
    make-high_empty-column 76
    make-high_empty-column 77
    if make-state = 1 and column = 78
    [
      setup-empty-blocks 1 10 max-pxcor "empty-block" 23
      setup-disguised-blocks 1 6 max-pxcor "coin" orange 10  "empty-block" 23
      setup-normal-ground-level-one
      everytime 79
    ];hidden 10 coins
    make-enemy-column-level-one 79
    make-plain-column-level-one 80
    make-enemy-column-level-one 81
    make-plain-column-level-one 82
    make-plain-column-level-one 83
    make-low_empty-column 84
    if make-state = 1 and column = 85
    [
      setup-disguised-blocks 1 6 max-pxcor "star" orange 1 "empty-block" 23
      setup-normal-ground-level-one
      everytime 86
    ] ;hidden star 
    make-plain-column-level-one 86
    make-plain-column-level-one 87
    make-plain-column-level-one 88 
    make-plain-column-level-one 89
    if make-state = 1 and column = 90
    [
      setup-enemies 2 max-pxcor "koopa" lime
      setup-question-blocks 1 6 max-pxcor "coin" orange
      setup-normal-ground-level-one
      everytime 91
    ]
    make-plain-column-level-one 91
    make-plain-column-level-one 92
    if make-state = 1 and column = 93
    [
      setup-question-blocks 1 10 max-pxcor mushroom-state red
      setup-question-blocks 1 6 max-pxcor "coin" orange
      setup-normal-ground-level-one
      everytime 94
    ]
    make-plain-column-level-one 94
    make-plain-column-level-one 95
    if make-state = 1 and column = 96
    [
      setup-question-blocks 1 6 max-pxcor "coin" orange
      setup-normal-ground-level-one
      everytime 97
    ]
    make-plain-column-level-one 97
    make-plain-column-level-one 98
    make-plain-column-level-one 99
    make-plain-column-level-one 100
    make-plain-column-level-one 101
    make-low_empty-column 102
    make-plain-column-level-one 103
    make-plain-column-level-one 104
    make-high_empty-column 105 
    make-high_empty-column 106
    make-high_empty-column 107
    make-enemy-column-level-one 108
    make-enemy-column-level-one 109
    make-enemy-column-level-one 110
    make-enemy-column-level-one 111
    make-high_empty-column 112
    make-low_empty-high_question-column 113 "coin" orange
    make-low_empty-high_question-column 114 "coin" orange
    make-high_empty-column 115
    make-plain-column-level-one 116
    make-plain-column-level-one 117
    make-above-ground-stack-column 1 118
    make-above-ground-stack-column 2 119
    make-above-ground-stack-column 3 120
    make-above-ground-stack-column 4 121
    make-plain-column-level-one 122
    make-plain-column-level-one 123
    make-above-ground-stack-column 4 124
    make-above-ground-stack-column 3 125
    make-above-ground-stack-column 2 126
    make-above-ground-stack-column 1 127
    make-plain-column-level-one 128
    make-plain-column-level-one 129
    make-plain-column-level-one 130
    make-plain-column-level-one 131
    make-above-ground-stack-column 1 132
    make-above-ground-stack-column 2 133
    make-above-ground-stack-column 3 134
    make-above-ground-stack-column 4 135
    make-above-ground-stack-column 4 136
    make-empty-column 137
    make-empty-column 138
    make-above-ground-stack-column 4 139
    make-above-ground-stack-column 3 140
    make-above-ground-stack-column 2 141
    make-above-ground-stack-column 1 142
    make-plain-column-level-one 143
    make-plain-column-level-one 144
    make-plain-column-level-one 145
    make-plain-column-level-one 146
    make-pipe-left-column 1 147
    make-pipe-right-column 1 148
    make-plain-column-level-one 149
    make-plain-column-level-one 150
    make-plain-column-level-one 151
    make-low_empty-column 152
    make-low_empty-column 153
    make-low_question-column 154 "coin" orange
    make-low_empty-column 155
    make-plain-column-level-one 156
    make-enemy-column-level-one 157
    make-plain-column-level-one 158
    make-enemy-column-level-one 159
    make-plain-column-level-one 160
    make-plain-column-level-one 161
    make-plain-column-level-one 162
    make-pipe-left-column 1 163
    make-pipe-right-column 1 164
    make-above-ground-stack-column 1 165
    make-above-ground-stack-column 2 166
    make-above-ground-stack-column 3 167
    make-above-ground-stack-column 4 168
    make-above-ground-stack-column 5 169
    make-above-ground-stack-column 6 170
    make-above-ground-stack-column 7 171
    make-above-ground-stack-column 8 172
    make-above-ground-stack-column 8 173
    make-plain-column-level-one 174
    make-plain-column-level-one 175
    make-plain-column-level-one 176
    make-plain-column-level-one 177
    make-plain-column-level-one 178
    make-plain-column-level-one 179
    make-plain-column-level-one 180
    make-plain-column-level-one 181
    if make-state = 1 and column = 182
    [
      setup-flag
      setup-normal-ground-level-one
      everytime 183
    ]
    make-plain-column-level-one 183
    make-plain-column-level-one 184
    make-plain-column-level-one 185 ;level stops
    make-plain-column-level-one 186
  ]
end

;Secret Underground place code----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-underworld-level-one-world-one
  if game-level = .5 and world = 0 and make-state = 0 [
    import-drawing "black.jpeg"
    ask turtles with [breed != players] [die]
    wait 2
    ask players [set ycor (12 + height-adjust) set xcor 3 set hidden? false]
    setup-coins 7 6 4
    setup-coins 7 8 4
    setup-coins 5 10 5
    setup-ground-blocks 16 0 0 84
    setup-ground-blocks 16 1 0 84
    setup-empty-blocks-stack 14 2 0 "empty-block-blue" 84
    setup-empty-blocks 7 2 4 "empty-block-blue" 84
    setup-empty-blocks 7 3 4 "empty-block-blue" 84
    setup-empty-blocks 7 4 4 "empty-block-blue" 84
    setup-empty-blocks 7 5 4 "empty-block-blue" 84
    setup-empty-blocks 7 15 4 "empty-block-blue" 84
    setup-pipe-stack-left 14 2 16
    create-pipe-blocks 1 [set xcor 14 set ycor 3 set color 53 set size 1 set shape "pipe top top" set exit 1]
    create-pipe-blocks 1 [set xcor 14 set ycor 2 set color 53 set size 1 set shape "pipe top bottom" set exit 1]
    create-pipe-blocks 1 [set xcor 15 set ycor 2 set color 53 set size 1 set shape "body pipe 2"]
    create-pipe-blocks 1 [set xcor 15 set ycor 3 set color 53 set size 1 set shape "body pipe 1"]
    create-pipe-blocks 1 [set xcor 16 set ycor 3 set size 1 set color 53 set shape "body pipe ir 1"]
    create-pipe-blocks 1 [set xcor 16 set ycor 2 set size 1 set color 53 set shape "body pipe ir 2"]
    set make-state 1
  ]
  underworld-level-one-world-one-conditions
end

to setup-coins [how-many height x-coordinate]
  repeat how-many [
    create-mushrooms 1 [set ycor height set shape "coin" set color orange set xcor x-coordinate]
    set x-coordinate (x-coordinate + 1)
  ]
end

to underworld-level-one-world-one-conditions
  if any? players with [ycor >= 2 and xcor = (max-pxcor - 2)]
  [
    wait 1.5 setup-comeback-world-level-one-world-one]
end

to setup-pipe-stack-left [how-high height x-coordinate]
  repeat how-high [
    create-empty-blocks 1 [set ycor height set shape "body pipe stack" set xcor x-coordinate]
    set height (height + 1)]
end

to setup-comeback-world-level-one-world-one
  import-drawing "bild.jpg"
  ask players [ask other turtles [die] set xcor 3 set ycor (3 + height-adjust)]
  setup-ground-initial-level-one-world-one
  setup-pipe-left 1 2 3
  setup-pipe-right 1 2 4
  setup-empty-blocks 2 6 8 "empty-block" 23
  setup-question-blocks 1 6 10 "coin" orange
  setup-empty-blocks 1 6 11 "empty-block" 23
  setup-enemies 2 13 "goomba" 48
  setup-enemies 2 15 "goomba" 48
  set game-level 0
  set column 161
  set new-level 1
  set make-state 1
end


;End level animation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to level-one-ending
  set points points + (50 * game-time)
  flag-points
  update-output
  repeat 8 [
    ask flags with [shape = "flag"] [wait .2 set ycor ycor - 1]
  ]
  repeat 15 [
    ask players [
      wait .5
      ask turtles with [xcor = min-pxcor] [die] 
      ask other turtles [set xcor xcor - 1]]
    setup-normal-ground-level-one
  ]
  ask players [
    repeat 5 [
      wait .5
      set xcor xcor - 1]]
  
  create-castles 1 [set shape "castle" set color brown set xcor 13 set ycor 4 set size 5]
  ask players [
    while [xcor != 13] [
      wait .5 
      set xcor xcor + 1]
    if xcor = 13 [wait 1 set new-level 0 set game-level 1]]
end

to flag-points
  if flag-score >= 11 [set points points + 5000]
  if flag-score >= 10  and flag-score < 11[set points points + 2000]
  if flag-score >= 9 and flag-score < 10[set points points + 800]
  if flag-score >= 7 and flag-score < 9 [set points points + 400]
  if flag-score >= 5 and flag-score < 7 [set points points + 200]
  if flag-score < 5 [set points points + 100]
end
;Level 2 Repeating functions----------------------------------------------------------------------------------------------------------------------------------------------------------------------

to setup-normal-ground-level-two
  setup-empty-blocks 1 16 max-pxcor "empty-block-blue" 84
  setup-empty-blocks 1 15 max-pxcor "empty-block-blue" 84
  setup-empty-blocks 1 12 max-pxcor "empty-block-blue" 84
  setup-ground-blocks 1 0 max-pxcor 84
  setup-ground-blocks 1 1 max-pxcor 84
end

to make-plain-column-level-two [number]
  if make-state = 1 and column = number
  [
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-empty-block-stack-column [how-high height number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks-stack how-high height max-pxcor "empty-block-blue" 84
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-empty-block-stack-column-two [how-high-column-one height-column-one how-high-column-two height-column-two number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks-stack how-high-column-one height-column-one max-pxcor "empty-block-blue" 84
    setup-empty-blocks-stack how-high-column-two height-column-two max-pxcor "empty-block-blue" 84
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end


to make-empty-block-stack-column-with-coin [how-high height coin-height-from-block number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks-stack how-high height max-pxcor "empty-block-blue" 84
    setup-normal-ground-level-two
    everytime (number + 1)
  setup-coins 1 (height + how-high + coin-height-from-block) max-pxcor
  ]
end

to make-empty-block-stack-column-with-coin-two [how-high-column-one height-column-one how-high-column-two height-column-two number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks-stack how-high-column-one height-column-one max-pxcor "empty-block-blue" 84
    setup-coins 1 (height-column-one + how-high-column-one) max-pxcor
  setup-empty-blocks-stack how-high-column-two height-column-two max-pxcor "empty-block-blue" 84
  setup-normal-ground-level-two
  everytime (number + 1)
  ]
end


to make-above-ground-stack-column-level-two [how-high number]
  if make-state = 1 and column = number
  [
    setup-above-ground-blocks how-high 2 max-pxcor "above-ground-block-blue" 93
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-empty-column-level-two [number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks 1 16 max-pxcor "empty-block-blue" 84
    setup-empty-blocks 1 15 max-pxcor "empty-block-blue" 84
    setup-empty-blocks 1 12 max-pxcor "empty-block-blue" 84
    everytime (number + 1)
  ]
end

to make-enemy-column-level-two [number]
  if make-state = 1 and column = number
  [
    setup-enemies 2 max-pxcor "blue goomba" 48
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-pipe-left-column-level-two [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-left how-high 2 max-pxcor 
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-pipe-right-column-level-two [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-right how-high 2 max-pxcor 
    setup-normal-ground-level-two
    everytime (number + 1)
  ]
end

to make-empty-block-stack-column-no-top [how-high height number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks-stack how-high height max-pxcor "empty-block-blue" 84
    setup-ground-blocks 1 0 max-pxcor 84
    setup-ground-blocks 1 1 max-pxcor 84
    everytime (number + 1)
  ]
end

to make-platform-column [number]
  if make-state = 1 and column = number
  [
    create-platforms 1 [set xcor max-pxcor set ycor 3 set shape "platform"]
  create-platforms 1 [set xcor max-pxcor set ycor 9 set shape "platform"]
  everytime (number + 1)
  ]
end


;Level 2 generating ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;intial setup functions ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-ground-initial-level-two-world-one ;sets up all intial ground blocks
  update-output
  setup-empty-blocks-stack 15 2 min-pxcor "empty-block-blue" 84
  setup-ground-blocks 17 0 0 84
  setup-ground-blocks 17 1 0 84
  setup-empty-blocks 11 16 6 "empty-block-blue" 84
  setup-empty-blocks 11 15 6 "empty-block-blue" 84
  setup-empty-blocks 11 12 6 "empty-block-blue" 84
  setup-question-blocks 1 5 10 "mushroom" red
  setup-question-blocks 4 5 11 "coin" orange
  setup-enemies 2 max-pxcor "blue goomba" 48
  set new-level 1
end



;column change ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-column-level-two-world-one
  if new-level = 0 and game-level = 1 and world = 0 
  [setup-level-two]
  if new-level =  1 and game-level = 1 and world = 0 [
    ask players [
      move-grid 
      set-move-state ;makes sure that the player can move the grid later
    ]
    ;-------------------- Hard-coded columns for level two
    if make-state = 1 and column = 0
    [
      setup-enemies 3 max-pxcor "blue goomba" 48
      setup-above-ground-blocks 1 2 max-pxcor "above-ground-block-blue" 93
      setup-normal-ground-level-two
      everytime 1
    ]
    make-plain-column-level-two 1
    make-above-ground-stack-column-level-two 2 2 
    make-plain-column-level-two 3
    make-above-ground-stack-column-level-two 3 4 
    make-plain-column-level-two 5
    make-above-ground-stack-column-level-two 4 6 
    make-plain-column-level-two 7
    make-above-ground-stack-column-level-two 4 8 
    make-plain-column-level-two 9
    make-above-ground-stack-column-level-two 3 10 
    make-plain-column-level-two 11
    if make-state = 1 and column = 12
    [
      setup-enemies 2 max-pxcor "blue goomba" 48
      setup-disguised-blocks 1 6 max-pxcor "coin" orange 10 "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 13
    ]
    make-plain-column-level-two 13
    make-above-ground-stack-column-level-two 3 14  
    make-plain-column-level-two 15
    make-above-ground-stack-column-level-two 2 16 
    make-plain-column-level-two 17
    make-plain-column-level-two 18
    make-plain-column-level-two 19
    make-plain-column-level-two 20
    make-plain-column-level-two 21
    make-empty-block-stack-column 3 5 22
    make-empty-block-stack-column-with-coin 1 5 0 23
    make-empty-block-stack-column-with-coin 3 5 1 24
    make-empty-block-stack-column-with-coin 1 7 1 25
    make-empty-block-stack-column-with-coin 1 7 1 26
    if make-state = 1 and column = 27
    [
      setup-enemies 2 max-pxcor "koopa" turquoise
      setup-empty-blocks-stack 3 5 max-pxcor "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 28
      setup-coins 1 9 max-pxcor
    ]
    make-empty-block-stack-column-with-coin 1 5 0 28
    if make-state = 1 and column = 29
    [
      setup-enemies 2 max-pxcor "koopa" turquoise
      setup-empty-blocks-stack 2 5 max-pxcor "empty-block-blue" 84
      setup-disguised-blocks 1 7 max-pxcor "star" orange 1 "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 30
    ]
    make-plain-column-level-two 30
    make-plain-column-level-two 31
    make-plain-column-level-two 32
    make-plain-column-level-two 33
    make-plain-column-level-two 34
    make-empty-block-stack-column 5 5 35
    make-empty-block-stack-column 5 5 36
    make-empty-block-stack-column-two 2 4 2 10 37
    make-empty-block-stack-column-two 2 4 2 10 38
    make-plain-column-level-two 39
    make-empty-block-stack-column-with-coin-two 1 5 2 10 40
    if make-state = 1 and column = 41
    [
      setup-empty-blocks-stack 1 5 max-pxcor "empty-block-blue" 84
      setup-coins 1 6 max-pxcor
      setup-empty-blocks-stack 2 10 max-pxcor "empty-block-blue" 84
      setup-enemies 2 max-pxcor "koopa" turquoise 
      setup-normal-ground-level-two
      everytime 42
    ]
    make-empty-block-stack-column-with-coin-two 1 5 2 10 42
    make-empty-block-stack-column-with-coin-two 1 5 2 10 43
    if make-state = 1 and column = 44
    [
      setup-empty-blocks-stack 6 5 max-pxcor "empty-block-blue" 84
      setup-enemies 2 max-pxcor "blue goomba" 48
      setup-normal-ground-level-two
      everytime 45
    ]
    make-empty-block-stack-column 6 5 45 
    if make-state = 1 and column = 46
    [
      setup-enemies 2 max-pxcor "blue goomba" 48
      setup-normal-ground-level-two
      everytime 47
    ]
    make-plain-column-level-two 47
    make-empty-block-stack-column 2 10 48
    make-empty-block-stack-column 7 5 49
    make-empty-block-stack-column-with-coin-two 1 5 2 10 50
    if make-state = 1 and column = 51
    [
      setup-empty-blocks-stack 1 5 max-pxcor "empty-block-blue" 84
      setup-disguised-blocks 1 6 max-pxcor "mushroom" red  1 "empty-block-blue" 84
      setup-empty-blocks-stack 2 10 max-pxcor "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 52
    ]
    make-plain-column-level-two 52
    make-plain-column-level-two 53
    make-empty-block-stack-column 5 5 54
    if make-state = 1 and column = 55
    [
      setup-empty-blocks-stack 1 5 max-pxcor "empty-block-blue" 84
      setup-disguised-blocks 1 6 max-pxcor "coin" orange 10 "empty-block-blue" 84
      setup-empty-blocks-stack 3 7 max-pxcor "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 56
      setup-enemies 10 max-pxcor "blue goomba" 48
    ]
    make-plain-column-level-two 56
    make-plain-column-level-two 57
    if make-state = 1 and column = 58
    [
      setup-empty-blocks-stack 1 5 max-pxcor "empty-block-blue" 84
      setup-enemies 6 max-pxcor "blue goomba" 48
      setup-empty-blocks-stack 2 10 max-pxcor "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 59
    ]
    make-empty-block-stack-column-two 1 5 2 10 59
    if make-state = 1 and column = 60
    [
      setup-empty-blocks-stack 1 5 max-pxcor "empty-block-blue" 84
      setup-enemies 6 max-pxcor "blue goomba" 48
      setup-empty-blocks-stack 2 10 max-pxcor "empty-block-blue" 84
      setup-normal-ground-level-two
      everytime 61
    ]
    make-empty-block-stack-column-two 1 5 2 10 61
    make-empty-column-level-two 62
    make-empty-column-level-two 63
    make-empty-column-level-two 64
    make-empty-block-stack-column-with-coin 2 6 1 65
    make-empty-block-stack-column-with-coin 2 6 1 66
    make-empty-block-stack-column-with-coin 2 6 1 67
    make-empty-block-stack-column-with-coin 2 6 1 68
    make-empty-block-stack-column-with-coin 2 6 1 69
    if make-state = 1 and column = 70
    [
      setup-empty-blocks-stack 2 6 max-pxcor "empty-block-blue" 84
      setup-empty-blocks 1 16 max-pxcor "empty-block-blue" 84
      setup-empty-blocks 1 15 max-pxcor "empty-block-blue" 84
      setup-disguised-blocks 1 12 max-pxcor "green mushroom" green 1 "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 71
      setup-coins 1 9 max-pxcor
    ]
    make-plain-column-level-two 71
    make-plain-column-level-two 72
    make-plain-column-level-two 73
    make-plain-column-level-two 74
    make-plain-column-level-two 75
    make-plain-column-level-two 76
    make-plain-column-level-two 77
    make-plain-column-level-two 78
    make-plain-column-level-two 79
    make-enemy-column-level-two 80 
    make-plain-column-level-two 81
    make-enemy-column-level-two 82
    make-plain-column-level-two 83
    make-enemy-column-level-two 84
    make-plain-column-level-two 85
    if make-state = 1 and column = 86
    [
      setup-pipe-left 2 2 max-pxcor 
      ask pipe-blocks with [xcor = max-pxcor and ycor = 4] [set entrance 1]
      setup-normal-ground-level-two
      everytime 87
    ]
    if make-state = 1 and column = 87
    [
      setup-pipe-right 2 2 max-pxcor 
      ask pipe-blocks with [xcor = max-pxcor and ycor = 4] [set entrance 1]
      setup-normal-ground-level-two
      everytime 88
    ]
    make-plain-column-level-two 88
    make-plain-column-level-two 89
    make-plain-column-level-two 90
    make-plain-column-level-two 91
    make-pipe-left-column-level-two 3 92
    make-pipe-right-column-level-two 3 93
    make-plain-column-level-two 94
    make-plain-column-level-two 95
    make-enemy-column-level-two 96
    make-plain-column-level-two 97
    make-pipe-left-column-level-two 1 98
    make-pipe-right-column-level-two 1 99
    make-plain-column-level-two 100
    make-plain-column-level-two 101
    make-plain-column-level-two 102
    make-empty-column-level-two 103
    make-empty-column-level-two 104
    make-empty-block-stack-column 3 2 105
    make-empty-block-stack-column 3 2 106
    make-empty-column-level-two 107
    make-empty-column-level-two 108
    make-plain-column-level-two 109
    make-plain-column-level-two 110
    make-plain-column-level-two 111
    make-plain-column-level-two 112
    make-plain-column-level-two 113
    make-plain-column-level-two 114
    make-plain-column-level-two 115
    make-above-ground-stack-column-level-two 1 116
    make-above-ground-stack-column-level-two 2 117
    if make-state = 1 and column = 118
    [
      setup-enemies 5 max-pxcor "blue goomba" 48
      setup-above-ground-blocks 3 2 max-pxcor "above-ground-block-blue" 93
      setup-normal-ground-level-two
      everytime 119
    ]
    make-above-ground-stack-column-level-two 4 119
    if make-state = 1 and column = 120
    [
      setup-enemies 6 max-pxcor "blue goomba" 48
      setup-above-ground-blocks 4 2 max-pxcor "above-ground-block-blue" 93
      setup-normal-ground-level-two
      everytime 121
    ]
    make-empty-column 121
    make-empty-column 122
    make-platform-column 123
    make-platform-column 124
    make-platform-column 125
    make-empty-column 126
    make-empty-column 127
    make-empty-block-stack-column-no-top 1 6 128
    if make-state = 1 and column = 129
    [
      setup-empty-blocks-stack 1 6 max-pxcor "empty-block-blue" 84
      setup-enemies 2 max-pxcor "koopa" (red + 1)
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 130
    ]
    make-empty-block-stack-column-no-top 1 6 130
    make-empty-block-stack-column-no-top 1 6 131
    make-empty-block-stack-column-no-top 1 6 132
    if make-state = 1 and column = 133
    [
      setup-disguised-blocks 1 6 max-pxcor "mushroom" red  1 "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 134
    ]
    make-empty-block-stack-column-no-top 0 6 134
    make-empty-block-stack-column-no-top 0 6 135
    make-empty-column 136
    make-empty-column 137
    make-platform-column 138
    make-platform-column 139
    make-platform-column 140
    make-empty-column 141
    make-empty-column 142
    make-empty-block-stack-column-no-top 3 2 143
    make-empty-block-stack-column 3 2 144
    make-empty-block-stack-column 3 2 145
    make-empty-block-stack-column 3 2 146
    make-empty-block-stack-column 3 2 147
    make-empty-block-stack-column 3 2 148
    if make-state = 1 and column = 149
    [  
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 6 set color 53 set size 1 set shape "pipe top top" set exit 2]
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 5 set color 53 set size 1 set shape "pipe top bottom" set exit 2]
      setup-empty-blocks-stack 3 2 max-pxcor "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 150
    ]
    if make-state = 1 and column = 150
    [  
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 5 set color 53 set size 1 set shape "body pipe 2"]
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 6 set color 53 set size 1 set shape "body pipe 1"]
      setup-empty-blocks-stack 3 2 max-pxcor "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 151
    ]
    if make-state = 1 and column = 151
    [  
      setup-pipe-stack-left 13 4 max-pxcor
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 6 set size 1 set color 53 set shape "body pipe ir 1"]
      create-pipe-blocks 1 [set xcor max-pxcor set ycor 5 set size 1 set color 53 set shape "body pipe ir 2"]
      setup-empty-blocks-stack 3 2 max-pxcor "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 152
    ]
    if make-state = 1 and column = 152
    [  
      setup-pipe-stack-right 15 2 max-pxcor
      setup-empty-blocks-stack 3 2 max-pxcor "empty-block-blue" 84
      setup-ground-blocks 1 0 max-pxcor 84
      setup-ground-blocks 1 1 max-pxcor 84
      everytime 153
    ]
    make-empty-block-stack-column 11 2 154
    make-empty-block-stack-column 11 2 155
    make-empty-block-stack-column 11 2 156
    make-empty-block-stack-column 11 2 157
    make-empty-block-stack-column 11 2 158
    make-empty-block-stack-column 11 2 159
  ]
  if new-level =  1 and game-level = 1.9 and world = 0 [
    ask players [
      move-grid 
      set-move-state ;makes sure that the player can move the grid later
    ]
    make-plain-column-level-one 0
    make-plain-column-level-one 1
    make-plain-column-level-one 2
    make-plain-column-level-one 3
    make-plain-column-level-one 4
    if make-state = 1 and column = 5
    [
      setup-flag
      set flag-state 1
      setup-normal-ground-level-one
      everytime 6
    ]
    make-plain-column-level-one 6
    make-plain-column-level-one 7
    make-plain-column-level-one 8 ;level stops
    make-plain-column-level-one 9
  ]
end

to level-two-ending
  set points points + (50 * game-time)
  flag-points
  update-output
  repeat 8 [
    ask flags with [shape = "flag"] [wait .2 set ycor ycor - 1]
  ]
  repeat 15 [
    ask players [
      wait .5
      ask turtles with [xcor = min-pxcor] [die] 
      ask other turtles [set xcor xcor - 1]]
    setup-normal-ground-level-one
  ]
  ask players [
    repeat 5 [
      wait .5
      set xcor xcor - 1]]
  
  create-castles 1 [set shape "castle" set color brown set xcor 13 set ycor 4 set size 5]
  ask players [
    while [xcor != 13] [
      wait .5 
      set xcor xcor + 1]
    if xcor = 13 [wait 1 set new-level 0 set game-level 10]]
end

;Secret Underground place code----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-underworld-level-two-world-one
  if game-level = 2.5 and world = 0 and make-state = 0 [
    import-drawing "black.jpeg"
    ask turtles with [breed != players] [die]
    wait 2
    ask players [set ycor (12 + height-adjust) set xcor 3 set hidden? false]
    setup-coins 8 6 4
    setup-coins 9 2 3
    setup-ground-blocks 17 0 0 84
    setup-ground-blocks 17 1 0 84
    setup-empty-blocks-stack 14 2 0 "empty-block-blue" 84
    setup-empty-blocks 2 4 13 "empty-block-blue" 84
    setup-empty-blocks 12 5 3 "empty-block-blue" 84
    setup-empty-blocks 2 6 13 "empty-block-blue" 84
    setup-empty-blocks 2 7 13 "empty-block-blue" 84
    setup-empty-blocks 2 8 13 "empty-block-blue" 84
    setup-empty-blocks 12 9 3 "empty-block-blue" 84
    setup-empty-blocks 12 10 3 "empty-block-blue" 84
    setup-empty-blocks 12 11 3 "empty-block-blue" 84
    setup-empty-blocks 12 12 3 "empty-block-blue" 84
    setup-pipe-stack-left 15 2 15
    setup-pipe-stack-right 15 2 16
    create-pipe-blocks 1 [set xcor 13 set ycor 3 set color 53 set size 1 set shape "pipe top top" set exit 1]
    create-pipe-blocks 1 [set xcor 13 set ycor 2 set color 53 set size 1 set shape "pipe top bottom" set exit 1]
    create-pipe-blocks 1 [set xcor 14 set ycor 2 set color 53 set size 1 set shape "body pipe 2"]
    create-pipe-blocks 1 [set xcor 14 set ycor 3 set color 53 set size 1 set shape "body pipe 1"]
    create-pipe-blocks 1 [set xcor 15 set ycor 3 set size 1 set color 53 set shape "body pipe ir 1"]
    create-pipe-blocks 1 [set xcor 15 set ycor 2 set size 1 set color 53 set shape "body pipe ir 2"]
    set make-state 1
  ]
  underworld-level-two-world-one-conditions
end


to underworld-level-two-world-one-conditions
  if any? players with [ycor >= 2 and xcor = 13]
  [
    wait 1.5 setup-abovegound-level-two]
end


to setup-pipe-stack-right [how-high height x-coordinate]
  repeat how-high [
    create-empty-blocks 1 [set ycor height set shape "pipe-body-right" set xcor x-coordinate]
    set height (height + 1)]
end

to setup-abovegound-level-two
  import-drawing "bild.jpg"
  ask players [ask other turtles [die] set xcor 3 set ycor (3 + height-adjust)]
  setup-ground-initial-level-one-world-one
  setup-pipe-left 1 2 3
  setup-pipe-right 1 2 4
  let x-coordinate 5
  let how-high 1
  repeat 8 [
    setup-above-ground-blocks how-high 2 x-coordinate  "above-ground-block" 27
    set x-coordinate x-coordinate + 1
    set how-high how-high + 1
  ]
  setup-above-ground-blocks 8 2 13 "above-ground-block" 27
  set game-level 1.9
  set column 0
  set new-level 1
  set make-state 1
end

to setup-final-ending 
  if new-level = 0 [
  import-drawing "bild.jpg"
  ask players [ask other turtles [die] set xcor 3 set ycor (3 + height-adjust)]
  setup-ground-initial-level-one-world-one
  create-princesses 1 [set xcor 14 set ycor 2.25 set color 28 set shape "princess peach" set size 1.7]]
  set new-level 1
end

to You-win
  ca
  import-drawing "WinPage.jpg"
  wait 5
  stop
end
  
@#$#@#$#@
GRAPHICS-WINDOW
211
67
663
540
-1
-1
26.0
1
10
1
1
1
0
1
1
1
0
16
0
16
0
0
1
ticks
30.0

BUTTON
3
21
203
68
SETUP
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
3
115
95
148
Left
ifelse game\n[move-left]\n[user-message \"You didn't press go! :(\"]
NIL
1
T
TURTLE
NIL
A
NIL
NIL
1

BUTTON
100
116
202
149
Right
ifelse game\n[move-right]\n[user-message \"You didn't press go! :(\"]
NIL
1
T
TURTLE
NIL
D
NIL
NIL
1

BUTTON
50
78
153
111
Jump
ifelse game\n[move-jump 7 .01]\n[user-message \"You didn't press go! :(\"]
NIL
1
T
TURTLE
NIL
W
NIL
NIL
1

BUTTON
3
194
209
245
GO
go\nset game true
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

OUTPUT
211
16
663
70
11

BUTTON
65
155
131
188
Down
move-down
NIL
1
T
TURTLE
NIL
S
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

A imitation of the popular game Super Mario Bros.

Bowser has taken over Mushroom kingdom and has captured Princess Peach. It is up to you (Mario), to save Princess Peach, defeat Bowser and save all of Mushroom Kingdom.

## HOW IT WORKS

If goomba catches you/in the same patch as you, you will lose a life or if you are powered up, you will lose that power up.

If a koopa cataches you/in the same patch as you, you will lose a life or if you are powered up, you will lose that power up.

If there is a block with a question mark on it, there is something inside it that you should bump from underneath the block.

If you get collect a mushroom, you will power up, grow bigger and be able to break blocks.

If you collect a fire flower, you will be able to throw fireballs.

If you collect a starman, you will be invincible against enemies, so that they can't harm you for a short period of time.

## HOW TO USE IT

To move forward, press key D.

To move backward, press key A.

To jump, press key W.

To go down, press key S.

To jump and move forward or backward at the same time, press key W and left-click your mouse to the right or left, depending on your direction.

(ANYTHING ELSE?)

## THINGS TO NOTICE

Do not go too fast or you will get warped back to where you are.

World Map of hidden things: 
http://www.mariomayhem.com/downloads/mario_game_maps/index.php#Super_Mario_Bros

## THINGS TO TRY

Try to break all of the blocks.

Try to empty all the question blocks.

Try going down the pipes.

## EXTENDING THE MODEL

There are many things that can be added to this model like adding more levels and allowing Mario to move backwards past the interactions tab. Another thing that can be added are the moving mushrooms and fire flowers. The reason that it was not included was that it would lag the game.

## NETLOGO FEATURES

Something that was hardcoded was the world after setup and it was repetitive. In the code, many functions had inputs in it to allow repetition and to make columns for the ground blocks, pipes and many other things in Mushroom Kingdom.


## RELATED MODELS

A model that is relatively related to Super Mario Bros is Pacman. This is beacuse in Pacman, if the ghost and Pacman are on the same patch, Pacman will lose a life. Also in Pacman, when Pacman gets a power-up, there is one power-up that is the same as a power-up in Super Mario Bros, invincibility. 

## CREDITS AND REFERENCES

World Maps:
http://www.mariomayhem.com/downloads/mario_game_maps/index.php#Super_Mario_Bros

Pictures:
http://awesomewallpapersblog.com/tag/super-mario-bros/
http://lando5.deviantart.com/art/Mario-Wallpaper-52837909
http://www.mariowiki.com/Super_Mario_Bros.#Characters
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

above ground open piranha
false
5
Rectangle -13840069 true false 201 4 218 20
Rectangle -10899396 true true 196 15 217 33
Rectangle -13840069 true false 81 4 97 21
Rectangle -10899396 true true 84 15 107 41
Rectangle -13840069 true false 104 39 112 62
Rectangle -13840069 true false 187 37 195 60
Rectangle -13840069 true false 120 165 180 210
Rectangle -13840069 true false 90 150 135 195
Rectangle -13840069 true false 75 150 135 180
Rectangle -13840069 true false 60 150 135 165
Rectangle -13840069 true false 165 150 240 165
Rectangle -13840069 true false 165 150 210 195
Rectangle -13840069 true false 165 150 225 180
Rectangle -13840069 true false 45 120 135 150
Rectangle -13840069 true false 165 105 255 150
Rectangle -13840069 true false 45 60 120 120
Rectangle -13840069 true false 180 60 255 120
Rectangle -13840069 true false 60 45 105 60
Rectangle -13840069 true false 195 45 240 60
Rectangle -13840069 true false 75 30 105 60
Rectangle -13840069 true false 195 30 225 60
Rectangle -955883 true false 135 210 165 300
Rectangle -13840069 true false 195 255 210 270
Rectangle -13840069 true false 225 225 240 240
Rectangle -13840069 true false 240 210 255 225
Rectangle -6459832 true false 195 225 225 240
Rectangle -955883 true false 195 225 210 255
Rectangle -955883 true false 180 240 210 255
Rectangle -955883 true false 180 240 195 270
Rectangle -6459832 true false 165 270 180 285
Rectangle -955883 true false 150 270 180 300
Rectangle -6459832 true false 240 225 270 240
Rectangle -955883 true false 240 225 255 255
Rectangle -955883 true false 225 240 255 255
Rectangle -955883 true false 165 285 195 300
Rectangle -13840069 true false 210 240 225 255
Rectangle -13840069 true false 180 270 195 285
Rectangle -955883 true false 210 210 225 240
Rectangle -6459832 true false 225 210 240 225
Rectangle -955883 true false 225 195 240 225
Rectangle -955883 true false 225 195 255 210
Rectangle -955883 true false 255 195 270 240
Rectangle -955883 true false 225 240 240 270
Rectangle -955883 true false 210 255 240 270
Rectangle -955883 true false 210 255 225 285
Rectangle -955883 true false 195 270 225 285
Rectangle -955883 true false 195 270 210 300
Rectangle -955883 true false 120 270 150 300
Rectangle -955883 true false 90 285 135 300
Rectangle -13840069 true false 105 270 120 285
Rectangle -13840069 true false 90 255 105 270
Rectangle -13840069 true false 75 240 90 255
Rectangle -13840069 true false 60 225 75 240
Rectangle -13840069 true false 45 210 60 225
Rectangle -6459832 true false 75 270 105 285
Rectangle -6459832 true false 45 225 60 255
Rectangle -6459832 true false 60 240 75 270
Rectangle -6459832 true false 75 255 90 285
Rectangle -955883 true false 30 195 45 240
Rectangle -955883 true false 90 270 105 300
Rectangle -955883 true false 30 225 60 240
Rectangle -955883 true false 60 255 90 270
Rectangle -955883 true false 45 240 75 255
Rectangle -955883 true false 75 270 105 285
Rectangle -955883 true false 30 195 75 210
Rectangle -955883 true false 60 195 75 225
Rectangle -955883 true false 60 210 90 225
Rectangle -955883 true false 75 210 90 240
Rectangle -955883 true false 75 225 105 240
Rectangle -955883 true false 90 225 105 255
Rectangle -955883 true false 90 240 120 255
Rectangle -955883 true false 105 240 120 270
Rectangle -13840069 true false 45 105 135 135
Rectangle -13840069 true false 75 15 90 45
Rectangle -13840069 true false 210 15 225 45
Rectangle -1 true false 120 105 135 120
Rectangle -1 true false 165 105 180 120
Polygon -1 true false 111 60 132 37 103 34 111 60
Polygon -1 true false 187 61 165 38 194 36 187 61
Rectangle -1184463 true false 225 30 240 45
Rectangle -1184463 true false 240 60 255 75
Rectangle -1184463 true false 195 45 210 60
Rectangle -1184463 true false 195 15 210 30
Polygon -1 true false 194 38 205 14 174 13 194 38
Rectangle -1184463 true false 180 75 195 90
Polygon -1 true false 180 84 159 61 187 58 180 84
Polygon -1 true false 180 105 157 81 181 84 180 105
Rectangle -1184463 true false 240 105 255 120
Rectangle -1184463 true false 210 75 225 90
Rectangle -1184463 true false 180 105 195 120
Rectangle -1184463 true false 240 135 255 150
Rectangle -1184463 true false 210 120 225 135
Rectangle -1184463 true false 195 150 210 165
Rectangle -1184463 true false 165 135 180 150
Rectangle -1184463 true false 195 180 210 195
Rectangle -1184463 true false 165 165 180 180
Rectangle -1184463 true false 90 15 105 30
Polygon -1 true false 105 37 92 14 125 12 105 37
Rectangle -1184463 true false 90 45 105 60
Rectangle -1184463 true false 60 30 75 45
Rectangle -1184463 true false 45 60 60 75
Rectangle -1184463 true false 75 75 90 90
Rectangle -1184463 true false 105 75 120 90
Polygon -1 true false 120 84 140 59 110 59 120 84
Polygon -1 true false 120 105 143 81 120 84 120 105
Rectangle -1184463 true false 105 105 120 120
Rectangle -1184463 true false 120 135 135 150
Rectangle -1184463 true false 120 165 135 180
Rectangle -1184463 true false 90 180 105 195
Rectangle -1184463 true false 75 150 90 165
Rectangle -1184463 true false 45 135 60 150
Rectangle -1184463 true false 75 120 90 135
Rectangle -1184463 true false 45 105 60 120
Rectangle -1184463 true false 150 195 165 210
Rectangle -955883 true false 195 225 225 240

above-ground-block
false
0
Polygon -7500403 true true 300 0 225 75 75 75 0 0 300 0
Polygon -7500403 true true 0 0 75 75 75 225 0 300 0 0
Polygon -16777216 true false 300 300 225 225 225 75 300 0 300 300
Polygon -16777216 true false 0 300 75 225 225 225 300 300 0 300
Rectangle -6459832 true false 75 75 225 225
Rectangle -6459832 true false 0 0 15 15
Rectangle -6459832 true false 15 15 30 30
Rectangle -6459832 true false 30 30 45 45
Rectangle -6459832 true false 45 45 60 60
Rectangle -6459832 true false 60 60 75 75
Rectangle -16777216 true false 225 60 240 75
Rectangle -16777216 true false 240 45 255 60
Rectangle -16777216 true false 255 30 270 45
Rectangle -16777216 true false 270 15 285 30
Rectangle -16777216 true false 285 0 300 15
Rectangle -16777216 true false 0 285 15 300
Rectangle -16777216 true false 15 270 30 285
Rectangle -16777216 true false 30 255 45 270
Rectangle -16777216 true false 45 240 60 255
Rectangle -16777216 true false 60 225 75 240
Rectangle -6459832 true false 285 285 300 300
Rectangle -6459832 true false 270 270 285 285
Rectangle -6459832 true false 255 255 270 270
Rectangle -6459832 true false 240 240 255 255
Rectangle -6459832 true false 225 225 240 240

above-ground-block-blue
false
3
Polygon -11221820 true false 300 0 225 75 75 75 0 0 300 0
Polygon -11221820 true false 0 0 75 75 75 225 0 300 0 0
Polygon -16777216 true false 300 300 225 225 225 75 300 0 300 300
Polygon -16777216 true false 0 300 75 225 225 225 300 300 0 300
Rectangle -6459832 true true 75 75 225 225
Rectangle -6459832 true true 0 0 15 15
Rectangle -6459832 true true 15 15 30 30
Rectangle -6459832 true true 30 30 45 45
Rectangle -6459832 true true 45 45 60 60
Rectangle -6459832 true true 60 60 75 75
Rectangle -16777216 true false 225 60 240 75
Rectangle -16777216 true false 240 45 255 60
Rectangle -16777216 true false 255 30 270 45
Rectangle -16777216 true false 270 15 285 30
Rectangle -16777216 true false 285 0 300 15
Rectangle -16777216 true false 0 285 15 300
Rectangle -16777216 true false 15 270 30 285
Rectangle -16777216 true false 30 255 45 270
Rectangle -16777216 true false 45 240 60 255
Rectangle -16777216 true false 60 225 75 240
Rectangle -11221820 true false 285 285 300 300
Rectangle -11221820 true false 270 270 285 285
Rectangle -11221820 true false 255 255 270 270
Rectangle -11221820 true false 240 240 255 255
Rectangle -11221820 true false 225 225 240 240

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

blue goomba
false
0
Rectangle -11221820 true false 90 150 225 270
Rectangle -13791810 true false 120 15 195 45
Rectangle -13791810 true false 105 30 210 60
Rectangle -13791810 true false 90 45 225 75
Rectangle -13791810 true false 75 60 240 105
Rectangle -13791810 true false 60 75 255 105
Rectangle -13791810 true false 45 90 270 135
Rectangle -13791810 true false 30 120 285 165
Rectangle -16777216 true false 120 105 195 120
Rectangle -13791810 true false 45 150 105 180
Rectangle -13791810 true false 210 150 270 180
Rectangle -16777216 true false 75 75 105 90
Rectangle -16777216 true false 210 75 240 90
Rectangle -16777216 true false 105 90 128 135
Rectangle -11221820 true false 90 90 105 135
Rectangle -11221820 true false 90 135 130 150
Rectangle -11221820 true false 128 120 143 150
Rectangle -11221820 true false 210 90 225 150
Rectangle -11221820 true false 178 120 195 150
Rectangle -11221820 true false 180 135 225 150
Rectangle -16777216 true false 193 90 210 135
Rectangle -16777216 true false 225 210 255 240
Rectangle -16777216 true false 195 225 270 255
Rectangle -16777216 true false 180 240 255 270
Rectangle -16777216 true false 75 225 105 255
Rectangle -16777216 true false 75 240 120 255
Rectangle -16777216 true false 90 255 135 270
Rectangle -16777216 true false 90 240 120 270

body pipe 1
false
7
Rectangle -10899396 true false 30 15 330 30
Rectangle -14835848 true true 0 15 30 300
Rectangle -13840069 true false 30 30 300 300
Rectangle -10899396 true false 30 105 300 135
Rectangle -10899396 true false 30 225 300 240
Rectangle -10899396 true false 30 285 300 315

body pipe 2
false
7
Rectangle -13840069 true false 0 165 300 285
Rectangle -10899396 true false 0 270 300 285
Rectangle -10899396 true false 285 0 315 270
Rectangle -10899396 true false 15 225 30 240
Rectangle -10899396 true false 15 180 30 210
Rectangle -10899396 true false 105 225 120 240
Rectangle -10899396 true false 90 210 105 225
Rectangle -10899396 true false 60 210 75 225
Rectangle -10899396 true false 75 225 90 240
Rectangle -10899396 true false 30 210 45 225
Rectangle -10899396 true false 45 225 60 240
Rectangle -10899396 true false 270 210 285 225
Rectangle -10899396 true false 255 225 270 240
Rectangle -10899396 true false 240 210 255 225
Rectangle -10899396 true false 225 225 240 240
Rectangle -10899396 true false 210 210 225 225
Rectangle -10899396 true false 195 225 210 240
Rectangle -10899396 true false 180 210 195 225
Rectangle -10899396 true false 165 225 180 240
Rectangle -10899396 true false 150 210 165 225
Rectangle -10899396 true false 135 225 150 240
Rectangle -10899396 true false 120 210 135 225
Rectangle -10899396 true false 225 180 240 210
Rectangle -10899396 true false 195 180 210 210
Rectangle -10899396 true false 165 180 180 210
Rectangle -10899396 true false 135 165 150 210
Rectangle -10899396 true false 105 180 120 210
Rectangle -10899396 true false 75 180 90 210
Rectangle -10899396 true false 45 180 60 210
Rectangle -10899396 true false 255 180 270 210
Rectangle -10899396 true false -15 0 300 210
Rectangle -14835848 true true -15 0 30 285

body pipe ir 1
false
7
Rectangle -13840069 true false 150 0 300 30
Rectangle -13840069 true false 0 15 300 315
Rectangle -10899396 true false 0 15 75 30
Rectangle -10899396 true false 240 0 270 300
Rectangle -10899396 true false 0 105 135 135
Rectangle -10899396 true false 0 225 150 240
Rectangle -14835848 true true 105 90 120 150
Rectangle -13840069 true false 75 0 120 75
Rectangle -14835848 true true 90 45 105 90
Rectangle -10899396 true false 120 0 165 300
Rectangle -14835848 true true 60 0 75 15
Rectangle -14835848 true true 75 30 90 45
Rectangle -14835848 true true 120 150 135 300
Rectangle -14835848 true true 60 15 75 30
Rectangle -10899396 true false 0 285 120 300

body pipe ir 2
false
7
Rectangle -13840069 true false 135 0 300 165
Rectangle -13840069 true false 0 165 300 285
Rectangle -10899396 true false 0 270 90 285
Rectangle -10899396 true false 15 225 30 240
Rectangle -10899396 true false 15 180 30 210
Rectangle -10899396 true false 105 210 120 225
Rectangle -10899396 true false 90 210 105 225
Rectangle -10899396 true false 60 210 75 225
Rectangle -10899396 true false 75 225 90 240
Rectangle -10899396 true false 45 225 60 240
Rectangle -10899396 true false 30 210 45 225
Rectangle -10899396 true false 120 210 135 225
Rectangle -10899396 true false 105 180 120 210
Rectangle -10899396 true false 75 180 90 210
Rectangle -10899396 true false 45 180 60 210
Rectangle -10899396 true false -15 0 135 210
Rectangle -14835848 true true 105 150 120 240
Rectangle -14835848 true true 90 240 105 270
Rectangle -14835848 true true 75 270 90 285
Rectangle -14835848 true true 60 285 75 300
Rectangle -13840069 true false 120 270 300 300
Rectangle -13840069 true false 75 285 135 300
Rectangle -10899396 true false 120 0 165 300
Rectangle -14835848 true true 120 0 135 150
Rectangle -10899396 true false 240 0 270 315
Rectangle -10899396 true false 0 210 15 225

body pipe stack
false
7
Rectangle -13840069 true false 75 0 300 315
Rectangle -10899396 true false 240 0 270 300
Rectangle -10899396 true false 120 0 165 300
Rectangle -10899396 true false 75 0 90 300

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

broken-block1
false
0
Rectangle -7500403 true true 15 180 120 285
Rectangle -7500403 true true 195 180 300 285
Rectangle -7500403 true true 195 15 300 120
Rectangle -7500403 true true 15 15 120 120
Rectangle -16777216 true false 15 225 285 240
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 15 150 285 165
Rectangle -16777216 true false 15 75 285 90
Rectangle -1 true false 15 0 285 15
Rectangle -16777216 true false 0 15 15 285
Rectangle -16777216 true false 135 15 150 75
Rectangle -16777216 true false 75 90 90 150
Rectangle -16777216 true false 195 90 210 150
Rectangle -16777216 true false 270 15 285 75
Rectangle -16777216 true false 270 165 285 225
Rectangle -16777216 true false 75 240 90 285
Rectangle -16777216 true false 195 240 210 285
Rectangle -16777216 true false 135 165 150 225

broken-block2
false
0
Rectangle -7500403 true true 15 225 75 285
Rectangle -7500403 true true 240 225 300 285
Rectangle -7500403 true true 240 15 300 75
Rectangle -7500403 true true 15 15 75 75
Rectangle -16777216 true false 15 225 285 240
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 15 150 285 165
Rectangle -16777216 true false 15 75 285 90
Rectangle -1 true false 15 0 285 15
Rectangle -16777216 true false 0 15 15 285
Rectangle -16777216 true false 135 15 150 75
Rectangle -16777216 true false 75 90 90 150
Rectangle -16777216 true false 195 90 210 150
Rectangle -16777216 true false 270 15 285 75
Rectangle -16777216 true false 270 165 285 225
Rectangle -16777216 true false 75 240 90 285
Rectangle -16777216 true false 195 240 210 285
Rectangle -16777216 true false 135 165 150 225

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

castle
false
0
Rectangle -7500403 true true 0 150 300 299
Rectangle -16777216 true false 1 270 300 279
Rectangle -16777216 true false 1 291 300 300
Rectangle -16777216 true false 1 249 300 258
Rectangle -16777216 true false 1 228 300 237
Rectangle -16777216 true false 0 187 299 196
Rectangle -16777216 true false 0 207 299 216
Rectangle -16777216 true false 0 164 299 173
Rectangle -16777216 true false 103 276 112 307
Rectangle -16777216 true false 58 276 67 307
Rectangle -16777216 true false 13 276 22 307
Rectangle -16777216 true false 148 276 157 307
Rectangle -16777216 true false 193 276 202 307
Rectangle -16777216 true false 238 276 247 307
Rectangle -16777216 true false 283 276 292 307
Rectangle -16777216 true false 13 228 22 253
Rectangle -16777216 true false 13 187 22 215
Rectangle -16777216 true false 58 228 67 253
Rectangle -16777216 true false 103 228 112 253
Rectangle -16777216 true false 148 228 157 253
Rectangle -16777216 true false 193 228 202 253
Rectangle -16777216 true false 238 228 247 253
Rectangle -16777216 true false 283 228 292 253
Rectangle -16777216 true false 58 187 67 215
Rectangle -16777216 true false 103 187 112 215
Rectangle -16777216 true false 148 187 157 215
Rectangle -16777216 true false 193 187 202 215
Rectangle -16777216 true false 238 187 247 215
Rectangle -16777216 true false 283 187 292 215
Rectangle -16777216 true false 34 249 43 277
Rectangle -16777216 true false 79 250 88 278
Rectangle -16777216 true false 123 249 132 277
Rectangle -16777216 true false 168 249 177 277
Rectangle -16777216 true false 213 249 222 277
Rectangle -16777216 true false 258 249 267 277
Rectangle -16777216 true false 123 209 132 237
Rectangle -16777216 true false 78 209 87 237
Rectangle -16777216 true false 33 209 42 237
Rectangle -16777216 true false 168 209 177 237
Rectangle -16777216 true false 213 209 222 237
Rectangle -16777216 true false 258 209 267 237
Rectangle -16777216 true false 33 164 42 192
Rectangle -16777216 true false 78 164 87 192
Rectangle -16777216 true false 123 164 132 192
Rectangle -16777216 true false 168 164 177 192
Rectangle -16777216 true false 213 164 222 192
Rectangle -16777216 true false 258 164 267 192
Rectangle -7500403 true true 60 30 240 151
Rectangle -16777216 true false 60 89 240 99
Rectangle -16777216 true false 60 110 240 120
Rectangle -16777216 true false 61 130 241 140
Rectangle -16777216 true false 0 143 299 152
Rectangle -16777216 true false 13 145 22 173
Rectangle -16777216 true false 58 144 67 172
Rectangle -16777216 true false 103 143 112 171
Rectangle -16777216 true false 148 143 157 171
Rectangle -16777216 true false 193 143 202 171
Rectangle -16777216 true false 238 143 247 171
Rectangle -16777216 true false 283 143 292 171
Rectangle -16777216 true false 60 68 240 78
Rectangle -16777216 true false 60 47 240 57
Rectangle -16777216 true false 60 28 240 38
Rectangle -16777216 true false 83 95 91 113
Rectangle -16777216 true false 128 95 136 113
Rectangle -16777216 true false 173 95 181 113
Rectangle -16777216 true false 218 95 226 113
Rectangle -16777216 true false 218 50 226 68
Rectangle -16777216 true false 173 50 181 68
Rectangle -16777216 true false 128 50 136 68
Rectangle -16777216 true false 83 50 91 68
Rectangle -16777216 true false 65 72 73 90
Rectangle -16777216 true false 107 71 115 89
Rectangle -16777216 true false 154 113 162 131
Rectangle -16777216 true false 197 71 205 89
Rectangle -16777216 true false 197 35 205 53
Rectangle -16777216 true false 152 35 160 53
Rectangle -16777216 true false 107 35 115 53
Rectangle -16777216 true false 65 35 73 53
Rectangle -7500403 true true 0 112 17 143
Rectangle -7500403 true true 42 112 73 143
Rectangle -7500403 true true 110 110 142 142
Rectangle -7500403 true true 180 111 212 143
Rectangle -7500403 true true 239 111 271 143
Rectangle -7500403 true true 287 113 300 142
Line -1 false 0 111 16 111
Line -1 false 17 111 17 142
Line -1 false 42 112 42 142
Line -1 false 72 112 72 142
Line -1 false 109 111 109 141
Line -1 false 141 110 141 141
Line -1 false 180 112 180 141
Line -1 false 212 111 212 142
Line -1 false 239 113 239 142
Line -1 false 270 112 270 142
Line -1 false 287 111 287 142
Line -1 false 44 112 70 112
Line -1 false 109 110 139 110
Line -1 false 181 111 212 111
Line -1 false 240 111 269 111
Line -1 false 287 112 301 112
Line -1 false 18 142 42 142
Line -1 false 72 142 109 142
Line -1 false 141 142 181 142
Line -1 false 213 142 239 142
Line -1 false 269 142 287 142
Rectangle -16777216 true false 154 73 162 91
Rectangle -7500403 true true 60 6 76 28
Rectangle -7500403 true true 104 5 128 28
Rectangle -7500403 true true 165 6 188 28
Rectangle -7500403 true true 222 5 239 28
Line -1 false 222 5 222 27
Line -1 false 61 6 75 6
Line -1 false 75 6 75 27
Line -1 false 76 27 104 27
Line -1 false 104 5 104 27
Line -1 false 104 5 128 5
Line -1 false 128 5 128 27
Line -1 false 129 27 164 27
Line -1 false 164 6 164 26
Line -1 false 164 6 187 6
Line -1 false 187 6 187 27
Line -1 false 188 27 221 27
Line -1 false 238 5 223 5
Rectangle -16777216 true false 90 45 123 105
Rectangle -16777216 true false 169 45 202 105
Circle -16777216 true false 104 172 81
Rectangle -16777216 true false 105 211 185 293

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

closed piranha blue
false
7
Polygon -14835848 true true 165 210 195 210 225 165 225 120 195 45 180 30 165 15 135 15 120 30 105 45 75 120 75 165 105 210
Rectangle -955883 true false 135 210 165 300
Rectangle -14835848 true true 195 255 210 270
Rectangle -14835848 true true 225 225 240 240
Rectangle -14835848 true true 240 210 255 225
Rectangle -6459832 true false 195 225 225 240
Rectangle -955883 true false 195 225 210 255
Rectangle -955883 true false 180 240 210 255
Rectangle -955883 true false 180 240 195 270
Rectangle -6459832 true false 165 270 180 285
Rectangle -955883 true false 150 270 180 300
Rectangle -6459832 true false 240 225 270 240
Rectangle -955883 true false 240 225 255 255
Rectangle -955883 true false 225 240 255 255
Rectangle -955883 true false 165 285 195 300
Rectangle -14835848 true true 210 240 225 255
Rectangle -14835848 true true 180 270 195 285
Rectangle -955883 true false 210 210 225 240
Rectangle -6459832 true false 225 210 240 225
Rectangle -955883 true false 225 195 240 225
Rectangle -955883 true false 225 195 255 210
Rectangle -955883 true false 255 195 270 240
Rectangle -955883 true false 225 240 240 270
Rectangle -955883 true false 210 255 240 270
Rectangle -955883 true false 210 255 225 285
Rectangle -955883 true false 195 270 225 285
Rectangle -955883 true false 195 270 210 300
Rectangle -955883 true false 120 270 150 300
Rectangle -955883 true false 90 285 135 300
Rectangle -14835848 true true 105 270 120 285
Rectangle -14835848 true true 90 255 105 270
Rectangle -14835848 true true 75 240 90 255
Rectangle -14835848 true true 60 225 75 240
Rectangle -14835848 true true 45 210 60 225
Rectangle -6459832 true false 75 270 105 285
Rectangle -6459832 true false 45 225 60 255
Rectangle -6459832 true false 60 240 75 270
Rectangle -6459832 true false 75 255 90 285
Rectangle -955883 true false 30 195 45 240
Rectangle -955883 true false 90 270 105 300
Rectangle -955883 true false 30 225 60 240
Rectangle -955883 true false 60 255 90 270
Rectangle -955883 true false 45 240 75 255
Rectangle -955883 true false 75 270 105 285
Rectangle -955883 true false 30 195 75 210
Rectangle -955883 true false 60 195 75 225
Rectangle -955883 true false 60 210 90 225
Rectangle -955883 true false 75 210 90 240
Rectangle -955883 true false 75 225 105 240
Rectangle -955883 true false 90 225 105 255
Rectangle -955883 true false 90 240 120 255
Rectangle -955883 true false 105 240 120 270
Rectangle -955883 true false 195 225 225 240
Rectangle -14835848 true true 135 15 165 30
Rectangle -16777216 true false 135 15 165 210
Polygon -16777216 true false 135 210 120 210
Rectangle -2674135 true false 195 60 210 75
Rectangle -2674135 true false 165 30 180 45
Rectangle -2674135 true false 120 30 135 45
Rectangle -2674135 true false 210 105 225 120
Rectangle -2674135 true false 195 135 210 150
Rectangle -2674135 true false 165 75 180 90
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 165 135 180 150
Rectangle -2674135 true false 210 165 225 180
Rectangle -2674135 true false 165 165 180 180
Rectangle -2674135 true false 180 195 195 210
Rectangle -2674135 true false 96 57 111 72
Rectangle -2674135 true false 120 75 135 90
Rectangle -2674135 true false 78 93 93 108
Rectangle -2674135 true false 105 105 120 120
Rectangle -2674135 true false 75 135 90 150
Rectangle -2674135 true false 120 135 135 150
Rectangle -2674135 true false 120 180 135 195
Rectangle -2674135 true false 90 165 105 180
Rectangle -2674135 true false 96 195 111 210

coin
false
2
Rectangle -955883 true true 90 45 195 240
Rectangle -1184463 true false 105 75 195 225
Rectangle -1184463 true false 120 60 180 75
Rectangle -955883 true true 150 75 165 210
Rectangle -1 true false 120 75 135 210
Rectangle -1 true false 135 60 165 75
Rectangle -16777216 true false 165 75 180 210
Rectangle -16777216 true false 135 210 165 225
Rectangle -955883 true true 135 180 165 210
Rectangle -955883 true true 105 60 120 75
Rectangle -1 true false 135 30 165 45
Rectangle -1 true false 105 45 120 60
Rectangle -1 true false 90 60 105 75
Rectangle -16777216 true false 135 15 180 30
Rectangle -16777216 true false 165 30 210 45
Rectangle -16777216 true false 210 45 225 75
Rectangle -16777216 true false 225 75 240 210
Rectangle -6459832 true false 195 45 210 75
Rectangle -6459832 true false 210 75 225 210
Rectangle -955883 true true 180 210 195 225
Rectangle -955883 true true 195 75 210 210
Rectangle -6459832 true false 180 225 210 240
Rectangle -6459832 true false 195 210 210 240
Rectangle -16777216 true false 210 210 225 240
Rectangle -16777216 true false 180 240 210 255
Rectangle -6459832 true false 120 240 180 255
Rectangle -16777216 true false 120 255 180 270
Rectangle -16777216 true false 90 240 120 255
Rectangle -16777216 true false 75 195 90 240
Rectangle -1 true false 75 90 90 195
Rectangle -16777216 true false 105 30 135 45
Rectangle -16777216 true false 90 45 105 60
Rectangle -16777216 true false 75 60 90 90
Rectangle -16777216 true false 60 90 75 195

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

empty-block
false
0
Rectangle -7500403 true true 0 15 300 300
Rectangle -16777216 true false 15 225 285 240
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 15 150 285 165
Rectangle -16777216 true false 15 75 285 90
Rectangle -1 true false 15 0 285 15
Rectangle -16777216 true false 0 15 15 285
Rectangle -16777216 true false 135 15 150 75
Rectangle -16777216 true false 75 90 90 150
Rectangle -16777216 true false 195 90 210 150
Rectangle -16777216 true false 270 15 285 75
Rectangle -16777216 true false 270 165 285 225
Rectangle -16777216 true false 75 240 90 285
Rectangle -16777216 true false 195 240 210 285
Rectangle -16777216 true false 135 165 150 225

empty-block-blue
false
8
Rectangle -16777216 true false 2 -2 302 298
Rectangle -1 true false 15 -15 285 0
Rectangle -11221820 true true -2 85 65 127
Rectangle -11221820 true true 95 84 212 128
Rectangle -11221820 true true 247 84 300 128
Rectangle -11221820 true true 16 15 135 53
Rectangle -11221820 true true 164 14 284 53
Rectangle -11221820 true true -1 240 67 281
Rectangle -11221820 true true 96 239 212 282
Rectangle -11221820 true true 244 240 301 283
Rectangle -16777216 true false -15 -30 300 0
Rectangle -11221820 true true 164 164 287 203
Rectangle -11221820 true true 18 164 137 202

empty-block-underground
false
8
Rectangle -1 true false 15 -15 285 0
Rectangle -11221820 true true 0 90 135 150
Rectangle -11221820 true true 150 90 285 150
Rectangle -11221820 true true 0 165 75 225
Rectangle -11221820 true true 210 165 300 225
Rectangle -11221820 true true 90 165 195 225
Rectangle -11221820 true true 0 240 135 315
Rectangle -11221820 true true 150 240 285 300
Rectangle -11221820 true true 0 15 75 75
Rectangle -11221820 true true 90 15 195 75
Rectangle -11221820 true true 210 15 300 75

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire flower
false
0
Rectangle -14835848 true false 135 180 165 255
Rectangle -14835848 true false 195 210 240 255
Rectangle -14835848 true false 225 195 255 240
Rectangle -14835848 true false 90 225 210 270
Rectangle -14835848 true false 60 210 105 255
Rectangle -14835848 true false 45 195 75 240
Rectangle -16777216 true false 120 165 135 255
Rectangle -16777216 true false 165 165 180 255
Rectangle -16777216 true false 90 270 210 285
Rectangle -16777216 true false 210 255 240 270
Rectangle -16777216 true false 60 255 90 270
Rectangle -16777216 true false 240 240 255 255
Rectangle -16777216 true false 45 240 60 255
Rectangle -16777216 true false 255 195 270 240
Rectangle -16777216 true false 225 180 255 195
Rectangle -16777216 true false 195 195 225 210
Rectangle -16777216 true false 165 210 195 225
Rectangle -16777216 true false 105 210 135 225
Rectangle -16777216 true false 30 195 45 240
Rectangle -16777216 true false 45 180 75 195
Rectangle -16777216 true false 75 195 105 210
Rectangle -16777216 true false 75 165 225 180
Rectangle -16777216 true false 210 150 255 165
Rectangle -16777216 true false 45 150 90 165
Rectangle -16777216 true false 240 135 270 150
Rectangle -16777216 true false 30 135 60 150
Rectangle -16777216 true false 255 75 270 135
Rectangle -16777216 true false 30 75 45 135
Rectangle -16777216 true false 30 60 60 75
Rectangle -16777216 true false 240 60 270 75
Rectangle -16777216 true false 45 45 90 60
Rectangle -16777216 true false 210 45 255 60
Rectangle -16777216 true false 75 30 225 45
Polygon -2674135 true false 90 45 210 45 210 60 240 60 240 75 255 75 255 135 240 135 240 150 210 150 210 165 90 165 90 150 60 150 60 135 45 135 45 75 60 75 60 60 90 60 90 45
Polygon -1184463 true false 105 60 195 60 195 75 225 75 225 135 195 135 195 150 105 150 105 135 75 135 75 120 75 75 105 75
Rectangle -16777216 true false 105 90 195 120

fire mario
false
8
Rectangle -2674135 true false 210 150 240 195
Rectangle -2674135 true false 195 135 225 210
Rectangle -2674135 true false 120 135 195 180
Rectangle -1 true false 90 30 195 60
Rectangle -1 true false 90 45 255 60
Rectangle -2674135 true false 90 60 150 75
Rectangle -2674135 true false 105 60 135 105
Rectangle -2674135 true false 135 90 150 105
Rectangle -2674135 true false 75 75 90 120
Rectangle -2674135 true false 75 105 105 120
Rectangle -11221820 true true 90 75 105 105
Rectangle -11221820 true true 150 60 180 120
Rectangle -11221820 true true 135 75 165 90
Rectangle -11221820 true true 165 105 210 120
Rectangle -11221820 true true 180 60 225 90
Rectangle -11221820 true true 195 90 240 105
Rectangle -11221820 true true 210 75 240 105
Rectangle -11221820 true true 105 90 195 120
Rectangle -11221820 true true 105 120 210 135
Rectangle -2674135 true false 90 135 135 165
Rectangle -2674135 true false 75 150 135 180
Rectangle -2674135 true false 60 165 135 180
Rectangle -11221820 true true 60 180 90 225
Rectangle -11221820 true true 75 195 105 210
Rectangle -2674135 true false 90 165 105 195
Rectangle -1 true false 120 135 135 180
Rectangle -2674135 true false 90 259 135 289
Rectangle -2674135 true false 75 279 135 301
Rectangle -1 true false 180 135 195 180
Rectangle -1 true false 105 180 210 225
Rectangle -1 true false 120 195 195 240
Rectangle -2674135 true false 180 258 218 290
Rectangle -2674135 true false 179 279 235 300
Rectangle -11221820 true true 225 180 255 225
Rectangle -11221820 true true 210 195 255 210
Rectangle -2674135 true false 165 60 180 90
Rectangle -11221820 true true 180 195 195 210
Rectangle -1 true false 105 15 195 45
Rectangle -11221820 true true 165 30 195 45
Rectangle -1 true false 120 0 195 30
Rectangle -11221820 true true 225 75 255 105
Rectangle -2674135 true false 165 75 195 90
Rectangle -11221820 true true 180 15 195 45
Rectangle -2674135 true false 210 90 225 120
Rectangle -2674135 true false 195 105 240 120
Rectangle -11221820 true true 120 195 135 210
Rectangle -1 true false 180 210 225 270
Rectangle -1 true false 90 210 135 270
Rectangle -2674135 true false 225 165 255 180

fireball
true
1
Rectangle -955883 true false 150 60 240 180
Rectangle -955883 true false 75 150 240 240
Rectangle -1184463 true false 150 180 180 210
Rectangle -1184463 true false 180 150 210 180
Rectangle -2674135 true true 90 240 210 270
Rectangle -2674135 true true 180 210 240 240
Rectangle -955883 true false 210 180 270 210
Rectangle -2674135 true true 240 90 270 210
Rectangle -2674135 true true 210 90 270 120
Rectangle -2674135 true true 210 60 240 120
Rectangle -2674135 true true 150 60 240 90
Rectangle -2674135 true true 150 60 180 150
Rectangle -2674135 true true 90 120 180 150
Rectangle -2674135 true true 90 120 120 180
Rectangle -2674135 true true 60 150 120 180
Rectangle -2674135 true true 60 150 90 240
Rectangle -2674135 true true 60 210 120 240
Rectangle -2674135 true true 90 210 120 270
Rectangle -2674135 true true 180 210 210 270
Rectangle -2674135 true true 210 180 240 240
Rectangle -2674135 true true 120 30 180 60
Rectangle -2674135 true true 90 60 120 90
Rectangle -2674135 true true 60 30 90 60
Rectangle -2674135 true true 30 90 60 120
Rectangle -2674135 true true 210 180 270 210

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -13840069 true false 225 0 255 300
Polygon -1 true false 0 0 -15 -15 225 -15 240 -15 240 240 -15 -15
Rectangle -1 true false 0 0 15 15
Rectangle -1 true false 15 15 30 30
Rectangle -1 true false 30 30 45 45
Rectangle -1 true false 45 45 60 60
Rectangle -1 true false 60 60 75 75
Rectangle -1 true false 120 120 135 135
Rectangle -1 true false 105 105 120 120
Rectangle -1 true false 90 90 105 105
Rectangle -1 true false 75 75 90 90
Rectangle -1 true false 135 135 150 150
Rectangle -1 true false 150 150 165 165
Rectangle -1 true false 165 165 180 180
Rectangle -1 true false 180 180 195 195
Rectangle -1 true false 195 195 210 210
Rectangle -10899396 true false 210 30 225 105
Rectangle -10899396 true false 135 15 210 30
Rectangle -10899396 true false 165 15 180 30
Rectangle -10899396 true false 120 30 135 105
Rectangle -10899396 true false 135 30 150 45
Rectangle -10899396 true false 165 15 180 75
Rectangle -10899396 true false 195 30 210 45
Rectangle -10899396 true false 180 60 195 75
Rectangle -10899396 true false 135 75 165 105
Rectangle -10899396 true false 180 75 210 105
Rectangle -10899396 true false 150 90 195 120
Rectangle -1 true false 210 210 225 225
Rectangle -1 true false 225 225 240 240
Rectangle -10899396 true false 150 60 165 75

flag-pole
false
0
Rectangle -13840069 true false 225 0 255 300

flag-top
false
0
Rectangle -10899396 true false 195 165 285 255
Rectangle -16777216 true false 195 240 210 255
Rectangle -16777216 true false 270 240 285 255
Rectangle -16777216 true false 210 255 270 270
Rectangle -16777216 true false 285 180 300 240
Rectangle -13840069 true false 210 165 225 180
Rectangle -13840069 true false 195 180 210 210
Rectangle -16777216 true false 270 165 285 180
Rectangle -16777216 true false 180 180 195 240
Rectangle -16777216 true false 195 165 210 180
Rectangle -16777216 true false 210 150 270 165
Rectangle -13840069 true false 225 270 255 300

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

goomba
false
4
Rectangle -1184463 true true 120 225 210 270
Rectangle -955883 true false 120 15 195 30
Rectangle -955883 true false 105 30 210 45
Rectangle -955883 true false 90 45 225 60
Rectangle -955883 true false 75 60 240 75
Rectangle -955883 true false 60 75 255 90
Rectangle -955883 true false 45 90 270 120
Rectangle -955883 true false 30 120 285 165
Rectangle -16777216 true false 120 105 195 120
Rectangle -955883 true false 45 165 105 180
Rectangle -955883 true false 210 165 270 180
Rectangle -16777216 true false 75 75 105 90
Rectangle -16777216 true false 210 75 240 90
Rectangle -16777216 true false 105 90 128 135
Rectangle -1184463 true true 90 90 105 135
Rectangle -1184463 true true 90 135 130 150
Rectangle -1184463 true true 128 120 143 150
Rectangle -1184463 true true 210 90 225 135
Rectangle -1184463 true true 178 120 195 150
Rectangle -1184463 true true 195 135 225 150
Rectangle -16777216 true false 193 90 210 135
Rectangle -1184463 true true 105 165 210 180
Rectangle -1184463 true true 90 180 225 225
Rectangle -16777216 true false 60 210 90 225
Rectangle -16777216 true false 45 225 120 255
Rectangle -16777216 true false 60 255 135 270
Rectangle -16777216 true false 120 240 135 255
Rectangle -16777216 true false 210 225 240 240
Rectangle -16777216 true false 195 240 240 255
Rectangle -16777216 true false 180 255 225 270

green mushroom
false
5
Rectangle -1 true false 90 210 210 270
Rectangle -1184463 true false 120 45 180 75
Rectangle -1184463 true false 105 60 180 90
Rectangle -1184463 true false 90 75 195 105
Rectangle -1184463 true false 75 90 210 120
Rectangle -1184463 true false 60 105 240 135
Rectangle -1184463 true false 45 120 255 150
Rectangle -1184463 true false 30 150 270 210
Rectangle -1184463 true false 45 195 90 225
Rectangle -10899396 true true 165 60 195 90
Rectangle -10899396 true true 150 75 210 105
Rectangle -10899396 true true 180 90 225 105
Rectangle -10899396 true true 165 90 210 120
Rectangle -10899396 true true 225 165 255 195
Rectangle -10899396 true true 210 150 240 180
Rectangle -10899396 true true 75 135 120 165
Rectangle -10899396 true true 60 150 135 180
Rectangle -10899396 true true 75 165 120 195
Rectangle -10899396 true true 60 210 105 225
Rectangle -1184463 true false 195 195 255 225
Rectangle -10899396 true true 195 210 240 225
Rectangle -1 true false 105 255 180 285
Rectangle -1184463 true false 195 240 210 270
Rectangle -1184463 true false 180 270 195 285

ground-block
false
1
Rectangle -2674135 true true 0 0 300 300
Rectangle -16777216 true false 120 210 135 240
Rectangle -16777216 true false 15 210 45 225
Rectangle -16777216 true false 45 225 75 240
Rectangle -16777216 true false 75 240 120 255
Rectangle -16777216 true false 165 120 285 135
Rectangle -16777216 true false 165 105 180 120
Rectangle -1 true false 150 15 165 120
Rectangle -1 true false 165 135 285 150
Rectangle -1 true false 150 135 165 210
Rectangle -1 true false 15 15 30 210
Rectangle -16777216 true false 0 15 15 285
Rectangle -16777216 true false 15 285 105 300
Rectangle -16777216 true false 105 255 120 300
Rectangle -16777216 true false 285 15 300 120
Rectangle -16777216 true false 285 135 300 285
Rectangle -16777216 true false 135 285 285 300
Rectangle -16777216 true false 270 270 285 285
Rectangle -1 true false 15 0 135 15
Rectangle -16777216 true false 135 0 150 210
Rectangle -1 true false 165 0 285 15
Rectangle -1 true false 120 240 135 300
Rectangle -1 true false 135 210 150 240
Rectangle -1 true false 15 225 45 240
Rectangle -1 true false 15 240 30 285
Rectangle -1 true false 45 240 75 255
Rectangle -1 true false 75 255 105 270

hit-koopa
false
0
Rectangle -13840069 true false 45 105 90 180
Rectangle -13840069 true false 210 105 255 180
Rectangle -13840069 true false 75 60 135 195
Rectangle -13840069 true false 165 60 225 195
Rectangle -13840069 true false 105 30 195 225
Rectangle -16777216 true false 105 30 195 45
Rectangle -16777216 true false 90 45 120 60
Rectangle -16777216 true false 180 45 210 60
Rectangle -16777216 true false 75 60 90 75
Rectangle -16777216 true false 210 60 225 75
Rectangle -16777216 true false 60 75 75 105
Rectangle -16777216 true false 225 75 240 105
Rectangle -16777216 true false 45 105 60 150
Rectangle -16777216 true false 45 120 75 135
Rectangle -16777216 true false 240 105 255 150
Rectangle -16777216 true false 225 120 255 135
Rectangle -16777216 true false 30 135 60 150
Rectangle -16777216 true false 240 135 270 150
Rectangle -16777216 true false 30 135 45 180
Rectangle -16777216 true false 255 135 270 180
Rectangle -16777216 true false 45 165 75 180
Rectangle -16777216 true false 225 165 270 180
Rectangle -16777216 true false 60 165 75 195
Rectangle -16777216 true false 225 165 240 195
Rectangle -16777216 true false 60 180 105 195
Rectangle -16777216 true false 195 180 240 195
Rectangle -16777216 true false 105 210 195 225
Rectangle -1 true false 30 180 60 195
Rectangle -1 true false 45 285 90 285
Rectangle -1 true false 45 180 60 210
Rectangle -1 true false 45 195 90 210
Rectangle -1 true false 120 225 180 255
Rectangle -1 true false 195 210 225 225
Rectangle -1 true false 195 195 255 210
Rectangle -1 true false 240 180 255 210
Rectangle -1 true false 240 180 270 195
Rectangle -16777216 true false 30 195 45 210
Rectangle -16777216 true false 45 210 75 225
Rectangle -16777216 true false 75 225 90 240
Rectangle -16777216 true false 90 240 120 255
Rectangle -16777216 true false 120 255 180 270
Rectangle -16777216 true false 255 195 270 210
Rectangle -16777216 true false 225 210 255 225
Rectangle -16777216 true false 195 180 210 210
Rectangle -16777216 true false 90 180 105 210
Rectangle -1 true false 75 210 105 225
Rectangle -1 true false 75 195 90 225
Rectangle -1 true false 210 195 225 225
Rectangle -1 true false 90 225 210 240
Rectangle -1 true false 90 210 105 240
Rectangle -1 true false 195 210 210 240
Rectangle -16777216 true false 180 240 210 255
Rectangle -16777216 true false 210 225 225 240
Rectangle -16777216 true false 105 165 120 180
Rectangle -16777216 true false 180 165 195 180
Rectangle -16777216 true false 120 150 180 165
Rectangle -16777216 true false 105 135 120 150
Rectangle -16777216 true false 90 120 105 135
Rectangle -16777216 true false 75 105 90 120
Rectangle -16777216 true false 90 90 105 105
Rectangle -16777216 true false 105 75 120 90
Rectangle -16777216 true false 120 60 180 75
Rectangle -16777216 true false 180 75 195 90
Rectangle -16777216 true false 195 90 210 105
Rectangle -16777216 true false 210 105 225 120
Rectangle -16777216 true false 180 135 195 150
Rectangle -16777216 true false 195 120 210 135

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

koopa
false
7
Rectangle -955883 true false 60 255 90 300
Rectangle -14835848 true true 105 225 255 270
Rectangle -955883 true false 30 45 105 120
Rectangle -955883 true false 60 30 105 105
Rectangle -955883 true false 15 75 105 135
Rectangle -1 true false 60 0 75 105
Rectangle -1 true false 45 15 75 30
Rectangle -1 true false 60 15 90 75
Rectangle -14835848 true true 45 30 60 75
Rectangle -1 true false 45 75 75 90
Rectangle -14835848 true true 30 105 45 120
Rectangle -955883 true false 15 120 60 150
Rectangle -955883 true false 15 120 45 165
Rectangle -955883 true false 30 135 45 180
Rectangle -955883 true false 90 45 120 135
Rectangle -955883 true false 75 120 105 180
Rectangle -955883 true false 60 165 90 210
Rectangle -955883 true false 45 210 75 225
Rectangle -955883 true false 60 195 75 240
Rectangle -1 true false 75 210 105 225
Rectangle -1 true false 75 210 90 255
Rectangle -1 true false 75 240 105 255
Rectangle -1 true false 90 255 120 270
Rectangle -14835848 true true 120 135 225 180
Rectangle -14835848 true true 135 120 210 150
Rectangle -14835848 true true 105 165 240 225
Rectangle -14835848 true true 90 210 255 240
Rectangle -1 true false 105 270 225 285
Rectangle -955883 true false 225 270 270 300
Rectangle -955883 true false 45 270 105 285
Rectangle -955883 true false 30 285 90 300
Rectangle -955883 true false 135 135 150 150
Rectangle -955883 true false 150 150 165 165
Rectangle -955883 true false 165 165 180 180
Rectangle -955883 true false 180 180 195 195
Rectangle -955883 true false 195 195 210 210
Rectangle -955883 true false 210 210 225 225
Rectangle -955883 true false 225 225 240 240
Rectangle -955883 true false 195 135 210 150
Rectangle -955883 true false 180 150 195 165
Rectangle -955883 true false 150 180 165 195
Rectangle -955883 true false 135 195 150 210
Rectangle -955883 true false 120 210 135 225
Rectangle -955883 true false 105 225 120 240
Rectangle -1 true false 90 165 105 210
Rectangle -955883 true false 105 195 120 210
Rectangle -955883 true false 135 225 150 240
Rectangle -955883 true false 150 240 165 255
Rectangle -955883 true false 165 255 180 270
Rectangle -955883 true false 225 195 240 210
Rectangle -955883 true false 195 225 210 240
Rectangle -955883 true false 180 240 195 255
Rectangle -1 true false 210 255 255 270
Rectangle -955883 true false 225 285 285 300
Rectangle -1 true false 90 240 105 270
Rectangle -955883 true false 45 270 75 300
Rectangle -1 true false 105 255 120 285
Rectangle -1 true false 210 255 225 285

lava-turtle
false
0
Circle -2674135 true false 15 15 270

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

mario
false
15
Rectangle -6459832 true false 120 135 180 165
Rectangle -2674135 true false 165 165 210 240
Rectangle -2674135 true false 105 30 180 60
Rectangle -2674135 true false 90 45 240 60
Rectangle -6459832 true false 90 60 150 75
Rectangle -6459832 true false 105 60 135 105
Rectangle -6459832 true false 135 90 150 105
Rectangle -6459832 true false 75 75 90 120
Rectangle -6459832 true false 75 105 105 120
Rectangle -6459832 true false 180 60 195 90
Rectangle -6459832 true false 195 90 210 120
Rectangle -6459832 true false 180 105 240 120
Rectangle -1 true true 90 75 105 105
Rectangle -1 true true 150 60 180 120
Rectangle -1 true true 135 75 165 90
Rectangle -1 true true 165 90 195 105
Rectangle -1 true true 195 60 210 90
Rectangle -1 true true 195 75 240 90
Rectangle -1 true true 210 90 255 105
Rectangle -1 true true 105 105 180 120
Rectangle -1 true true 105 120 225 135
Rectangle -6459832 true false 90 135 135 165
Rectangle -6459832 true false 75 150 135 180
Rectangle -6459832 true false 60 165 135 180
Rectangle -1 true true 60 180 90 225
Rectangle -1 true true 75 195 105 210
Rectangle -6459832 true false 90 165 105 195
Rectangle -2674135 true false 135 135 150 180
Rectangle -1 true true 135 180 150 195
Rectangle -2674135 true false 105 180 135 225
Rectangle -2674135 true false 90 210 135 240
Rectangle -6459832 true false 75 240 120 270
Rectangle -6459832 true false 60 255 120 270
Rectangle -6459832 true false 165 135 210 150
Rectangle -2674135 true false 180 150 210 180
Rectangle -2674135 true false 150 165 195 195
Rectangle -1 true true 180 180 195 195
Rectangle -2674135 true false 135 195 195 225
Rectangle -2674135 true false 195 210 225 240
Rectangle -6459832 true false 195 240 240 270
Rectangle -6459832 true false 195 255 255 270
Rectangle -6459832 true false 210 150 240 180
Rectangle -6459832 true false 210 180 255 195
Rectangle -6459832 true false 210 180 225 210
Rectangle -1 true true 225 180 255 225
Rectangle -6459832 true false 195 135 210 180
Rectangle -1 true true 210 195 255 210
Rectangle -6459832 true false 210 165 255 180

mario2
false
0
Polygon -16777216 true false 144 132 155 134 157 132 164 132 166 132 166 144 145 145 142 137 142 133 145 131
Circle -6459832 true false 157 26 12
Circle -2674135 true false 123 8 24
Circle -6459832 true false 129 13 36
Rectangle -6459832 true false 139 46 150 59
Polygon -2674135 true false 123 19 130 38 132 28 144 17 172 13 144 12 135 12 128 28
Circle -16777216 true false 150 23 7
Circle -16777216 false false 146 21 12
Polygon -1 true false 128 23 126 17 131 17 131 12 136 15 129 21
Line -16777216 false 156 40 164 42
Line -16777216 false 143 24 146 21
Line -16777216 false 146 21 155 18
Polygon -2674135 true false 136 60 156 61 160 72 160 92 135 94 133 67
Polygon -13345367 true false 156 61 162 76 161 93 133 93 133 83 157 79 153 63
Polygon -13345367 true false 134 90 160 92 153 102 153 133 139 139 133 90
Circle -16777216 true false 161 33 6
Polygon -2674135 true false 139 61 149 62 153 81 171 82 170 89 145 89 139 61
Polygon -16777216 false false 140 60 149 60 153 80 171 81 172 89 145 89 139 60
Circle -1 true false 165 78 14
Line -16777216 false 170 82 174 81
Line -16777216 false 170 85 177 85
Line -16777216 false 171 88 175 89

mushroom
false
1
Rectangle -1 true false 90 210 210 270
Rectangle -955883 true false 120 45 180 75
Rectangle -955883 true false 105 60 180 90
Rectangle -955883 true false 90 75 195 105
Rectangle -955883 true false 75 90 210 120
Rectangle -955883 true false 60 105 240 135
Rectangle -955883 true false 45 120 255 150
Rectangle -955883 true false 30 150 270 210
Rectangle -955883 true false 45 195 90 225
Rectangle -2674135 true true 165 60 195 90
Rectangle -2674135 true true 150 75 210 105
Rectangle -2674135 true true 180 90 225 105
Rectangle -2674135 true true 165 90 210 120
Rectangle -2674135 true true 210 150 240 180
Rectangle -2674135 true true 75 135 120 165
Rectangle -2674135 true true 60 150 135 180
Rectangle -2674135 true true 75 165 120 195
Rectangle -2674135 true true 60 210 105 225
Rectangle -955883 true false 195 195 255 225
Rectangle -2674135 true true 195 210 240 225
Rectangle -1 true false 105 255 195 285
Rectangle -955883 true false 195 240 210 270
Rectangle -955883 true false 180 270 195 285
Rectangle -2674135 true true 225 165 255 195

open piranha blue
false
5
Rectangle -10899396 true true 201 4 218 20
Rectangle -10899396 true true 196 15 217 33
Rectangle -10899396 true true 81 4 97 21
Rectangle -10899396 true true 84 15 107 41
Rectangle -10899396 true true 104 39 112 62
Rectangle -10899396 true true 187 37 195 60
Rectangle -10899396 true true 120 165 180 210
Rectangle -10899396 true true 90 150 135 195
Rectangle -10899396 true true 75 150 135 180
Rectangle -10899396 true true 60 150 135 165
Rectangle -10899396 true true 165 150 240 165
Rectangle -10899396 true true 165 150 210 195
Rectangle -10899396 true true 165 150 225 180
Rectangle -10899396 true true 45 120 135 150
Rectangle -10899396 true true 165 105 255 150
Rectangle -10899396 true true 45 60 120 120
Rectangle -10899396 true true 180 60 255 120
Rectangle -10899396 true true 60 45 105 60
Rectangle -10899396 true true 195 45 240 60
Rectangle -10899396 true true 75 30 105 60
Rectangle -10899396 true true 195 30 225 60
Rectangle -955883 true false 135 210 165 300
Rectangle -10899396 true true 195 255 210 270
Rectangle -10899396 true true 225 225 240 240
Rectangle -10899396 true true 240 210 255 225
Rectangle -6459832 true false 195 225 225 240
Rectangle -955883 true false 195 225 210 255
Rectangle -955883 true false 180 240 210 255
Rectangle -955883 true false 180 240 195 270
Rectangle -6459832 true false 165 270 180 285
Rectangle -955883 true false 150 270 180 300
Rectangle -6459832 true false 240 225 270 240
Rectangle -955883 true false 240 225 255 255
Rectangle -955883 true false 225 240 255 255
Rectangle -955883 true false 165 285 195 300
Rectangle -10899396 true true 210 240 225 255
Rectangle -10899396 true true 180 270 195 285
Rectangle -955883 true false 210 210 225 240
Rectangle -6459832 true false 225 210 240 225
Rectangle -955883 true false 225 195 240 225
Rectangle -955883 true false 225 195 255 210
Rectangle -955883 true false 255 195 270 240
Rectangle -955883 true false 225 240 240 270
Rectangle -955883 true false 210 255 240 270
Rectangle -955883 true false 210 255 225 285
Rectangle -955883 true false 195 270 225 285
Rectangle -955883 true false 195 270 210 300
Rectangle -955883 true false 120 270 150 300
Rectangle -955883 true false 90 285 135 300
Rectangle -10899396 true true 105 270 120 285
Rectangle -10899396 true true 90 255 105 270
Rectangle -10899396 true true 75 240 90 255
Rectangle -10899396 true true 60 225 75 240
Rectangle -10899396 true true 45 210 60 225
Rectangle -6459832 true false 75 270 105 285
Rectangle -6459832 true false 45 225 60 255
Rectangle -6459832 true false 60 240 75 270
Rectangle -6459832 true false 75 255 90 285
Rectangle -955883 true false 30 195 45 240
Rectangle -955883 true false 90 270 105 300
Rectangle -955883 true false 30 225 60 240
Rectangle -955883 true false 60 255 90 270
Rectangle -955883 true false 45 240 75 255
Rectangle -955883 true false 75 270 105 285
Rectangle -955883 true false 30 195 75 210
Rectangle -955883 true false 60 195 75 225
Rectangle -955883 true false 60 210 90 225
Rectangle -955883 true false 75 210 90 240
Rectangle -955883 true false 75 225 105 240
Rectangle -955883 true false 90 225 105 255
Rectangle -955883 true false 90 240 120 255
Rectangle -955883 true false 105 240 120 270
Rectangle -10899396 true true 45 105 135 135
Rectangle -10899396 true true 75 15 90 45
Rectangle -10899396 true true 210 15 225 45
Rectangle -1 true false 120 105 135 120
Rectangle -1 true false 165 105 180 120
Polygon -1 true false 111 60 132 37 103 34 111 60
Polygon -1 true false 187 61 165 38 194 36 187 61
Rectangle -2674135 true false 225 30 240 45
Rectangle -2674135 true false 240 60 255 75
Rectangle -2674135 true false 195 45 210 60
Rectangle -2674135 true false 195 15 210 30
Polygon -1 true false 194 38 205 14 174 13 194 38
Rectangle -2674135 true false 180 75 195 90
Polygon -1 true false 180 84 159 61 187 58 180 84
Polygon -1 true false 180 105 157 81 181 84 180 105
Rectangle -2674135 true false 240 105 255 120
Rectangle -2674135 true false 210 75 225 90
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 240 135 255 150
Rectangle -2674135 true false 210 120 225 135
Rectangle -2674135 true false 210 150 225 165
Rectangle -2674135 true false 165 135 180 150
Rectangle -2674135 true false 195 180 210 195
Rectangle -2674135 true false 165 165 180 180
Rectangle -2674135 true false 90 15 105 30
Polygon -1 true false 105 37 92 14 125 12 105 37
Rectangle -2674135 true false 90 45 105 60
Rectangle -2674135 true false 60 30 75 45
Rectangle -2674135 true false 45 60 60 75
Rectangle -2674135 true false 75 75 90 90
Rectangle -2674135 true false 105 75 120 90
Polygon -1 true false 120 84 140 59 110 59 120 84
Polygon -1 true false 120 105 143 81 120 84 120 105
Rectangle -2674135 true false 105 105 120 120
Rectangle -2674135 true false 120 135 135 150
Rectangle -2674135 true false 120 165 135 180
Rectangle -2674135 true false 90 180 105 195
Rectangle -2674135 true false 75 150 90 165
Rectangle -2674135 true false 45 135 60 150
Rectangle -2674135 true false 75 120 90 135
Rectangle -2674135 true false 45 105 60 120
Rectangle -2674135 true false 150 195 165 210
Rectangle -955883 true false 195 225 225 240

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

pipe top bottom
false
15
Rectangle -13840069 true false 0 165 300 300
Rectangle -10899396 true false 0 0 15 300
Rectangle -10899396 true false 0 285 300 300
Rectangle -10899396 true false 285 0 315 300
Rectangle -10899396 true false 15 225 30 240
Rectangle -10899396 true false 15 180 30 210
Rectangle -10899396 true false 105 225 120 240
Rectangle -10899396 true false 90 210 105 225
Rectangle -10899396 true false 60 210 75 225
Rectangle -10899396 true false 75 225 90 240
Rectangle -10899396 true false 30 210 45 225
Rectangle -10899396 true false 45 225 60 240
Rectangle -10899396 true false 270 210 285 225
Rectangle -10899396 true false 255 225 270 240
Rectangle -10899396 true false 240 210 255 225
Rectangle -10899396 true false 225 225 240 240
Rectangle -10899396 true false 210 210 225 225
Rectangle -10899396 true false 195 225 210 240
Rectangle -10899396 true false 180 210 195 225
Rectangle -10899396 true false 165 225 180 240
Rectangle -10899396 true false 150 210 165 225
Rectangle -10899396 true false 135 225 150 240
Rectangle -10899396 true false 120 210 135 225
Rectangle -10899396 true false 225 180 240 210
Rectangle -10899396 true false 195 180 210 210
Rectangle -10899396 true false 165 180 180 210
Rectangle -10899396 true false 135 165 150 210
Rectangle -10899396 true false 105 180 120 210
Rectangle -10899396 true false 75 180 90 210
Rectangle -10899396 true false 45 180 60 210
Rectangle -10899396 true false 255 180 270 210
Rectangle -10899396 true false 0 0 300 195

pipe top top
false
15
Rectangle -13840069 true false 0 0 300 300
Rectangle -10899396 true false 0 0 15 300
Rectangle -10899396 true false 0 0 300 15
Rectangle -10899396 true false 285 0 300 300
Rectangle -10899396 true false 15 75 300 105
Rectangle -10899396 true false 15 195 285 210

pipe-body-left
false
0
Rectangle -13840069 true false 30 0 300 300
Rectangle -16777216 true false 30 0 45 300
Rectangle -10899396 true false 75 0 105 300
Rectangle -10899396 true false 255 0 270 300

pipe-body-right
false
0
Rectangle -13840069 true false -3 -5 267 370
Rectangle -16777216 true false 255 0 270 300
Rectangle -10899396 true false 0 0 150 300
Circle -10899396 true false 158 10 17
Circle -10899396 true false 158 88 17
Circle -10899396 true false 157 64 17
Circle -10899396 true false 156 38 17
Circle -10899396 true false 157 263 17
Circle -10899396 true false 186 273 17
Circle -10899396 true false 158 234 17
Circle -10899396 true false 157 212 17
Circle -10899396 true false 154 190 17
Circle -10899396 true false 157 162 17
Circle -10899396 true false 156 137 17
Circle -10899396 true false 158 116 17
Circle -10899396 true false 208 216 17
Circle -10899396 true false 210 185 17
Circle -10899396 true false 209 140 17
Circle -10899396 true false 206 110 17
Circle -10899396 true false 181 63 17
Circle -10899396 true false 188 88 17
Circle -10899396 true false 182 126 17
Circle -10899396 true false 191 166 17
Circle -10899396 true false 181 200 17
Circle -10899396 true false 183 232 17
Circle -10899396 true false 184 36 17
Circle -10899396 true false 213 34 17
Circle -10899396 true false 196 10 17
Circle -10899396 true false 209 268 17
Circle -10899396 true false 205 247 17

pipe-top-left
false
0
Rectangle -13840069 true false 0 0 300 300
Polygon -16777216 true false -15 0 -15 315 315 315 315 285 15 285 15 15 315 15 315 -15 -15 -15
Polygon -10899396 true false 15 45 90 45 90 285 75 285 60 285 60 75 15 75 15 45
Polygon -10899396 true false 255 285 240 285 240 45 300 45 300 60 255 60 255 285 240 285

pipe-top-right
false
0
Rectangle -13840069 true false 0 0 300 300
Polygon -16777216 true false 15 -15 315 -15 315 315 -15 315 -15 285 285 285 285 15 -15 15 -15 -15
Polygon -10899396 true false 15 285 15 60 0 60 0 45 285 45 285 60 195 60 195 285 15 285
Circle -10899396 true false 203 71 19
Circle -10899396 true false 206 140 19
Circle -10899396 true false 244 126 19
Circle -10899396 true false 247 74 19
Circle -10899396 true false 213 98 19
Circle -10899396 true false 222 212 19
Circle -10899396 true false 199 189 19
Circle -10899396 true false 224 168 19
Circle -10899396 true false 244 153 19
Circle -10899396 true false 214 242 19
Circle -10899396 true false 250 230 19
Circle -10899396 true false 246 185 19

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

platform
false
0
Rectangle -1 true false 0 30 300 60
Rectangle -2674135 true false 0 60 300 90
Rectangle -955883 true false 0 150 300 225
Rectangle -2674135 true false 0 210 300 240
Rectangle -2674135 true false 45 150 105 180
Rectangle -955883 true false 0 90 45 120
Rectangle -955883 true false 0 105 15 165
Rectangle -955883 true false 105 90 195 120
Rectangle -955883 true false 135 105 165 165
Rectangle -955883 true false 255 90 300 120
Rectangle -955883 true false 285 105 300 165
Rectangle -2674135 true false 105 120 135 150
Rectangle -2674135 true false 255 120 285 150
Rectangle -2674135 true false 195 150 255 180

princess peach
false
11
Rectangle -1184463 true false 45 39 92 70
Rectangle -1184463 true false 150 0 165 30
Rectangle -1184463 true false 120 0 135 30
Rectangle -1184463 true false 90 0 105 30
Rectangle -1184463 true false 60 30 180 75
Rectangle -1184463 true false 90 45 195 225
Rectangle -2064490 true false 90 135 135 195
Rectangle -1 true false 75 180 120 210
Rectangle -2064490 true false 45 255 225 300
Rectangle -5825686 true false 45 270 60 300
Rectangle -5825686 true false 45 285 225 300
Rectangle -5825686 true false 90 270 105 300
Rectangle -5825686 true false 150 270 165 300
Rectangle -5825686 true false 210 270 225 300
Rectangle -2064490 true false 45 240 210 270
Rectangle -2064490 true false 75 240 210 270
Rectangle -2064490 true false 60 225 195 270
Rectangle -2064490 true false 75 210 180 225
Rectangle -5825686 true false 105 210 165 225
Rectangle -5825686 true false 120 195 150 225
Rectangle -7500403 true false 75 195 90 210
Rectangle -7500403 true false 105 195 120 210
Rectangle -7500403 true false 75 165 90 180
Rectangle -8630108 true true 105 165 120 180
Rectangle -2064490 true false 120 150 150 165
Rectangle -13791810 true false 75 150 90 165
Rectangle -13791810 true false 105 120 120 135
Rectangle -8630108 true true 90 105 135 120
Rectangle -8630108 true true 120 90 135 120
Rectangle -8630108 true true 90 60 105 120
Rectangle -8630108 true true 60 75 105 120
Rectangle -8630108 true true 75 105 105 135
Rectangle -13345367 true false 75 75 90 105
Rectangle -1184463 true false 180 135 210 210
Rectangle -1184463 true false 180 105 210 120
Rectangle -1184463 true false 90 15 165 45
Rectangle -2064490 true false 150 15 165 30
Rectangle -13791810 true false 120 15 135 30
Rectangle -2064490 true false 90 15 105 30
Line -16777216 false 165 30 90 30
Line -16777216 false 90 0 90 30
Line -16777216 false 165 0 165 30
Line -16777216 false 105 0 105 15
Line -16777216 false 120 0 120 15
Line -16777216 false 120 15 105 15
Line -16777216 false 135 0 135 15
Line -16777216 false 135 15 150 15
Line -16777216 false 150 0 150 15

question-block
false
0
Rectangle -7500403 true true 0 15 300 300
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 285 15 300 285
Rectangle -16777216 true false 30 30 45 45
Rectangle -16777216 true false 30 255 45 270
Rectangle -16777216 true false 255 30 270 45
Rectangle -16777216 true false 255 255 270 270
Rectangle -6459832 true false 0 15 15 285
Rectangle -6459832 true false 15 0 285 15
Rectangle -6459832 true false 75 75 105 135
Rectangle -6459832 true false 105 60 180 75
Rectangle -6459832 true false 165 75 195 135
Rectangle -6459832 true false 135 135 180 150
Rectangle -6459832 true false 120 150 150 195
Rectangle -6459832 true false 120 210 150 240
Rectangle -16777216 true false 90 135 120 150
Rectangle -16777216 true false 105 75 120 135
Rectangle -16777216 true false 120 75 165 90
Rectangle -16777216 true false 195 90 210 135
Rectangle -16777216 true false 150 150 195 165
Rectangle -16777216 true false 180 135 210 150
Rectangle -16777216 true false 150 165 165 195
Rectangle -16777216 true false 135 195 165 210
Rectangle -16777216 true false 135 240 165 255
Rectangle -16777216 true false 150 225 165 240

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

squished goomba
false
0
Rectangle -2674135 true false 120 90 180 120
Rectangle -2674135 true false 90 105 210 135
Rectangle -2674135 true false 60 120 240 150
Rectangle -2674135 true false 45 135 255 165
Rectangle -16777216 true false 90 120 120 135
Rectangle -16777216 true false 180 120 210 135
Rectangle -16777216 true false 120 135 180 150
Rectangle -7500403 true true 75 135 120 150
Rectangle -7500403 true true 180 135 225 150
Rectangle -7500403 true true 90 165 210 195
Rectangle -16777216 true false 75 180 105 210
Rectangle -16777216 true false 60 195 128 210
Rectangle -16777216 true false 195 180 225 210
Rectangle -16777216 true false 173 195 240 210

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108
Line -7500403 true 135 90 135 135
Rectangle -16777216 true false 134 98 141 141
Rectangle -16777216 true false 161 98 168 141

supermario
false
8
Rectangle -6459832 true false 210 150 240 195
Rectangle -6459832 true false 195 135 225 210
Rectangle -6459832 true false 120 135 195 180
Rectangle -2674135 true false 90 30 195 60
Rectangle -2674135 true false 91 45 256 60
Rectangle -6459832 true false 90 60 150 75
Rectangle -6459832 true false 105 60 135 105
Rectangle -2674135 true false 135 90 150 105
Rectangle -6459832 true false 75 75 90 120
Rectangle -6459832 true false 75 106 105 121
Rectangle -11221820 true true 90 75 105 105
Rectangle -11221820 true true 150 60 180 120
Rectangle -11221820 true true 135 75 165 90
Rectangle -11221820 true true 165 105 210 120
Rectangle -11221820 true true 180 60 225 90
Rectangle -11221820 true true 195 90 240 105
Rectangle -11221820 true true 210 75 240 105
Rectangle -11221820 true true 105 90 195 120
Rectangle -11221820 true true 105 120 210 135
Rectangle -6459832 true false 90 135 135 165
Rectangle -6459832 true false 75 150 135 180
Rectangle -6459832 true false 60 165 135 180
Rectangle -11221820 true true 60 180 90 225
Rectangle -11221820 true true 75 195 105 210
Rectangle -6459832 true false 90 165 105 195
Rectangle -2674135 true false 120 135 135 180
Rectangle -6459832 true false 91 259 135 289
Rectangle -6459832 true false 75 279 135 301
Rectangle -2674135 true false 180 135 195 180
Rectangle -2674135 true false 105 180 210 225
Rectangle -2674135 true false 120 195 195 240
Rectangle -6459832 true false 180 258 218 290
Rectangle -6459832 true false 180 279 236 300
Rectangle -11221820 true true 225 180 255 225
Rectangle -11221820 true true 210 195 255 210
Rectangle -6459832 true false 165 60 180 90
Rectangle -11221820 true true 180 195 195 210
Rectangle -2674135 true false 105 15 195 45
Rectangle -11221820 true true 165 30 195 45
Rectangle -2674135 true false 120 0 195 30
Rectangle -11221820 true true 225 75 255 105
Rectangle -6459832 true false 165 75 195 90
Rectangle -11221820 true true 180 15 195 45
Rectangle -6459832 true false 210 90 225 120
Rectangle -6459832 true false 195 105 240 120
Rectangle -11221820 true true 120 195 135 210
Rectangle -2674135 true false 180 210 225 270
Rectangle -2674135 true false 86 210 135 270
Rectangle -6459832 true false 225 165 255 180

supermario2
false
8
Rectangle -2674135 true false 195 150 210 195
Rectangle -2674135 true false 120 150 180 180
Rectangle -1 true false 180 180 225 255
Rectangle -1 true false 90 45 195 75
Rectangle -1 true false 90 60 255 75
Rectangle -2674135 true false 90 75 150 90
Rectangle -2674135 true false 105 75 135 120
Rectangle -2674135 true false 135 105 150 120
Rectangle -2674135 true false 75 90 90 135
Rectangle -2674135 true false 75 120 105 135
Rectangle -2674135 true false 195 120 240 135
Rectangle -11221820 true true 90 90 105 120
Rectangle -11221820 true true 150 75 180 135
Rectangle -11221820 true true 135 90 165 105
Rectangle -11221820 true true 165 105 210 120
Rectangle -11221820 true true 180 75 210 105
Rectangle -11221820 true true 195 90 240 105
Rectangle -11221820 true true 210 90 240 120
Rectangle -11221820 true true 105 120 195 150
Rectangle -11221820 true true 105 135 225 150
Rectangle -2674135 true false 90 150 135 180
Rectangle -2674135 true false 75 165 135 195
Rectangle -2674135 true false 60 180 135 195
Rectangle -11221820 true true 60 195 90 240
Rectangle -11221820 true true 75 210 105 225
Rectangle -2674135 true false 90 180 105 210
Rectangle -1 true false 120 150 135 195
Rectangle -1 true false 105 180 135 240
Rectangle -1 true false 90 225 135 255
Rectangle -2674135 true false 90 255 135 285
Rectangle -2674135 true false 75 270 135 292
Rectangle -2674135 true false 150 150 210 165
Rectangle -1 true false 180 150 195 180
Rectangle -1 true false 120 180 195 210
Rectangle -1 true false 120 195 195 240
Rectangle -1 true false 195 225 225 255
Rectangle -2674135 true false 180 255 225 285
Rectangle -2674135 true false 180 270 236 291
Rectangle -2674135 true false 210 165 240 195
Rectangle -6459832 true false 210 180 255 195
Rectangle -2674135 true false 210 180 225 210
Rectangle -11221820 true true 225 195 255 240
Rectangle -11221820 true true 210 210 255 225
Rectangle -2674135 true false 210 180 255 195
Rectangle -2674135 true false 165 75 180 105
Rectangle -11221820 true true 180 180 195 195
Rectangle -11221820 true true 120 180 135 195
Rectangle -1 true false 105 30 195 60
Rectangle -11221820 true true 165 45 195 60
Rectangle -1 true false 120 15 195 45
Rectangle -11221820 true true 225 105 255 120
Rectangle -2674135 true false 165 90 195 105
Rectangle -11221820 true true 180 30 195 45
Rectangle -2674135 true false 210 105 225 135

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

used-block
false
0
Rectangle -7500403 true true 0 15 300 300
Rectangle -6459832 true false 15 0 285 15
Rectangle -16777216 true false 285 15 300 300
Rectangle -16777216 true false 0 285 285 300
Rectangle -16777216 true false 30 30 45 45
Rectangle -16777216 true false 255 30 270 45
Rectangle -16777216 true false 30 255 45 270
Rectangle -16777216 true false 255 255 270 270
Rectangle -6459832 true false 0 15 15 285

w1 blue ground block
false
8
Rectangle -11221820 true true 0 0 300 300
Rectangle -16777216 true false 120 210 135 240
Rectangle -16777216 true false 15 210 45 225
Rectangle -16777216 true false 45 225 75 240
Rectangle -16777216 true false 75 240 120 255
Rectangle -16777216 true false 165 120 285 135
Rectangle -16777216 true false 165 105 180 120
Rectangle -1 true false 150 15 165 120
Rectangle -1 true false 165 135 285 150
Rectangle -1 true false 150 135 165 210
Rectangle -1 true false 15 15 30 210
Rectangle -16777216 true false 0 15 15 285
Rectangle -16777216 true false 15 285 105 300
Rectangle -16777216 true false 105 255 120 300
Rectangle -16777216 true false 285 15 300 120
Rectangle -16777216 true false 285 135 300 285
Rectangle -16777216 true false 135 285 285 300
Rectangle -16777216 true false 270 270 285 285
Rectangle -1 true false 15 0 135 15
Rectangle -16777216 true false 135 0 150 210
Rectangle -1 true false 165 0 285 15
Rectangle -1 true false 120 240 135 300
Rectangle -1 true false 135 210 150 240
Rectangle -1 true false 15 225 45 240
Rectangle -1 true false 15 240 30 285
Rectangle -1 true false 45 240 75 255
Rectangle -1 true false 75 255 105 270

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
