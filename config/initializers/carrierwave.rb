CarrierWave.configure do |config|

  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false

  config.cache_dir = "#{Rails.root}/tmp/uploads"

  if Rails.env.production?
    # config.storage :fog
    # config.fog_credentials = {}
  elsif Rails.env.development?
    config.storage :file

  elsif Rails.env.test?
    config.storage :file
    config.enable_processing = false

    Dir["#{Rails.root}/app/uploaders/*.rb"].each { |file| require file }

    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?
      klass.class_eval do
        def cache_dir
          "#{Rails.root}/spec/support/uploads/tmp"
        end

        def store_dir
          "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
      end
    end

  end

end
