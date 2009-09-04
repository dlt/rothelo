require 'gtk2'
require File.dirname(__FILE__) + '/rbutton'
require File.dirname(__FILE__) + '/pixmaps'
require File.dirname(__FILE__) + '/../game/rothelo'

$debug = true
class Gui
	attr_reader :game, :table, :pixmaps, :buttons

	def initialize
		@game 	 = Rothelo::Game.new(self, 2 => {:intelligence => :Dummy}, :first => 1)
		#@game 	 = Rothelo::Game.new(self, :first => 1)
		@buttons = []
		init_window

		@window.show
		@window.show_all    
		@game.init
		Gtk.main
	end
	
	def refresh
		game.board.each_field do |x, y, field|
			button = get_button(x, y)
			button.set_pixmap button.pixtype(field)
		end
	end
	
	private
	def get_button x, y
		buttons.detect {|b| b.x == x && b.y == y}	
	end

	def init_window
		Gtk.init
		@window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
		@window.set_window_position(Gtk::Window::POS_CENTER)
		@window.set_default_size(500, 500)
		init_window_signals 
		@window.show
		@pixmaps = Pixmaps.new(@window.window)
		@table 	 = Gtk::Table.new(10, 8, false)
		init_table 
	end  

	def init_table
		box	= Gtk::HBox.new(true, 5)
		create_difficulty_selector box
		table.attach(box, 0, 8, 9, 10)
		@window.add table

		game.board.each_field do |x, y, field|
			button = RButton.new(x, y, pixmaps, field)
			button.signal_connect('clicked') do |button| 
				game.process button
			end

			table.attach(button, x, x + 1, y, y + 1)
			buttons << button
		end
		table.show_all
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
end

gui = Gui.new
