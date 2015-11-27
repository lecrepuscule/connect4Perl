#
#The objective of this program simulates a connect4 game, in which two players compete against each other by droping their corresponding coins into a 
#rectangular board from the entries at the top of the board. Whoever manages the connect 4 of their coins first in either horizontal, vertical,
#leading diagonal or anti-diagonal direction wins the game.
#However, this program has gone beyond the conventional settings of a connect4 game -- players can decide the number of rows and columns of the board,
#as well as the number of connected coins in order to win a game. In theory, these numbers can be anything of the player's desire, but for practical reasons
#some constraints have been made against them so that the game can be played. 
#
#The program consists of three seperate classes(packages): Controller, Board and Display. this is the file of the 
#Controller class, which interacts with objects from the other two classes, please see comments in the class files for their repective descriptions.   








#Controller class deals with players, and acts as a "referee".
#all the x and y variables are equivalent to the coordinates of the x and y-axis of a Cartesian coordinate system. 



#!bin/perl
package Controller;
use Board;
use Display;

	sub askForInput{
		$question=shift;
		@constraints=@_;
		do{
			print "$question \n";
			$userInput=<>;
			unless($userInput>=$constraints[0] && $userInput<=$constraints[1]){
				print "Please enter only a NUMBER between $constraints[0] and $constraints[1] !!!\n";		}
		}until($userInput>=$constraints[0] && $userInput<=$constraints[1]);
		return $userInput;
	}


	sub initGame{
		my ($winningCondition, $xMax, $yMax, $player1, $player2, @initOutput); 
		%player;
		$winner=0;
		$replay;
		$winningCondition=askForInput("please choose the winning condition, connect 4 or connect 5?\n", 4, 5);		
		$yMax=askForInput("please choose the number of rows.\n", $winningCondition, 20);
		$xMax=askForInput("please choose the number of columns.\n", $winningCondition, 20);
		#the object board is public so that all subroutines in the package Controller can see it
		$board=new Board($xMax, $yMax, $winningCondition);
		$player1=askForInput("who should go first? enter 1 for X, 2 for O.\n" ,1 ,2);
		$player2= 3-$player1;
		%player=(_player1 => $player1, _player2 => $player2); 
		@initOutput=$board->getBoardSize();
		$display=new Display(@initOutput);
		print "player ".$display->showSymbol($player1)." goes first. \n";
	} 


	sub runGame{ 
		my ($x, $y, $playerTurn, $outputToDisplay);
		my @size=$board->getBoardSize();
		for ( $i=1; $i<=2; $i++  ){
			$playerTurn="_player$i";
			#the loop checks if the column number is valid and if the chosen column is already full 
			do{
				print $display->showSymbol($player{$playerTurn})."\'s turn. where to insert the coin? choose from 1 to ".$size[0];
				$x=<>;
				unless( $x>=1 && $x<=$size[0]){
					print "please enter only a NUMBER between 1 and ".$size[0]."!! \n";
				}
				unless( $board->getBoardStatus($x,1) == 0){
					print "this column is FULL!! please choose another one! \n";	
				}	
			}until ($x>=1 && $x<=$size[0] && $board->getBoardStatus($x,1)==0);
			
			$y = $board->updateBoardStatus($player{$playerTurn}, $x);
			$winner = $board->checkConnections($player{$playerTurn}, $x, $y);
			$outputToDisplay = $board->getBoardStatus();
			$display->displayBoard($outputToDisplay);
			if($winner != 0){
				last;
			}
		}
	}	


	sub endGame{
		print "player ".$display->showSymbol($winner*-1)." is the winner! \n";
		$replay=askForInput("wanna go again? please enter '0' for NO or '1' for YES.\n" ,0 ,1);
		if ( $replay == 1){
				print "another round then!\n";
		}
		elsif ( $replay == 0){
				print "BYE";
		}
	}


	#Creating a reference to the whole status of the board for Display.
	sub generateOutput{
		my @outputToDisplay;
		my ($xMax,$yMax)=$board->getBoardSize();
		for ($i=0; $i < $xMax; $i++){
			for ($j=0; $j < $yMax; $j++){
				push (@outputToDisplay, [$i,$j,$board->getBoardStatus($i,$j)]);
			}
		}
		return @outputToDisplay;
	}


#the main programe starts here
do{
	initGame();
	while ($winner==0){
		runGame();
	}
	endGame();
}while ($replay == 1);
