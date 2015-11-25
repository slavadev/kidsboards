# Load environment params
ENV['SITE_HOST'] = 'http://thatsaboy.dev' if ENV['SITE_HOST'].nil?
ENV['SITE_RECOVERY_LINK'] = ENV['SITE_HOST'] + '/recovery' if ENV['SITE_RECOVERY_LINK'].nil?