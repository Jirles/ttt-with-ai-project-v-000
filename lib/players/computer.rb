require "pry"
module Players

  class Computer < Player
    
    attr_reader :token, :level_of_difficulty, :opponent_token
    
   WIN_COUNTS = {0=>3, 1=>2, 2=>3, 3=>2, 4=>4, 5=>2, 6=>3, 7=>2, 8=>3}
   
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
    
    # begin smart computer (2) methods - passes
    
    def index_to_move(index)
      (index + 1).to_s 
    end
    
    def create_cheat_sheet(board)
        WIN_COMBINATIONS.collect do |combo|
        combo.collect do |index|
          if board.cells[index] == " "
            index_to_move(index)
          else
            board.cells[index] 
          end 
        end 
      end 
    end 
    
    def create_updated_win_hash(board)
      Hash.new.tap do |new_hash|
        WIN_COUNTS.each do |k, v|
          if board.cells[k] == token || board.cells[k] == opponent_token
            
          end
        end
      end
    end
    
    def choose_best_move(hash)
      max_moves = 0
      best_available = 0
      hash.each do |k,v|
        if v > max_moves
          max_moves = v
          best_available = k
        end 
      end 
      index_to_move(best_available)               
    end

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
     cheat_sheet = create_cheat_sheet(board)
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