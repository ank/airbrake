require 'helper'
require "airbrake"

class TestAirBrake < Test::Unit::TestCase
  
  def setup
    
  end
  
  def teardown
    Video.all.map{|v| v.delete }
  end
  
  def test_create_video
    video = Video.create :path => "/path/to/video.avi"
    assert_equal("/path/to/video.avi", video.path)
  end
  
  def test_video_created
    Video.create :path => "/path/to/video.avi"
    video = Video.find(:path => "/path/to/video.avi")
    refute_nil(video, "A Video matching video.avi should be created")
  end
  
  def test_list_video
    video = Video.create :path => "/path/to/video.avi"
    videos = Video.all
    assert_equal(1, videos.size)
  end
  
  def test_redis_db
    assert_kind_of(Redis, Video.db)
  end
  
end
