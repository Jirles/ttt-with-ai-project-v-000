
class Game
  
  WIN_COMBINATIONS = [
    [0,1,2], #top row
    [3,4,5], #mid row
    [6,7,8], #bot row
    [0,3,6], #left col
    [1,4,7], #mid col
    [2,5,8], #right col
    [0,4,8], #l>r diag
    [2,4,6]  #r>l diag
  ]

  attr_accessor :board, :player_1, :player_2
  
  def initialize(player_1=Players::Human.new('X'), player_2=Players::Human.new('O'), board=Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board 
  end
  
  def self.start
    play = true 
    while play
      puts "Welcome to TicTacToe!"
      puts "How many players?"
      puts "Please enter 0 for a 0-player game, where the computer plays itself,"
      puts "Please enter 1 to play against the computer."
      puts "Please enter 2 to play against a friend."
      player_num = gets.chomp 
      if player_num == "0"
        game = Game.new(player_1=Players::Computer.new('X'), player_2=Players::Computer.new('O'))
      elsif player_num == "1"
        puts "Who will go first? Press c for the computer or h for human."
        player1 = gets.chomp 
        if player1 == 'c'
         game = Game.new(player_1=Players::Computer.new('X'), player_2=Players::Human.new('O'))
        else 
          game = Game.new(player_1=Players::Human.new('X'), player_2=Players::Computer.new('O'))
        end
      else 
        game = Game.new 
      end
      puts "Let's play!"
      game.play 
      puts "Nice job! Would you like to play again? y/n"
      input = gets.chomp 
      input == 'y' ? play : play = false 
    end
    puts "Buh bye!"
  end
  
  # returns currently player based on number of turns already taken 
  # board object tracks turns already taken 
  def current_player
    self.board.turn_count.even? ? self.player_1 : self.player_2
  end

  # Validation methods:
  
  # checks WIN_COMBINATIONS and board too look for a winner, returns winning combination
  def won?
    winner = nil
    WIN_COMBINATIONS.each do |combo|
      converted_combo = combo.collect{ |i| self.board.cells[i] }
      if converted_combo.all?{|cell| cell == "X"} || converted_combo.all?{|cell| cell == "O"}
        winner = combo 
      end
    end
    winner 
  end


  #are all the spaces full without a winning combination?
  def draw?
    !self.won? && self.board.full?
  end

  #game over?
  def over?
    self.won? || self.draw?
  end

  # checks to see who is the winner, returns X, O, or nil
  # if there is a winner, 
  # use won? (returns the winning combo from WIN_COMBINATIONS) to index into board cells
  # else nil 
  def winner
    self.won? ? self.board.cells[self.won?[0]] : nil 
  end

  def turn
    move = self.current_player.move(self.board)
    until self.board.valid_move?(move)
      move = self.current_player.move(self.board)
    end
    self.board.update(move, self.current_player)
  end
    

  def play
    until self.over?
      self.board.display
      self.turn
    end
    if self.won?
      self.board.display
      puts "Congratulations #{self.winner}!"
    else
      self.board.display
      puts "Cat's Game!"
    end
  end

end
