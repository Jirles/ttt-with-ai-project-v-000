require "pry"
module Players

  class Computer < Player
    
    attr_accessor :cheat_sheet 
    attr_reader :token, :level_of_difficulty, :opponent_token
    
   # WIN_HASH = {"1"=>3, "2"=>2, "3"=>3, "4"=>2, "5"=>4, "6"=>2, "7"=>3, "8"=>2, "9"=>3}
    CENTER = "5"
    CORNERS = ["1", "3", "7", "9"]

    def initialize(level_of_difficulty=2, token)
      @cheat_sheet = [["1","2","3"], ["4","5","6"], ["7","8","9"], ["1","4","7"], ["2","5","8"], ["3","6","9"], ["1","5","9"], ["3","5","7"]] #=> copy of WIN_COMBINATIONS but as valid moves 
      
      #determines if you play stupid computer (random sampling) or ai 
      @level_of_difficulty = level_of_difficulty
      @token = token 
      case 
        when token ==  "X"
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
    
    def update_cheat_sheet(board)
      #iterate over cheat_sheet
      cheat_sheet.collect do |combo|
        # go through each combo so we can look at each string (move) in the combo array
        combo.collect do |move|
          
          # that move once converted to an integer and subtracted 1 becomes an index
            index = move.to_i - 1
            
          # the index can be used to access the board.cells property to find out what is present
          # if there is nothing, i.e. " " at board.cells[index]
          if board.cells[index] == " "
            
            # then nothing happens to that string
            move 
            
          # else that string is replaced by board.cells[index] ("X" or "O")
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

  def win_imminent?
    cheat_sheet.detect do |combo| 
      combo.count{|space| space == token} == 2 && !combo.include?(opponent_token)
    end
  end

    # uses cheat_sheet and determines if a block is necessary if a combo contains two opponent_tokens 
    
    def block?
      cheat_sheet.detect do |combo| 
        combo.count{|space| space == opponent_token} == 2 && !combo.include?(token)
      end
    end
    
    def ai_move(board)
      cheat_sheet = update_cheat_sheet(board)
      if board.turn_count == 0 || board.turn_count == 1
        first_move(board)
      else
        if win_imminent?
            win_imminent?.detect{|x| x != token}
        elsif block? 
            block?.detect{|x| x != opponent_token}
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

computer = PLayers::Computer.new("O")
board = Board.new
board.cells = [" ", " ", "O", " ", "X", "X", " ", " ", " "]
ai_move(board)