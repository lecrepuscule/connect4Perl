#Board class, storage for all the coins, does all the checks and calculations
#all x and y variables are the coordinates of the x-axis and y-axis in a Cartesian coordinate

#!/bin/perl

package Board;
	
sub new{
	my $class = shift;
	my $board={
		_xMax => shift,
		_yMax => shift,
		_winCondition => shift,
		_boardStatus => \@boardGrip
	};
#creating the board as an array of references that refer to arrays ie. $boardGrip[x][y] 
#careful with the difference between indices and actual numbers		
	for ($i=0; $i < $board->{_yMax}; $i++){
		for ($j=0; $j < $board->{_xMax}; $j++){
			$row[$j]=0;
		}
		$boardGrip[$i]=[ @row ];	 
	}
	bless $board, $class;
	return $board; 
}	


sub updateBoardStatus{
	my $board=shift;
	my ($player, $x)=@_;
#Drops the coin into the board, and then positions it into the first available slot.
	for ($i=$board->{_yMax}-1; $i>=0; $i--){
		if ($board->{_boardStatus}->[$x-1][$i]==0){
			$board->{_boardStatus}->[$x-1][$i]=$player;
			#returns the y coordinate of the changed square
			return $i+1;
		}	
	}
}


#puts the coordinates of the consecutive squares with same colour into an array and returns it
sub countConnections{
	my $board=shift;
	my ($player, $x, $xi, $y, $yi, @connection)=@_;
	if ($board->{_boardStatus}->[$x+$xi][$y+$yi]==$player){
		push (@connection,[$x+$xi,$y+$yi]);
	}
	else{
		@connection=();
	}
	return @connection;
}


sub checkConnections{
	my $board=shift;
	my ($player, $X, $Y)=@_;
	#takes care of the difference between array indices and actual row and column numbers
	my $x=$X-1;
	my $y=$Y-1;
	my @horiConnection=();
	my @vertiConnection=();
	my @leadDiagConnection=();
	my @antiDiagConnection=();
	my $winner=0;
	for ($i=1-$board->{_winCondition}; $i<=$board->{_winCondition}-1; $i++){
		#check horizontal boundries of the board
		if ( $x+$i <= $board->{_xMax} && $x+$i >= 0 ){
			#counting connections within 3 squares horizontally from the newly inserted coin
			@horiConnection=$board->countConnections($player, $x, $i, $y, 0, @horiConnection); 
			#check vertical boundries of the board
			if ( $y+$i <= $board->{_yMax} && $y+$i >= 0 ){
				#counting connections within 3 squares in leading diagonal direction from the newly inserted coin
				@leadDiagConnection=$board->countConnections($player, $x, $i, $y, $i, @leadDiagConnection); 
			}
			if ( $y-$i <= $board->{_yMax} && $y-$i >= 0 ){
				@antiDiagConnection=$board->countConnections($player, $x, $i, $y, $i*-1, @antiDiagConnection); #anti	
			}
		}
		if ( $y+$i <= $board->{_yMax} && $y+$i >= 0 ){
			@vertiConnection=$board->countConnections($player, $x, 0, $y, $i, @vertiConnection); #verti
		}
		$winner=$board->findWinner($player, \@horiConnection, \@vertiConnection, \@leadDiagConnection, \@antiDiagConnection);
		if ($winner != 0){
			return $winner;
		}
	}
}


#checks if there're 4 consecutive squares with same colour and highlights them
#sets the number of the winner to its negative value, might be handy in the future to have multiple players
sub findWinner{
	my $board=shift;
	my $player=shift;
	my $winner=0;
	foreach $connection (@_){
		if ( scalar(@{$connection})==$board->{_winCondition}){
			$winner=$player*-1;
			foreach $coord (@{$connection}){
				$board->{_boardStatus}->[$coord->[0]][$coord->[1]]=$winner;
			}
		}
	}
	return $winner;
}



sub getBoardSize{
	my $board=shift;
	my @boardSize=($board->{_xMax},$board->{_yMax});
	return @boardSize;
}


sub getBoardStatus{
	my $board=shift;
	if(@_){
		my ($x,$y)=@_;
		return $board->{_boardStatus}->[$x-1][$y-1];
	}
	else{
		return $board->{_boardStatus};
	}
}


1;


	
