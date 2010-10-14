require "fileutils"
require "pathname"

class Convert
  @queue = :airbrake

  def self.perform(params)
    case params['preset']
    when "iPhone"
      preset = "iPhone & iPod Touch"
    when "iPad"
      preset = "iPad"
    else
      preset = "Classic"
    end
    
    output = output_path(params['preset'], params['path'])
    
    # Run handbrake
    cmd = "/usr/bin/HandBrakeCLI -i '#{params['path']}' -o '#{output}' --preset=#{preset}"
    puts "Command is: #{cmd}"
    system cmd
  end
  
  def self.output_path(preset, path)
    root = "/media/arr/" + preset + "Movies"
    File.join(root, File.basename(path, File.extname(path))) + ".m4v"
  end
end
