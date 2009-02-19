class Torrent
  
  @@path =  "~/.torrents"
  
  def initialize(search, url)
    @search = search
    @url = url
  end
    
  def filename
    [@search.gsub(/\W/,"_"), "torrent"].join(".")
  end
  
  def full_path
    Dir.mkdir(@@path) unless File.exist?(@@path)
    File.join(@@path, filename)
  end
  
  def torrent
    if File.exist?(torrent_name)
      File.open(torrent_name, "r+")
    else
      File.open()
    end
  end
  
  def download
  end
  
  
end