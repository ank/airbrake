require "rubygems"
require "sinatra/base"
require "resque"
require "airbrake"
require "airbrake/models/video"

class AirBrake < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))

  set :views,  "#{dir}/airbrake/views"
  set :public, "#{dir}/airbrake/public"
  set :static, true
  
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def current_section
      url request.path_info.sub('/','').split('/')[0].downcase
    end

    def current_page
      url request.path_info.sub('/','')
    end

    def url(*path_parts)
      [ path_prefix, path_parts ].join("/").squeeze('/')
    end
    alias_method :u, :url

    def path_prefix
      request.env['SCRIPT_NAME']
    end

    def file_size(file_name)
      File.size(file_name)
    end
    
    def file_size_in_mb(file_name)
     (file_size(file_name) / (1024.0 * 1024.0)).to_i
    end
    
    def show(page, layout = true)
      begin
        erb page.to_sym, {:layout => layout}, :resque => Resque
      rescue Errno::ECONNREFUSED
       erb :error, {:layout => false}, :error => "Can't connect to Redis! (#{Resque.redis_id})"
      end
     end
  end
  
  before do
    @redis = Redis.new
  end

  get "/" do
    @videos = Video.all
    erb :index
  end

  # Queue a conversion job
  post '/convert' do
    puts '[Params]'
    p params
    videos = params["videos"]
    videos.each do |v|
      video = Video[v]
      p video
      video.async_convert(params["preset"])
    end
    # Resque.enqueue(Convert, params)
    redirect "/"
  end
  get "/videos" do
    @videos = Video.all
    erb :index
  end
  
  # get "/stats" do
  #   @keys = Video.db.keys
  #   @redis.info.to_s
  #   erb :stats
  # end
  
  get "/stats/:id" do
    show :stats
  end

  get "/stats/keys/:key" do
    show :stats
  end
  
  # List resque jobs
  get '/working' do
    erb :working
  end
  
  get '/config' do
    @search_folders = Video.db.smembers("airbrake:config:search_folders")
    erb :config
  end
  
  get '/queues/:id' do
    erb :queues
  end
  
  post '/config' do
    # get rid of empty parameters
    dirs = params[:search_folders].reject{|p| p.empty? }
    p "Adding Dirs: #{dirs}"
    Video.db.sadd("airbrake:config:search_folders", dirs)
    Video.reload!
    
    redirect "/config"
  end
  
  get '/destroy' do
    Video.db.srem("airbrake:config:search_folders",params[:id])
    redirect "/config"
  end
  
  get "/stats.txt" do
    info = Resque.info

    stats = []
    stats << "resque.pending=#{info[:pending]}"
    stats << "resque.processed+=#{info[:processed]}"
    stats << "resque.failed+=#{info[:failed]}"
    stats << "resque.workers=#{info[:workers]}"
    stats << "resque.working=#{info[:working]}"

    Resque.queues.each do |queue|
      stats << "queues.#{queue}=#{Resque.size(queue)}"
    end

    content_type 'text/plain'
    stats.join "\n"
  end

  def resque
    Resque
  end

end
