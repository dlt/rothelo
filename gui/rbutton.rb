require 'gtk2'
require File.dirname(__FILE__) + '/../game/rothelo'

class RButton < Gtk::Button
	attr_reader :x, :y, :player

  def initialize(x, y, pixmaps, type = 0)
    super()
		@x = x
		@y = y
		@player  = type
    @pixmaps = pixmaps
    set_pixmap pixtype(type)
  end
  
  def set_pixmap(id)
    #puts 'setando pixmap ' + id.to_s + ' p botao x/y ' + x.to_s + ' ' + y.to_s
    if @pixbutton
      remove(@pixbutton)           
      @pixbutton.destroy
    end

    @pixbutton = @pixmaps.create_pixmap(id)
    add(@pixbutton)               
    @pixbutton.show
    @pixid = id
  end

	def pixtype(id)
		return :player1 if id == 1
		return :player2 if id == 2
		:empty
	end
end
