if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # configuration for Amazon S3
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_ACCESS_KEY'] || 'NOT_SET',
      aws_secret_access_key:  ENV['S3_SECRET_KEY'] || 'NOT_SET',
      region:                 ENV['S3_REGION'] || 'NOT_SET'
    }
    config.fog_directory =    ENV['S3_BUCKET'] || 'NOT_SET'
  end
end
