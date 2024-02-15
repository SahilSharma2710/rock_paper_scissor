#ifdef WIN32
   #define EXPORT __declspec(dllexport)
#else
   #define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

// C++ Program to Implement Rock-Paper-Scissors 
#include <cstdlib> 
#include <ctime> 
#include <iostream> 
using namespace std; 

// get the computer move 
EXPORT
char getComputerMove() 
{ 
	int move; 
	// generating random number between 0 - 2 
	srand(time(NULL)); 
	move = rand() % 3; 

	// returning move based on the random number generated 
	if (move == 0) { 
		return 'p'; 
	} 
	else if (move == 1) { 
		return 's'; 
	} 
	return 'r'; 
} 

// Function to return the result of the game
EXPORT 
int getResults(char playerMove, char computerMove) 
{ 
	// condition for draw 
	if (playerMove == computerMove) { 
		return 0; 
	} 
	// condition for win and loss according to game rule 
	if (playerMove == 's' && computerMove == 'p') { 
		return 1; 
	} 
	if (playerMove == 's' && computerMove == 'r') { 
		return -1; 
	} 
	if (playerMove == 'p' && computerMove == 'r') { 
		return 1; 
	} 
	if (playerMove == 'p' && computerMove == 's') { 
		return -1; 
	} 
	if (playerMove == 'r' && computerMove == 'p') { 
		return -1; 
	} 
	if (playerMove == 'r' && computerMove == 's') { 
		return 1; 
	} 
	
	return 0; 
} 
