require "fileutils"
include FileUtils

class ConvertJob
  @queue = :convert
  
  def self.perform(params)
    if params['preset'] == "iPhone"
      root = "/media/arr/iPhoneMovies"
      preset = "iPhone & iPod Touch"
      output = File.join(root, File.basename(params['path'], File.extname(params['path']))) + ".m4v"
    elsif params['preset'] == "iPad"
      root = "/media/arr/iPadMovies"
      preset = "iPad"
      output = File.join(root, File.basename(params['path'], File.extname(params['path']))) + ".m4v"
    else
      raise "Couldn't guess a preset from #{params['preset']}"
    end
    
    # Run handbrake
    cmd = "/usr/bin/HandBrakeCLI -i '#{params['path']}' -o '#{output}' --preset=#{preset}"
    puts cmd; system cmd
    
  end
end