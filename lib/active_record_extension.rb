class ActiveRecord::Base

	def self.has_many_documents association_name


		define_method "#{association_name}" do
			"#{association_name.to_s.singularize}".classify.constantize.where("#{self.class.name.underscore}_id"=> id)
		end

		define_method "#{association_name}=" do |association|
			# return self.send(association_name) if association.empty?
			if association.respond_to? :map
				association.each do |associate| 
				 	associate.send("#{self.class.name.underscore}_id=", id)
				 	associate.save
				 end
			else
				association.send("#{self.class.name.to_s.underscore}_id=", id)
				association.save
			end
			self
		end
		# %W(:<< :=).eac
		# self."#{association_name}".define_method :<< do |association|
		# 	self.send("#{association_name}=", association)
		# end

		define_method :method_missing do |method_name, *args, &blk|
			# byebug
			match = method_name.to_s.match /(.*?)([?=!]*?)$/
			super(method_name, *args, &blk) if !(self.respond_to? match[1].pluralize)
			case match[2]
			when '='
				self.send("#{match[1].pluralize}=", args)
			when ""
				self.send("#{match[1].pluralize}")
			else
				super(method_name, *args, &blk)
			end
		end

		# message_sender = lambda { |msg,*args| !(args.empty?) ? self.send(msg, *args) : self.send(msg) }
		# construct_method_name  = lambda { |*args| return (args[1].nil? ? "#{args[0].pluralize}" : "#{args[0].pluralize}=") }

		# class_eval %< 
		# 	def #{association_name}
		# 		#{association_name.to_s.singularize.classify}.where(#{name.underscore}_id: id)
		# 	end

		# 	def #{association_name}= association
		# 		if association.empty? || !association
		# 			byebug
		# 			return
		# 		elsif association.respond_to? :map
		# 			association.each do |associate| 
		# 		 		associate.send(#{self.class.name.downcase}_id, self.id)
		# 		 	end
		# 		 else
		# 		 	association.send(#{self.class.name.to_s.downcase}_id, self.id)
		# 		 end
		# 	end
		# 	def method_missing(method_name, *args, &blk)
		# 		self.#{association_name}=(args)
		# 	end

		# >

	end

end
