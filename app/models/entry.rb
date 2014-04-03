class Entry < ActiveRecord::Base

  attr_accessible :name, :email
  has_attached_file :media, :styles => { :thumb => "180x115#" }

  # Validations on file types and sizes
  validates_attachment_content_type :media, :content_type => [/image/, /video/], :message => 'File must either be an image or a video'
  validates_attachment_size :media, :less_than => 50.megabyte

  # Trigger video encoding after creating the entry
  after_create :encode_with_zencoder

  # Makes sure that thumbnails are only generated for images and not videos
  before_media_post_process :thumbnail_only_images

  # Only create thumbnails for image uploads
  def thumbnail_only_images
    if (media.content_type =~ /video/)
      return false
    end 
  end 

  # Send videos off to Zencoder to be converted to easily-playable mp4s
  def encode_with_zencoder
    if (self.media.present? and self.media_content_type.include?('video'))
      response = Zencoder::Job.create({
          :api_key => AppEnv['ZENCODER_API_KEY'],
          :input => "s3://#{AppEnv['S3_BUCKET']}#{self.media.path}",
          :outputs => {
              :format => "mp4",
              :public => true,
              :thumbnails => {
                  :aspect_mode => "crop",
                  :base_url => "s3://#{AppEnv['S3_BUCKET']}/video-thumbnails/",
                  :filename => "#{self.id}",
                  :number => 1,
                  :public => true,
                  :size => "180x115"
              },  
              :base_url => "s3://#{AppEnv['S3_BUCKET']}/entries/",
              :filename => "#{self.id}.mp4"
          }   
      })  

      self.zencoder_job_id = response.body['id']
      self.converted_clip_url = response.body['outputs'][0]['url']
      self.converted_thumb_url = "http://#{AppEnv['S3_BUCKET']}.s3.amazonaws.com/video-thumbnails/#{self.id}.png"
      self.save
    end 
  end
end
