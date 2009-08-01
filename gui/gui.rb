# handles the gui interfaces and maps user actions
# to logic handling classes

require 'gtk2'
require 'rbutton'
require 'pixmaps'
require '../game/board'
require '../game/rothelo'

class Gui
  def initialize
		@rothelo = Rothelo::Game.new
		init_window
  end
	
	def init_window
    Gtk.init
    @window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
    @window.set_window_position(Gtk::Window::POS_CENTER)
    @window.set_default_size(500, 500)
    init_window_signals 
    @window.show
    init_table 
	end  

  def init_table
    @table = Gtk::Table.new(10, 8, false)
    @window.add @table
    pixmaps = Pixmaps.new(@window.window)
    box = Gtk::HBox.new(true, 5)
    create_difficulty_selector box

    @table.attach(box, 0, 8, 9, 10)
		@rothelo.board.each_field do |field, x, y|
      button = RButton.new(x, y, pixmaps, field)
   		button.signal_connect('clicked') do |button| 
     		@rothelo.process button 
	    end
      @table.attach(button, x, x + 1, y, y + 1)
		end
 	end
	
	def create_difficulty_selector(box)
    r1 = Gtk::RadioButton.new(nil, 'easy')
    r2 = Gtk::RadioButton.new(r1, 'hard')
    r1.signal_connect('toggled') do
      if r1.active?
		    puts 'Implement - Easy selected!'
      end
    end

    r2.signal_connect('toggled') do
      if r2.active?
		    puts 'Implement - Hard selected!'
      end
    end
    box.add(Gtk::Label.new('Difficulty: '))
    box.add(r1)
    box.add(r2)
	end 
 
  def init_window_signals
    @window.signal_connect('delete_event') do
      false
    end
    @window.signal_connect('destroy') do
      exit
    end
  end
  
  def show
    @table.show_all
    @window.show
    @window.show_all    
    Gtk.main
  end
end

gui = Gui.new
gui.show
