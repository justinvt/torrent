require 'rubygems'
require 'mechanize'
require 'hpricot'

class Domain
  
  @@domain = ''
 # @@torrent_id = TORRENT_DIRECTORY || File.dirname(__FILE__)

  def initialize(search_terms)
    @url = @@domain
  end
  
  def start
    File.join(@@domain)
  end
  
  def primary_url(search_terms)
  end
  
  def search
  end
  
  def follow_trajectory
  end

end