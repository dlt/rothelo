require 'gtk2'

# class Pixmaps: utility class that manages the pixmaps for the gamefield buttons
class Pixmaps
  def initialize(window)
    @pix = Hash.new
    @mask = Hash.new
    paths = ["/home/dlt/projects/ruby/rothelo/gui/images/"] # additional search paths
    prefix = ''
    begin
      @pixmaps = {:player1 => 'tac.xpm', :player2 => "tic.xpm", :empty => 'toe.xpm'}
      @pixmaps.each do |id, fn|
    	@pix[id], @mask[id] = Gdk::Pixmap::create_from_xpm(window, nil, prefix + fn)
    end
    rescue ArgumentError
      if paths.length > 0 
      	prefix = paths.delete_at(0)
	      retry
      end
      raise 
    end
  end

  # id should be "player1", "player2" or "empty"
  def create_pixmap(id)
    Gtk::Image::new(@pix[id], @mask[id])
  end
end
