# Disable assets:precompile
Rake::Task["assets:precompile"].clear
namespace :assets do
  task 'precompile' do
      puts "Skipping assets"
  end
end
