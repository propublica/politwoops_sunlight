module TweetsHelper
  def format_tweet(tweet)
    # return tweet.content
    
    details = tweet.details
    return tweet.content unless details.has_key?('entities')
    return tweet.content if details['entities'].empty?

    content = tweet.content
    
    entities = []
    entity_types = ['urls', 'user_mentions', 'hashtags']
    entity_types.each do |entity_type|
      next if not details['entities'].has_key?(entity_type)
      
      details['entities'][entity_type].each do |entity_info|
        entity = {
          :entity_start => entity_info['indices'][0],
          :entity_stop => entity_info['indices'][1] 
        }
        if entity_type == 'urls'
          entity[:source_text] = entity_info['url']
          entity[:display_text] = entity_info['display_url'].nil? ? entity_info['url'].sub('http://', '') : entity_info['display_url']
          entity[:url] = entity_info['expanded_url'].nil? ? entity_info['url'] : entity_info['expanded_url']
        elsif entity_type == 'user_mentions'
          entity[:source_text] = '@%s' % entity_info['screen_name']
          entity[:display_text] = entity[:source_text]
          entity[:url] = 'http://twitter.com/%s' % entity_info['screen_name']
        else
          entity[:source_text] = '#%s' % entity_info['text']
          entity[:display_text] = '#%s' % entity_info['text']
          entity[:url] = 'https://twitter.com/search/%%23%s' % entity_info['text']
        end
        entity[:result] = link_to entity[:display_text], entity[:url], :target => '_new'
        entities << entity
      end
    end
    
    offset = 0
    entities.sort_by {|e| e[:entity_start]}.each do |entity|
      old_length = entity[:entity_stop] - entity[:entity_start]
      content.slice!(entity[:entity_start] + offset, old_length)
      content = content.insert(entity[:entity_start] + offset, entity[:result])
      new_length = entity[:result].length
      offset += (new_length - old_length)
    end
        
    return content
  end
end
