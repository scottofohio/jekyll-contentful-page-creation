require 'contentful'
require 'net/http'
require 'json'

  
  SPACE_ID = 'SPACE ID'
  ACCESS_TOKEN = 'ACCESS TOKEN'
  $client = Contentful::Client.new(
    space: SPACE_ID,
    access_token: ACCESS_TOKEN,
    dynamic_entries: :auto
  )   
  
  def ContentType(type, folder)
    # type and folder variables are strings.  
    type_of_content = $client.entries(content_type: type)
    
    Dir.foreach(folder) { |f| 
      fn = File.join(folder, f); File.delete(fn) if f != '.' && f != '..'
    }
    
    type_of_content.each do |content|
      if(content.title == "Home")
        file_name = 'index'   
      else 
        file_name = content.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      end
      File.open(folder +"/" + file_name + ".md", "w") { |f| 
        f << "---\n"
        f << "layout: default \n"
        if defined?(content.title)
          f << "title: " + content.title + "\n"
          f << "slug: " + content.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "\n"
        end
        if defined?(content.page_url)
          f << "permalink: " + content.page_url + "\n"  
        end 
        f << "---\n" 
      }
    end
  end
  ContentType('page', '_pages')
  ContentType('brands', '_brands')

