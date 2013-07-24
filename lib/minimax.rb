require 'facets'
require_relative 'windetection'
require 'pry'

class Minimax 
  include WinDetection

  attr_accessor :i

  def initialize
    @i = 0
  end

  def first_move(board)
    if board.count("+") == 9 
      random_move = [ 0, 2, 4, 6, 8].sample
      return random_move
    else
      move = board.index("O")
      if move > 0
        return move-1
      else
        return move+1
      end
    end
  end

  def first_move?(board, ply)
    if board.count("+") == 9 && ply == 0
      true
    elsif board.count("+") == 8 && ply == 0
      true
    else
      false
    end
  end

  def get_move(board, player)
    # return best move
    cloned_board = board.grid.clone
    ply = 0
    return first_move(cloned_board) if first_move?(cloned_board,ply)
    board_hash = Hash[(0...board.grid.size).zip board.grid]
    empty_spaces_on_board = board_hash.select{ |k,v| v == '+' }.keys  

    empty_spaces_on_board.each do |space|
      #binding.pry
      if score_a_move(cloned_board,player) != nil
        if score_a_move(cloned_board,player)[0] === 1
          return score_a_move(cloned_board,player)[1]
        elsif score_a_move(cloned_board,player)[0] === -1
          return score_a_move(cloned_board,player)[1]
        else
          return space
        end
      else
        return space
      end
    end 
  end

  def score_a_move(board, player_symbol)
    # find best move
    opponent = switch_player(player_symbol)
    next_boards         = Array.new
    answers             = Array.new

    if draw?(board)
      return 0
    else
      ply=0
      #find all empty spaces on board 
      board_hash = Hash[(0...board.size).zip board]
      empty_spaces_on_board = board_hash.select{ |k,v| v == '+' }.keys 

      empty_spaces_on_board.each do |space|

        @cloned_board = board.clone
        @cloned_board[space] = player_symbol

        @enemy_board = board.clone
        @enemy_board[space] = opponent

        if three_in_a_row_win?(@cloned_board, player_symbol)
          return  1, space
        elsif three_in_a_row_win?(@enemy_board, opponent)
          return -1, space
        else
          next_boards << @enemy_board
          ply+=1
        end
      end

      if ply > 0
        next_boards.each do |nextboard|
          answers << score_a_board(nextboard, player_symbol)
        end
        return answers.detect{|element| answers.count(element) > 1}
      end

    end
  end

  def score_a_board(board, player_symbol)
    opponent = switch_player(player_symbol)

    if draw?(board)
      return 0
    else
      board_hash = Hash[(0...board.size).zip board]
      empty_spaces_on_board = board_hash.select{ |k,v| v == '+' }.keys 

      empty_spaces_on_board.each do |space|

        @cloned_board = board.clone
        @cloned_board[space] = player_symbol

        @enemy_board = board.clone
        @enemy_board[space] = opponent
        if three_in_a_row_win?(@cloned_board, player_symbol)
          return  1, space
        elsif three_in_a_row_win?(@enemy_board, opponent)
          return -1, space
        end
      end
    end
  end

  def draw?(board)
    board_array = board
    board_array.none? { |mark| mark == '+' }
  end

  def switch_player(player_symbol)
    player_symbol == 'X' ? 'O' : 'X'
  end
end
