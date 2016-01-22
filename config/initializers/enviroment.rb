# Load environment params
ENV['SITE_HOST'] = 'http://thatsaboy.dev' if ENV['SITE_HOST'].nil?
ENV['SITE_RECOVERY_LINK'] = ENV['SITE_HOST'] + '/recovery' if ENV['SITE_RECOVERY_LINK'].nil?

ENV['UPLOAD_HOST'] = 'http://thatsaboy.dev' if ENV['UPLOAD_HOST'].nil?
ENV['UPLOAD_FOLDER'] = "#{Rails.root}/public" if ENV['UPLOAD_FOLDER'].nil?

ENV['POSTGRES_PASSWORD'] = 'postgres' if ENV['POSTGRES_PASSWORD'].nil?
ENV['POSTGRES_USER'] = 'postgres' if ENV['POSTGRES_USER'].nil?
