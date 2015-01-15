globals [jump-state mushroom-x mushroom-y player-number game frame column make-state]

;Attributes----------------------------------------------------------------------------------------------------------------------------------------------------------------------


;BREEDS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
breed [mushrooms mushroom]
breed [question-blocks question-block]
breed [empty-blocks empty-block]
breed [ground-blocks ground-block]
breed [disguised-blocks disguised-block]
breed [bullets bullet]
breed [used-blocks used-block]
breed [above-ground-blocks above-ground-block]
breed [pipe-blocks pipe-block]
breed [players player]
breed [enemies enemy]

;Attributes----------------------------------------------------------------------------------------------------------------------------------------------------------------------

players-own [move-state]




to go ;makes sure players fall from heights down to the ground
  movement-conditions
  setup-column-level-one
end


;SETUP FUNCTIONS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

;main
to setup ;main setup function
  ca
  user-message "Remember to Press Go :)"
  resize-world 0 16 0 16
  set-patch-size 26
  ;import-drawing "bild.jpg"
  setup-level-one
  setup-player
  set game false
  set-move-state
end

to setup-player ;sets up the player
  create-players 1 [set ycor min-pycor + 2.25 set xcor -15 set heading 90 set shape "mario" set color 28 set size 1.7 set player-number who]
end

;individual
to setup-enemies [height x-coordinate]
  create-enemies 1 [set ycor height set xcor x-coordinate set shape "enemy" set color 48]
end
  
to setup-ground-blocks [how-many height x-coordinate]
  repeat how-many [ 
    create-ground-blocks 1 [set ycor min-pycor + height set xcor x-coordinate set shape "ground-block" set color 24]
  set x-coordinate x-coordinate + 1
  ]
end

to setup-question-blocks [how-many height x-coordinate]
  repeat how-many [
    create-question-blocks 1 [set ycor min-pycor + height  set shape "question-block" set color 26 set xcor x-coordinate]
  create-mushrooms 1 [set ycor min-pycor + height set shape "mushroom" set color red set xcor x-coordinate]
  set x-coordinate x-coordinate + 1
  ]
end  


to setup-empty-blocks [how-many height x-coordinate]
  repeat how-many [
    create-empty-blocks 1 [set ycor height set shape "empty-block" set color 23 set xcor x-coordinate]
  set x-coordinate (x-coordinate + 1)
  ]
end

