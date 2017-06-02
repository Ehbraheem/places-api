module ModelsHelper


	def put_new_value hash, newObject
		# byebug
		newObject.update_attributes(hash)
		newObject
	end

	def create_random_place
		Place.new({id: rand(1..30000), 
										formatted_address: "23, Foo street",
										location: ["Lagos"],
										types: ["Foo"],
										name: "Foo #{rand(1..3000)}",
										rating: 7.8,
										icon: "foo.png",
										place_id: "234 #{rand(1..3000)}",
										references: "good",
										geometry: Point.new([rand(1..3000),rand(1..3000)]).mongoize,
										opening_hours: Availability.new({open_now: true, weekdays_text: []}).mongoize,
										})
	end

	def duplicate_fields object, field

		expect(object.save).to be false

		error_object = object.errors
		expect(error_object).to respond_to :messages
		expect(error_object.messages).to have_key field
		expect(error_object.messages[field]).to_not be_empty
		expect(error_object.messages[field]).to include /already taken/

	end


	RSpec.shared_examples "Custom DB type" do |object|

		describe "valid #{object.to_s.classify}" do

			it "not nil" do
				# byebug
				expect(object).to_not be_nil
				expect(object.nil?).to eq false
			end

			it "has no methods" do
				method = object.methods false
				expect(method).to eq []
				expect(method).to be_empty
			end
		end

	end

	RSpec.shared_examples "tranform custom type to DB type" do |object|
		
		describe "to MongoDB transformation" do
		
			it "can convert to MongoDB representation" do
				expect(object).to respond_to :mongoize
				expect(object.mongoize).to have_key :type
				expect(object.mongoize[:type]).to eq object.class.name
				# expect(object.mongoize).to 
			end

			it "has important .methods for transformation" do
				expect(object.class).to respond_to :mongoize
				expect(object.class).to respond_to :demongoize
				expect(object.class).to respond_to :evolve
			end

			it "can tranform any form to MongoDB form" do
				object_object = object
				hash_object = object.mongoize
				nil_object = nil

				expect(object.class.mongoize(hash_object)).to eq object.mongoize
				expect(object.class.mongoize(object)).to eq object.mongoize
				expect(object.class.mongoize(nil_object)).to eq nil
			end
		end

	end

	RSpec.shared_examples "Valid type" do |object, methods|

		describe "valid Point instance" do
			# byebug

			object = Object.const_get(object.to_s.classify).new(nil)

			it "respond to getter \##{methods.join(',')}" do
				methods.each do |method|
					expect(object).to respond_to method.to_sym
				end
			end

			it "does not respond to setter \##{methods.join(',')}" do
				methods.each do |method|
					expect(object).to_not respond_to "#{method}=".to_sym
				end
			end

		end

	end

	RSpec.shared_examples "duplicate field" do |field|

		it "prevent save for non-unique #{field} field" do

			persistable = create_random_place

			persistable.save

			# Sanity check
			expect(persistable.persisted?).to be true
			expect(persistable.errors.messages).to be_empty

			# byebug

			another_place = put_new_value({field => persistable[field]},
			 								create_random_place)

			duplicate_fields another_place, field

		end

	end

	RSpec.shared_examples "duplicate of unique fields" do |fields|
		
		it "prevent save of all non-unique fields" do
			
			persistable = create_random_place

			persistable.save

			# Sanity check
			expect(persistable.persisted?).to be true
			expect(persistable.errors.messages).to be_empty

			# byebug
			another_place = put_new_value(fields.inject({})  do |hash, var|   
															hash[var] = persistable[var]
															hash 
														end,
			 								create_random_place)

			fields.each do |f|
				duplicate_fields another_place, f
			end

			error_object = another_place.errors
			expect(error_object.full_messages.length).to be > 2

		end
	end

	
end