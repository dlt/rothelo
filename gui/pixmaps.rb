require 'gtk2'

class Pixmaps
  def initialize(window)
    @pix, @mask	= {}, {}
    #paths = ["/home/dlt/projects/ruby/rothelo/gui/images/"]
    paths = [File.dirname(__FILE__) + '/images/']
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

  def create_pixmap(id)
    Gtk::Image::new(@pix[id], @mask[id])
  end
end
