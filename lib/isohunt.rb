class Isohunt < Domain
  
  @@domain = "http://isohunt.com"
  @@destination = ""
  
  def start
    File.join(@@domain, :torrents, "?ihq=#{@search}")
  end
  
  
  ##This needs a lot of writing
  def trajectory
    [
      [start, ""],
      [@@domain, "join_with:page.search(\"#serps tr td a\")[0][\"onclick\"].split(/,/)[1].gsub(/'/,'')"]
    ]
  end
  
#  def search
#    t = Torrent.new(@search, @url)
#  end
  
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
    torrents =  @@domain + torrent_page.search("a").select{|a| a["onclick"].to_s.match(regexp) != nil }[0]["onclick"].scan(regexp)[0].to_s
  end

  
  
end