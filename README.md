# Orbit-Simulator
Created for my final CS project.

# About this program
This is an orbital simulator program. When two objects enter another's SOI (sphere of influence), a separate animation will play that will display what would theoretically happen if the planets were to approach one another. 

# What this program can accurately predict
1. Orbital motion of elliptical orbits
2. When another planet enters another's SOI accurately and correctly adding the vectors to yield the correct product of the gravity assist
3. The incoming path of the planet as it enters the other's SOI

# Assumptions about this program
1. The path of the orbiter is unchanged after entering another's SOI. However, its resultant magnitude will still be shown so the effects of gravity assists can still be shown.
2. The orbiter always enters and exits from the same direction in the exact same path. This is far from how it is in real life, but the purpose of this animation is to show how inertial reference frames
interact with each other in space, resulting in greater velocity.
3. The orbiter will not crash if it collides with another body. This is clearly not consistent with real life, but in real life, there is a very rare chance that an object will crash into another in space
due to the vast distances between them. Of course, there are exceptions, but most of the time you don't hit something in space unless you want to.

# Additional info
* The program will terminate after another orbiting body enters and escapes another's SOI.
* After pressing start simulation, no more orbiting bodies can be added to the program.
* All units in the GUI are in AU. In this simulation, 1 AU = 50 px
