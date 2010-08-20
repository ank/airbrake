require 'rubygems'
require 'sinatra/base'
require "resque"
require File.dirname(__FILE__) + "/convert_job"

class DropFolders < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/drop_folders/views"
  set :public, "#{dir}/drop_folders/public"
  set :static, true
  
  helpers do
    def file_size(file_name)
      File.size(file_name)
    end
  end
  
  before do
    @redis = Redis.new
  end

  # This can display a nice UI.
  #
  get "/" do
    @info = Resque.info
    @files = find_files
    erb :index
  end

  # This POST allows your other apps to control the service.
  #
  post '/convert' do
    Resque.enqueue(ConvertJob, params)
    redirect "/"
  end
  
  get "/stats" do
    @redis.info.to_s
  end
  
  get '/jobs' do
    
  end
  
  get '/config' do
    @search_folders = @redis.lrange("drop_folders:config:search_folders",0,-1)
    erb :config
  end
  
  post '/destroy_it' do
    @redis.ltrim("drop_folders:config:search_folders",0,0)
    @redis.del("drop_folders:config:search_folders")
    redirect "/config"
  end
  
  post '/config' do
    @redis.lpush("drop_folders:config:search_folders", params[:search_folders])
    redirect "/config"
  end
  
  def find_files
    files = []
    search_folders = @redis.lrange("drop_folders:config:search_folders",0,-1) || Array.new
    search_folders.each do |path|
      if File.directory?(path)
        result = Dir.glob(File.join(path, "**", "*.avi"))
        files << result
      end
    end
    files.flatten!
  end
 
end
