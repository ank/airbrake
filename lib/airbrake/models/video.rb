require "pathname"
require "ohm"
#
# This class stores video metadata and
# defines the async conversion
#

class Video < Ohm::Model
  attribute :name
  attribute :path  # the actual path
  attribute :size
  attribute :format
  
  index :path
  
  def validate
    assert_present :path
  end
  
  def async_convert(preset)
    Resque.enqueue(Convert, self.id, preset)
  end
  
  def self.reload!
    flush
    
    search_paths.each do |path|
      Pathname.glob(File.join(path, "**", "*.avi")).each do |p|
        video = self.create(:path => p, :name => p.basename, :size => p.size)
        video.save
      end
    end
  end
  
  # Flush the existing dataset
  def self.flush
    Video.all.each{|v| v.delete }
  end
  
  def self.search_paths
    Video.db.smembers("airbrake:config:search_folders")
  end
  
  def size_mb
    (self.size.to_i / (1024.0 * 1024.0)).to_i
  end
  
  def resque
    Resque
  end
  
end

# Video.reload!