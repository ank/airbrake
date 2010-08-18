require 'rubygems'
require 'sinatra/base'
require "resque"
require File.dirname(__FILE__) + "/convert_job"

class DropFolders < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/drop_folders/views"
  set :public, "#{dir}/drop_folders/public"
  set :static, true

  set :search_path, "/media/arr/Movies"
  
  helpers do
    def file_size(file_name)
      File.size(file_name)
    end
  end

  # This can display a nice UI.
  #
  get "/" do
    @files = Dir.glob(File.join(options.search_path, "**", "*.avi"))
    @info = Resque.info
    erb :index
  end

  # This POST allows your other apps to control the service.
  #
  post '/convert' do
    Resque.enqueue(ConvertJob, params)
    redirect "/"
  end
 
end
