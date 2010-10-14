require "rubygems"
require "sinatra/base"
require "resque"

class AirBrake < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/airbrake/views"
  set :public, "#{dir}/airbrake/public"
  set :static, true
  
  helpers do
    
    def file_size(file_name)
      File.size(file_name)
    end
    
    def file_size_in_mb(file_name)
      file_size(file_name) / (1024.0 * 1024.0)
    end
    
  end
  
  before do
    @redis = Redis.new
  end

  get "/" do
    @info = Resque.info
    @files = find_files
    erb :index
  end

  # Queue a conversion job
  post '/convert' do
    Resque.enqueue(Convert, params)
    redirect "/"
  end
  
  get "/stats" do
    @redis.info.to_s
  end
  
  # List resque jobs
  get '/jobs' do
    
  end
  
  get '/config' do
    @search_folders = @redis.lrange("airbrake:config:search_folders",0,-1)
    erb :config
  end
  
  post '/destroy_it' do
    @redis.ltrim("airbrake:config:search_folders",0,0)
    @redis.del("airbrake:config:search_folders")
    redirect "/config"
  end
  
  post '/config' do
    @redis.lpush("airbrake:config:search_folders", params[:search_folders])
    redirect "/config"
  end
  
  def find_files
    files = []
    
    search_folders = @redis.lrange("airbrake:config:search_folders",0,-1) || Array.new
    
    search_folders.each do |path|
      if File.directory?(path)
        # Find any .avi files at this location
        result = Dir.glob(File.join(path, "**", "*.avi"))
        files << result
      end
    end
    
    files.flatten!
  end
 
end
