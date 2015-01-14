module ApplicationHelper

  def up_link(obj)
    a = case obj.class.name
    when "Artist"
      link_to "Index", artists_url
    when "Album"
      link_to obj.artist.name, artist_url(obj.artist)
    when "Track"
      link_to obj.album.name, album_url(obj.album)
    end
    "Up: #{a}".html_safe
  end

  def next_link(obj)
    a = link(seq(obj, 1))
    a ? "Next: #{a}".html_safe : ""
  end

  def prev_link(obj)
    a = link(seq(obj, -1))
    a ? "Previous: #{a}".html_safe : ""
  end

  private

  def link(obj)
    return nil if obj.nil?
    case obj.class.name
    when "Artist"
      link_to obj.name, artist_url(obj)
    when "Album"
      link_to obj.name, album_url(obj)
    when "Track"
      link_to obj.name, track_url(obj)
    end
  end

  def seq(obj, n)
    case obj.class.name
    when "Artist"
      list = obj.class.all
    when "Album"
      list = obj.class.where(artist_id: obj.artist_id)
    when "Track"
      list = obj.class.where(album_id: obj.album_id)
    end
    i = list.index(obj)
    return nil if i + n < 0
    list[i + n]
  end
end
