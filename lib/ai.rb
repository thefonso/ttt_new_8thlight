class AI
  attr_accessor :player_symbol

  # holds what piece it is and returns a move
  # TODO - make it so IOtower ask end user for symbol selection
  # hold setting for this in external config.rb file as so ([AI, 'O'] )
  # TODO - displayed by IOtower in future refactor
  def initialize(io = Kernel)
    @io = io
  end

  def make_move
    @io.puts "AI takes move..."
    @io.gets.chomp.to_i
  end
end
