# DTR---iOS-Hackathon-Game
 An iOS application developed by Raymond Luu, Dylan Sharkey, Tim Chen.

#Summary
This project was made to show off the capabilities of the coreMotion iOS framework, this was the winner of the Coding Dojo iOS coreMotion 2 day Hackathon.

This game was designed so that it would serve as a platform to integrate other mini-games in the future.
The mini-games showcase the use of an iphone gyroscope, accelerometer,  device attitude/position and changes in motion state. 

#Contribution
My main contribution to this project was researching and integrating the coreMotion aspects of each game. Additionally I designed and wrote the majority of the modular mini-game code excluding the ballHole game. These games were coded so that they could be readily integrated into the framework that Dylan Sharkey worked on. 

#The Minigames
Pickup phone game in which we use the iPhone's accelerometer to detect when the phone is still which initiates a timer and when accelerometer detects a change stops the timer and informs the player if the “won” the game (picked up the phone within allotted time).

BallHole is a game developed by Raymond Luu, the goal of the game is to use the iPhone’s sensors to determine device state and help roll a ball to it’s hole within the allotted time.

ScrewDriver Game is a game that uses the gyroscope and determines when the phone has been adequately rotated, or turned like a screwdriver. The app uses the that collected gyroscope data to compare against a randomly generated “screw depth” and determine if the player has generated enough rotational force within the allotted time.

armWrestle is a game that detects device attitude and is tuned to detect when the phone is being held in an arm wrestling position. It then signals the player to “arm wrestle” and bring the phone down and it registers the iPhone's gyroscope and determines if the player is strong or weak.