to setup-above-ground-blocks [how-many height x-coordinate]
    repeat how-many [
      create-above-ground-blocks 1 [set ycor height set shape "above-ground-block" set color 27 set xcor x-coordinate]
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

to setup-disguised-blocks [how-many height x-coordinate prize prize-color]
  repeat how-many [
    create-disguised-blocks 1 [set ycor min-pycor + height  set shape "empty-block" set color 23 set xcor x-coordinate]
    create-mushrooms 1 [set ycor min-pycor + height set shape prize set color prize-color set xcor x-coordinate]
  set x-coordinate x-coordinate + 1
  ]
end

to setup-flag
  let height 3
  repeat 8 [
    create-above-ground-blocks 1 [set ycor height set shape "flag-pole" set color green set xcor max-pxcor]
    set height (height + 1)
  ]
  create-above-ground-blocks 1 [set ycor height set shape "flag" set color green set xcor max-pxcor]
  create-above-ground-blocks 1 [set ycor height + 1 set shape "flag-top" set color green set xcor max-pxcor]
  setup-above-ground-blocks 1 2 max-pxcor  
end
  

;MOVEMENT FUNCTIONS  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;main
to move-right ;moves player right 
  if breed = players and (not any? turtles-at 1 0 or any? mushrooms-at 1 0) [ ;if there is nothing to the right of the player the player is able to move right
    fd 1]
end

to move-left ;moves player left
  if breed = players and not (xcor = min-pxcor) and (not any? turtles-at -1 0 or any? mushrooms-at -1 0) [ ;if there is nothing to the left of the player the player is able to move left
    if not can-move? 1 [rt 180]
    bk 1]
end

to move-jump [how-high];main jump function made so that the position of the mouse can help move the player mid flight 
  set jump-state true
  ;five times each
  let time 0
  repeat how-high [
    if any? players [
    wait .01 * time
    set time time + 1
    move-jump-up-part
    if mouse-down? [
      ifelse mouse-xcor < ([xcor] of player player-number)  ;checks position of clicked mouse to wether to move left or right mid flight
      [move-left]
      [move-right]]]]
  prize-condition 
  ;five times
  set jump-state true
  repeat how-high [ 
    if any? players [
    wait .01 * (time - 1)
    set time time - 1
    move-jump-down-part
    if mouse-down? [
      ifelse mouse-xcor < ([xcor] of player player-number) ;checks position of clicked mouse to wether to move left or right mid flight
      [move-left]
      [move-right]]]]
  set time 0
end

to movement-conditions
  ask players [ ;makes sure the players will fall down 
    if not any? turtles-at 0 -1.25 or (any? mushrooms-at 0 -1 and not any? question-blocks-at 0 -1) [wait .05 set ycor ycor - 1]
    mushroom-test
    enemy-test
    enemy-kill
    if ycor <= .25 [write "Game over" die]
  ]
  ask enemies [
    if not any? turtles-at 0 -1 or any? players-at 0 -1 [ifelse ycor = min-pycor [die] [wait .05 set ycor ycor - 1]]
    enemy-move]
    
end

;sub-functions
to mushroom-test
  if breed = players and any? mushrooms-here [
    ask mushrooms-at 0 0 [die]
    flash .02
    set color white
  ]
end

to enemy-kill
  if breed = players and any? enemies-at 0 -1.25 [ask enemies-at 0 -1 [die]]
end

to enemy-test
  if breed = players and any? enemies-here [
    flash .02
    die
  ]
end

to enemy-move
  if breed = enemies and (not any? turtles-at -1 0 or any? players-at -1 0) and any? turtles-at 0 -1 [ifelse xcor = min-pxcor [die] [ wait .3 set xcor (xcor - 1)]]
end
 
to move-jump-up-part ;moves the player up until and obstacle is met or the maximum height is achieved (5 units)
  if breed = players and not (ycor = max-pycor) [
    ifelse any? turtles-at 0 1.25 [set jump-state false] [set ycor ycor + 1]]
  
end

to move-jump-down-part ;makes sure the player falls to the ground
  if breed = players and not (ycor = min-pycor) [
    ifelse any? turtles-at 0 -1.25 [set jump-state false] [set ycor ycor - 1] ]
end

to prize-condition ;destroys question-blocks if the player smashes into them from the bottom
  if (breed = question-blocks or breed = disguised-blocks) and any? players-at 0 -2 [
    set mushroom-x xcor set mushroom-y ycor
    flash .01 set breed used-blocks set shape "used-block" set color 27 ask mushrooms with [xcor = mushroom-x and ycor = mushroom-y] [set ycor ycor + 1]]
end

to flash [time];flashes turtle before death 
  set color blue wait time set color yellow wait time set color red wait time set color green wait time set color white wait time
end

;Frame Changing  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

;World 1 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to set-move-state
  ask players [
    set move-state true]
end

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

to setup-normal-ground
  setup-ground-blocks 1 0 max-pxcor
  setup-ground-blocks 1 1 max-pxcor
end

to everytime [number]
  set column number
  set make-state 0
end

;Level one repeat columns
to make-plain-column [number]
  if make-state = 1 and column = number
  [
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-high_empty-column [number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks 1 10 max-pxcor
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-low_empty-column [number]
  if make-state = 1 and column = number
  [
    setup-empty-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-low_empty-high_question-column [number]
  if make-state = 1 and column = number
  [
    setup-question-blocks 1 10 max-pxcor
    setup-empty-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-low_question-column [number]
  if make-state = 1 and column = number
  [
    setup-question-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-pipe-left-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-left how-high 2 max-pxcor 
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-pipe-right-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-pipe-right how-high 2 max-pxcor 
    setup-normal-ground
    everytime (number + 1)
  ]
end

to make-above-ground-stack-column [how-high number]
  if make-state = 1 and column = number
  [
    setup-above-ground-blocks how-high 2 max-pxcor 
    setup-normal-ground
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
;main setup
to setup-level-one
  setup-ground-intial-level-one
end

;sub-functions ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-ground-intial-level-one ;sets up all intial ground blocks
  setup-ground-blocks (max-pxcor + 1) 0 0
  setup-ground-blocks (max-pxcor + 1) 1 0 
end
;column change ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
to setup-column-level-one
  ask players [
    move-grid 
    set-move-state
  ]
  ;---------------------------------------------------------------------------------
  make-low_empty-column 0
  make-plain-column 1
  make-plain-column 2
  make-plain-column 3
  make-low_empty-column 4
  if make-state = 1 and column = 5
  [
    setup-enemies 2 max-pxcor
    setup-question-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 6
  ]
  make-low_empty-high_question-column 6
  make-low_question-column 7
  make-low_empty-column 8
  make-plain-column 9
  make-plain-column 10
  make-plain-column 11
  make-pipe-left-column 1 12
  make-pipe-right-column 1 13
  make-plain-column 14
  make-plain-column 15
  make-plain-column 16
  make-plain-column 17
  make-plain-column 18
  make-plain-column 19 
  make-plain-column 20
  make-plain-column 21
  make-pipe-left-column 2 22
  make-pipe-right-column 2 23
  make-plain-column 24
  make-plain-column 25
  make-plain-column 26
  make-plain-column 27
  make-plain-column 28
  make-plain-column 29
  make-pipe-left-column 3 30
  make-pipe-right-column 3 31
  make-plain-column 32
  make-plain-column 33
  make-plain-column 34
  make-plain-column 35
  make-plain-column 36
  make-plain-column 37
  make-plain-column 38
  make-plain-column 39
  make-plain-column 40
  make-pipe-left-column 3 41
  make-pipe-right-column 3 42
  make-plain-column 43
  make-plain-column 44
  make-plain-column 45
  make-plain-column 46
  make-plain-column 47
  if make-state = 1 and column = 48
  [
    setup-disguised-blocks 1 7 max-pxcor "mushroom" (green - 2)
    setup-normal-ground
    everytime 49
  ] 
  make-plain-column 49
  make-plain-column 50
  make-plain-column 51
  make-plain-column 52
  make-empty-column 53
  make-empty-column 54
  make-plain-column 55 
  make-plain-column 56
  make-plain-column 57
  make-plain-column 58
  make-plain-column 59
  make-plain-column 60
  make-low_empty-column 61
  make-low_question-column 62
  if make-state = 1 and column = 63
  [
    setup-enemies 8 max-pxcor 
    setup-empty-blocks 1 10 max-pxcor 
    setup-normal-ground
    everytime 64
  ] 
  make-low_empty-column 63
  make-high_empty-column 64
  make-high_empty-column 65
  if make-state = 1 and column = 66
  [
    setup-enemies 11 max-pxcor
    setup-empty-blocks 1 10 max-pxcor
    setup-normal-ground
    everytime 67
  ] 
  make-high_empty-column 67
  make-high_empty-column 68 
  make-high_empty-column 69
  if make-state = 1 and column = 70
  [
    setup-empty-blocks 1 10 max-pxcor
    everytime 71
  ] 
  if make-state = 1 and column = 71
  [
    setup-empty-blocks 1 10 max-pxcor
    everytime 72
  ]
  make-empty-column 72
  make-plain-column 73
  make-plain-column 74
  make-high_empty-column 75
  make-high_empty-column 76
  make-high_empty-column 77
  if make-state = 1 and column = 78
  [
    setup-empty-blocks 1 10 max-pxcor
    setup-empty-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 79
  ]
  make-plain-column 79
  make-plain-column 80
  make-plain-column 81
  make-plain-column 82
  make-plain-column 83
  make-low_empty-column 84
  make-low_empty-column 85 ;add hidden star block type later
  make-plain-column 86
  make-plain-column 87
  make-plain-column 88 
  make-plain-column 89
  if make-state = 1 and column = 90
  [
    setup-question-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 91
  ]
  make-plain-column 91
  make-plain-column 92
  if make-state = 1 and column = 93
  [
    setup-question-blocks 1 10 max-pxcor
    setup-question-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 94
  ]
  make-plain-column 94
  make-plain-column 95
  if make-state = 1 and column = 96
  [
    setup-question-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 97
  ]
  make-plain-column 97
  make-plain-column 98
  make-plain-column 99
  make-plain-column 100
  make-plain-column 101
  make-low_empty-column 102
  make-plain-column 103
  make-plain-column 104
  make-high_empty-column 105 
  make-high_empty-column 106
  make-high_empty-column 107
  make-plain-column 108
  make-plain-column 109
  make-plain-column 110
  make-plain-column 111
  make-high_empty-column 112
  if make-state = 1 and column = 113
  [
    setup-question-blocks 1 10 max-pxcor
    setup-empty-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 114
  ]
  if make-state = 1 and column = 114
  [
    setup-question-blocks 1 10 max-pxcor
    setup-empty-blocks 1 6 max-pxcor
    setup-normal-ground
    everytime 115
  ]
  make-high_empty-column 115
  make-plain-column 116
  make-plain-column 117
  make-above-ground-stack-column 1 118
  make-above-ground-stack-column 2 119
  make-above-ground-stack-column 3 120
  make-above-ground-stack-column 4 121
  make-plain-column 122
  make-plain-column 123
  make-above-ground-stack-column 4 124
  make-above-ground-stack-column 3 125
  make-above-ground-stack-column 2 126
  make-above-ground-stack-column 1 127
  make-plain-column 128
  make-plain-column 129
  make-plain-column 130
  make-plain-column 131
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
  make-plain-column 143
  make-plain-column 144
  make-plain-column 145
  make-plain-column 146
  make-pipe-left-column 1 147
  make-pipe-right-column 1 148
  make-plain-column 149
  make-plain-column 150
  make-plain-column 151
  make-low_empty-column 152
  make-low_empty-column 153
  make-low_question-column 154
  make-low_empty-column 155
  make-plain-column 156
  if make-state = 1 and column = 157
  [
    setup-enemies 2 max-pxcor
    setup-normal-ground
    everytime 158
  ]
  make-plain-column 158
  if make-state = 1 and column = 159
  [
    setup-enemies 2 max-pxcor
    setup-normal-ground
    everytime 160
  ]
  make-plain-column 160
  make-plain-column 161
  make-plain-column 162
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
  make-plain-column 174
  make-plain-column 175
  make-plain-column 176
  make-plain-column 177
  make-plain-column 178
  make-plain-column 179
  make-plain-column 180
  make-plain-column 181
  if make-state = 1 and column = 182
  [
    setup-flag
    setup-normal-ground
    everytime 183
  ]
  make-plain-column 183
  make-plain-column 184
  make-plain-column 185
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
662
483
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
21
26
87
59
setup
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
68
95
101
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
69
202
102
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
98
27
201
60
Jump
ifelse game\n[move-jump 7]\n[user-message \"You didn't press go! :(\"]
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
33
111
168
144
go
go\nset game true
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

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

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

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

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

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

enemy
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

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

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
Rectangle -16777216 true false 90 30 210 45
Rectangle -16777216 true false 60 45 105 60
Rectangle -16777216 true false 195 45 240 60
Rectangle -16777216 true false 45 60 75 75
Rectangle -16777216 true false 225 60 255 75
Rectangle -16777216 true false 30 75 60 90
Rectangle -16777216 true false 30 90 45 120
Rectangle -16777216 true false 15 105 45 120
Rectangle -16777216 true false 15 120 30 210
Rectangle -16777216 true false 240 75 270 90
Rectangle -16777216 true false 255 90 270 120
Rectangle -16777216 true false 255 105 285 120
Rectangle -16777216 true false 270 120 285 210
Rectangle -16777216 true false 240 210 285 225
Rectangle -16777216 true false 15 210 60 225
Rectangle -16777216 true false 60 195 75 225
Rectangle -16777216 true false 225 195 240 225
Rectangle -16777216 true false 60 180 240 195
Rectangle -16777216 true false 30 225 60 240
Rectangle -16777216 true false 240 225 270 240
Rectangle -16777216 true false 45 240 60 270
Rectangle -16777216 true false 240 240 255 270
Rectangle -16777216 true false 60 255 75 285
Rectangle -16777216 true false 225 255 240 285
Rectangle -16777216 true false 75 270 225 285
Rectangle -16777216 true false 120 195 135 240
Rectangle -16777216 true false 165 195 180 240
Rectangle -1 true false 60 225 120 255
Rectangle -1 true false 75 195 120 240
Rectangle -1 true false 135 195 165 240
Rectangle -1 true false 180 195 225 240
Rectangle -1 true false 180 225 240 255
Rectangle -1 true false 105 240 195 270
Rectangle -1 true false 75 240 120 270
Rectangle -1 true false 180 240 225 270
Rectangle -2674135 true true 105 45 120 75
Rectangle -2674135 true true 75 60 105 90
Rectangle -2674135 true true 45 90 60 165
Rectangle -2674135 true true 30 120 45 165
Rectangle -2674135 true true 60 105 75 150
Rectangle -2674135 true true 120 105 180 180
Rectangle -2674135 true true 105 120 120 165
Rectangle -2674135 true true 180 120 195 165
Rectangle -2674135 true true 180 45 195 75
Rectangle -2674135 true true 195 60 225 90
Rectangle -2674135 true true 240 90 255 165
Rectangle -2674135 true true 255 120 270 165
Rectangle -2674135 true true 225 105 240 150
Rectangle -955883 true false 120 45 180 105
Rectangle -955883 true false 105 75 120 120
Rectangle -955883 true false 60 75 75 105
Rectangle -955883 true false 75 90 105 150
Rectangle -955883 true false 60 150 105 180
Rectangle -955883 true false 30 165 120 180
Rectangle -1184463 true false 45 195 60 195
Rectangle -955883 true false 30 165 60 210
Rectangle -955883 true false 240 165 270 210
Rectangle -955883 true false 180 165 270 180
Rectangle -955883 true false 195 150 240 180
Rectangle -955883 true false 195 120 225 165
Rectangle -955883 true false 225 75 240 105
Rectangle -955883 true false 180 90 225 120
Rectangle -955883 true false 180 75 195 120

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
Polygon -16777216 true false 0 0 0 300 300 300 300 285 15 285 15 15 300 15 300 0 0 0
Polygon -10899396 true false 15 45 90 45 90 285 75 285 60 285 60 75 15 75 15 45
Polygon -10899396 true false 255 285 240 285 240 45 300 45 300 60 255 60 255 285 240 285

pipe-top-right
false
0
Rectangle -13840069 true false 0 0 300 300
Polygon -16777216 true false 0 0 300 0 300 300 0 300 0 285 285 285 285 15 0 15 0 0
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

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108
Line -7500403 true 135 90 135 135
Rectangle -16777216 true false 134 98 141 141
Rectangle -16777216 true false 161 98 168 141

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
