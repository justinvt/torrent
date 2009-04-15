#!/usr/bin/ruby

require 'rubygems'
require 'mechanize'
require 'hpricot'

def url(options={})
  case options[:site].to_s
    when "isohunt" :  "http://isohunt.com/torrents/?ihq=#{options[:search].gsub(/[_ ]+/,"+")}"
  end
end

def construct_link(domain, page)
  case domain.to_s
    when "isohunt" :  "http://isohunt.com" + page.search("#serps tr td a")[0]["onclick"].split(/,/)[1].gsub(/'/,'')
  end
end

def download_torrent(file)
  command = "sudo ctorrent -e 12 -C 32 -p 6881 #{file}"
  puts command
  begin
    system command
  rescue
    system command
  end
end

def search(search_term, options={})
  #search_term = search_term.to_s.gsub(/[ _]+/,"+")
  puts "searching for #{search_term}"
  agent = agent = WWW::Mechanize.new
  search_url = url({:search=>search_term}.merge(options))
  domain = search_url.scan(/^http:\/\/[a-zA-Z0-9\.]+/)[0]
  puts "Using link #{search_url}"
  begin
    page = agent.get(url({:search=>search_term}.merge(options)))
  rescue
    puts "Url couldn't be reached"
  end
  torrent_page = agent.get(construct_link(options[:site], page))
  regexp = Regexp.new("\/download[a-zA-Z0-9\/]+")
  torrent_link =  domain.to_s + torrent_page.search("a").select{|a| a["onclick"].to_s.match(regexp) != nil }[0]["onclick"].scan(regexp)[0].to_s
  torrent_contents = agent.get_file(torrent_link).to_s
  torrent_dir = "/Users/justin/tmp/torrents"
  Dir.mkdir(torrent_dir) unless File.exists?(torrent_dir)
  filename = File.join(search_term.to_s.gsub(/[^a-zA-Z0-9]/,"_")  + ".torrent")
  system "cd #{torrent_dir}"
  if File.exist?(filename)
    download_torrent(filename)
  else
    f = File.open(filename,"w+")
    f.puts torrent_contents
    f.close
    system "sudo chmod 777 #{filename}"
    download_torrent(filename)
  end
  
end

search(ARGV[0].to_s, :site=>:isohunt)

