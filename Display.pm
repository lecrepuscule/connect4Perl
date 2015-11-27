#the Display class takes in data from the Controller then prints out the board, it could be improved using GUI if time permits

#!/bin/perl;

package Display;
use Switch;


#This constructor prints out an initialised board to the screen
sub new{
	my $class=shift;
	my $displayer={
		_columnNum => shift,
		_rowNum => shift,
		%player=(_player1 => $player1, _player2 => $player2), 
	};
	system('clear');
	for ($i=1; $i<=$displayer->{_columnNum}; $i++){
		print "$i \t";
	}
	print "\n";
	for ($j=0; $j < $displayer->{_rowNum}; $j++){
		for ($i=0; $i < $displayer->{_columnNum}; $i++){
			print "- \t";
		}
		print "\n \n \n";
	}
	bless ($displayer, $class);
	return $displayer;
}


#Showing the symbol of the player to the screen.
sub showSymbol{
	my $displayer=shift;
	my $colour=shift;
	switch($colour){
		case 1 {return "X"}
		case 2 {return "O"}
		case 0 {return "-"}
		else   {return "W"};
	}
}


#This displays the column numbers of the board on the screen.
sub showHeader{
	my $displayer=shift;
	for ($i=1; $i<=$displayer->{_columnNum}; $i++){
		print "$i \t";
	}
	print "\n";
}


#Takes in a reference for the status of the board and prints them out individualy. 
sub displayBoard{
	my $displayer=shift;
	my $boardStatus=shift;
	system('clear');
	$displayer->showHeader();
	for ($j=0; $j < $displayer->{_rowNum}; $j++){
		for ($i=0; $i < $displayer->{_columnNum}; $i++){
			print $displayer->showSymbol($boardStatus->[$i][$j])." \t";
		}
		print "\n \n \n";
	}	
}

1;




