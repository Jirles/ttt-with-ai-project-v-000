require "pry"
module Players

  class Computer < Player
    
    attr_reader :token, :level_of_difficulty, :opponent_token
    
   # WIN_HASH = {"1"=>3, "2"=>2, "3"=>3, "4"=>2, "5"=>4, "6"=>2, "7"=>3, "8"=>2, "9"=>3}
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

    CENTER = "5"
    CORNERS = ["1", "3", "7", "9"]

    def initialize(level_of_difficulty=2, token)
      #determines if you play stupid computer (random sampling) or ai 
      @level_of_difficulty = level_of_difficulty
      @token = token 
      case 
        when self.token ==  "X"
          @opponent_token = "O"
        else
          @opponent_token = "X"
      end
    end
  
    # dumb computer (1) passes all tests - success
    
    def random_move(board)
      # just choose something at random until you hit upon a valid move
      (1..9).to_a.sample.to_s
    end
    
    # begin smart computer (2) methods - not passing tests
    
    def create_cheat_sheet(board)
        WIN_COMBINATIONS.collect do |combo|
        combo.collect do |index|
          if board.cells[index] == " "
            (index + 1).to_s
          else
            board.cells[index] 
          end 
        end 
      end 
    end 

    #determining opponent_token is necessary for move-choosing-methods block? and win_imminent?

    #CENTER has most WIN_COMBINATIONS but if it is taken, an opposing token in one of the CORNERS will ensure a cat's game or possibly a win with a stupid enough opponent
    def first_move(board)
      if !board.taken?(CENTER)
        CENTER
      else
        CORNERS.sample #<= chooses randomly from CORNERS
      end
    end

    #determines if a win is imminent, i.e. there is a WIN_COMBINATION with two spaces taken by sef.token and an empty space (will be an integer on cheat_sheet)

  def win_imminent?(cheat_sheet)
    cheat_sheet.detect do |combo| 
      combo.count{|space| space == token} == 2 && !combo.include?(opponent_token)
    end
  end

    # uses cheat_sheet and determines if a block is necessary if a combo contains two opponent_tokens 
    
    def block?(cheat_sheet)
      cheat_sheet.detect do |combo| 
        combo.count{|space| space == opponent_token} == 2 && !combo.include?(token)
      end
    end
    
    def ai_move(board)
      create_cheat_sheet(board)
      if board.turn_count == 0 || board.turn_count == 1
        first_move(board)
      else
        if win_imminent?(cheat_sheet)
            win_imminent?(cheat_sheet).detect{|x| x != token}
        elsif block?(cheat_sheet) 
            block?(cheat_sheet).detect{|x| x != opponent_token}
        else
            random_move(board)
        end
        binding.pry 
      end
    end
    
    def move(board)
      if level_of_difficulty == 1
        random_move
      else
        ai_move(board)
      end
    end

  end
  
end