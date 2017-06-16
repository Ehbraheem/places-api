module RouteHelpers

	# extend self
	
	def self.base_path
		"/api/v1/"
	end

	def self.add_path base, path
		base = base.gsub /\/\z/, ""
		if path.respond_to? :each
			path.each {|p| base + "/" +  p }
		else
		 	base + "/" + path
		 end
	end

	def self.make_path path, root_path
		self.class.send(:define_method, "#{path.to_s.pluralize}_path".to_sym) do
			add_path(root_path, path.to_s.pluralize)
		end
		self.class.send(:define_method, "#{path}_path".to_sym) do |param=name|
			add_path(send("#{path.to_s.pluralize}_path"), param[0])
		end
	end

	paths_hash = {  :location => "base",  :category => "location", :place => "category" }


	paths_hash.each_pair do |path, root|
		make_path path, self.send("#{root}_path")
	end 

	def method_missing(meth, *args, &blk)
		match = meth.to_s.match /(.+?)_(.+)/
		# byebug
		case match[2]
		when "path"
			if RouteHelpers.respond_to? meth
				args.empty? ? RouteHelpers.send(meth) : RouteHelpers.send(meth, args)
			end
		else
			super
		end
		# byebug
		# super if !self.respond_to? meth
	end

end