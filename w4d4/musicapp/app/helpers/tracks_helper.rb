module TracksHelper
  def uglify(lyrics)
    lyrics.split("\n").map do |line|
      "\u266b " << line
    end.join("\n")
  end
end
