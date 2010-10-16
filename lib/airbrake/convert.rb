require "fileutils"
require "pathname"
require "airbrake/models/video"

class Convert
  @queue = :airbrake

  def self.perform(video_id, preset="iPad")
    case preset
    when "iPhone"
      preset = "iPhone & iPod Touch"
    when "iPad"
      preset = "iPad"
    else
      preset = "Classic"
    end
    
    video = Video[video_id]
    output = output_path(preset, video.path)
    
    # Run handbrake
    cmd = "/usr/bin/HandBrakeCLI -i '#{video.path}' -o '#{output}' --preset=#{preset}"
    puts "Command is: #{cmd}"
    system cmd
  end
  
  def self.output_path(preset, path)
    root = "/media/arr/" + preset + "Movies"
    File.join(root, File.basename(path, File.extname(path))) + ".m4v"
  end
end
