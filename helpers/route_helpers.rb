module RouteHelpers

	# extend self
	
	def self.base_path
		"/api/v1/"
	end

	def self.add_path base, path
		absolute_path = ""
		if path.respond_to? :each
			base = base.gsub /\/\z/, ""
			path.each do |p|
				p = p.gsub(/\s/, "+").downcase
				absolute_path += base + "/" +  p
			end
		else
			base = base.gsub /\/\z/, ""
		 	absolute_path += base + "/" + path
		 end
		 absolute_path
	end

	def self.make_path path, root_path
		self.class.send(:define_method, "#{path.to_s.pluralize}_path".to_sym) do |param=nil|
			# byebug
			if param.nil?
				# byebug
				add_path(root_path, path.to_s.pluralize)
			else
				add_path(add_path(root_path, param), path.to_s.pluralize)
			end
			# param.nil? ? add_path(root_path, path.to_s.pluralize) : add_path(add_path(root_path, param), path.to_s.pluralize)
		end
		self.class.send(:define_method, "#{path}_path".to_sym) do |param=nil|
			# byebug
			add_path(send("#{path.to_s.pluralize}_path"), param)
		end
	end

	paths_hash = {  :location => "base",  :category => "locations", :place => "categories" }


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