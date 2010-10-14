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
     (file_size(file_name) / (1024.0 * 1024.0)).to_i
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
    @search_folders = @redis.smembers("airbrake:config:search_folders")
    erb :config
  end
  
  get '/destroy' do
    @redis.srem("airbrake:config:search_folders",params[:id])
    redirect "/config"
  end
  
  post '/config' do
    @redis.sadd("airbrake:config:search_folders", params[:search_folders])
    redirect "/config"
  end
  
  def find_files
    files = []
    
    search_folders = @redis.smembers("airbrake:config:search_folders") || Array.new
    
    search_folders.each do |path|
      if File.directory?(path)
        # Find any .avi files at this location
        result = Dir.glob(File.join(path, "**", "*.avi"))
        files << result
      end
    end

    files.flatten
  end
 
end
