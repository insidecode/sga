namespace :flexigrid do

	desc "Copy javascripts, stylesheets and images to public"
	task :install do
	  Rake::Task[ "flexigrid:uninstall" ].execute
    %w(javascripts stylesheets).each do |dir|
      source = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public', dir))
      target = File.join(Rails.root.to_s, 'public', dir, 'flexigrid')
      FileUtils.cp_r(source, target, :verbose => true)
    end
	end

  desc 'Remove javascripts, stylesheets and images from public'
  task :uninstall do
    %w(javascripts stylesheets images).each do |dir|
      target = File.join(Rails.root.to_s, 'public', dir, 'flexigrid')
      FileUtils.rm_rf(target, :verbose => true)
    end
  end
end