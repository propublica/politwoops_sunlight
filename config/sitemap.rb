SitemapGenerator::Sitemap.create(:default_host => Settings[:sitemap_default_url],
                                 :include_root => false) do
  most_recent_twoop = DeletedTweet.order(:modified).first
  if most_recent_twoop
    add '/',
        :host => Settings[:sitemap_default_url],
        :changefreq => 'hourly',
        :priority => 1
  else
    add '/',
        :host => Settings[:sitemap_default_url],
        :changefreq => 'hourly',
        :lastmod => most_recent_twoop.modified,
        :priority => 1
  end

  add '/users',
      :host => Settings[:sitemap_default_url],
      :changefreq => 'weekly',
      :priority => 1

  Politician.all.each do |pol|
    add url_for(:host => Settings[:sitemap_default_url],
                :controller => 'politicians',
                :action => 'show',
                :user_name => pol.user_name),
        :changefreq => 'weekly'
  end

  Party.all.each do |party|
    add url_for(:host => Settings[:sitemap_default_url],
                :controller => 'parties',
                :action => 'show',
                :name => party.name),
        :changefreq => 'daily',
        :priority => 0.1
  end

  DeletedTweet.find_each do |twoop|
    add url_for(:host => Settings[:sitemap_default_url],
                :controller => 'tweets',
                :action => 'show',
                :id => twoop.id),
        :lastmod => twoop.modified,
        :priority => 0.9
  end
end
