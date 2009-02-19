class Isohunt < Domain
  
  @@domain = "http://isohunt.com"
  @@destination = ""
  
  def start
    File.join(@@domain, :torrents, "?ihq=#{@search}")
  end
  
  def trajectory
    [
      [start, ""],
      [@@domain, "join_with:page.search(\"#serps tr td a\")[0][\"onclick\"].split(/,/)[1].gsub(/'/,'')"]
    ]
  end
  
  def search
    t = Torrent.new(@search, @url)
  end
  
  def search(search_term, options={})
    puts "searching for #{search_term}"
    agent = agent = WWW::Mechanize.new
    search_url = start
    begin
      page = agent.get(url({:search=>search_term}.merge(options)))
    rescue
      puts "Url couldn't be reached"
    end
    torrent_page = agent.get construct_link(options[:site], page)
    regexp = Regexp.new("\/download[a-zA-Z0-9\/]+")
    torrent_link =  domain.to_s + torrent_page.search("a").select{|a| a["onclick"].to_s.match(regexp) != nil }[0]["onclick"].scan(regexp)[0].to_s
    torrent_contents = agent.get_file(torrent_link).to_s
    filename = search_term + ".torrent"
  if File.exist?(filename)
    download_torrent(filename)
  else
    f = File.open(filename,"w+")
    f.puts torrent_contents
    f.close
    system "sudo chmod 777 taken.torrent"
    download_torrent(filename)
  end
  end

  
  
end