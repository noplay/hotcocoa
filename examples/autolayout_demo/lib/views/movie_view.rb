class MovieViewDemo

  MOVIE_URL = 'http://trailers.apple.com/movies/wb/harrypotterandthedeathlyhallowspart2/hp7part2-tlr2_720p.mov'

  def self.description
    'Movies'
  end

  def self.create
    autolayout frame: CGRectZero, constraint: {expand: [:width, :height]}, margin: 0, spacing: 0 do |view|
      mview = movie_view constraint: { expand: [:width, :height] },
                         controller_buttons: [:back, :volume],
                         fill_color: color(name: 'black'),
                         movie: movie(url: MOVIE_URL)
      view << mview
    end
  end

  DemoApplication.register self

end
