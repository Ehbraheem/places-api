require "database_cleaner"

namespace :clean_db do

	def make_object obj
		Object.const_get obj.to_s.classify
	end

	desc "Clean DB"
	task :cleaner do
		{:active_record=> [:landmarks, :locations, :categories], :mongoid => [:place]}.each_pair do |name, val| 
			val.each do |e| 
				Rake::Task['clean_db:start_cleaning'].reenable
				Rake::Task['clean_db:start_cleaning'].invoke(name,"truncation",e)
			end
		end
	end
	

	desc "Start Cleaning"
	task :start_cleaning, [:orm, :strategy, :collection] => [:setup_db] do |t, args|
		puts "removing #{make_object(args.collection).count} #{args.to_s.classify}"
	end

	desc "Setup cleaner"
	task :setup_db, [:orm, :strategy, :collection]  do |t, args|
		args.with_defaults(:orm=>:mongoid, :strategy=>:truncation, :collection=>:landmark)
		puts "Setup DB cleaner"
		DatabaseCleaner[args.orm].clean_with(args.strategy.to_sym, {:only=>%W(#{args.collection.to_sym})})
	end

	# desc "Clean DB"
	# task :clean do
		# {:active_record=> [:landmark, :location, :category], :mongoid => [:place]}.each_pair do |name, val| 
		# 	val.each { |e| Rake::Task[:start_cleaning].invoke(name, "truncation", e) }
		# end
	# end
	
end