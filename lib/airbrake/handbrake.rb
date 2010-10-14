module Handbrake
  
  def Handbrake.presets
    presets = `HandBrakeCLI --preset-list`.scan(/\+\s(\w+)\:/).flatten
  end
  
end