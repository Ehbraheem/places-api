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

	def send_message obj, msg, param=nil
		param ? obj.send(msg.to_sym).send(param) : obj.send(msg.to_sym)
	end

	def make_hash_from_array arr, obj=nil
		arr.inject({}) do |hash, elem|
			hash[elem] = obj.has_key? elem.to_sym ? obj[elem.to_sym] : obj
			hash
		end
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

		describe "valid #{object.to_s.classify} instance" do
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
			another_place = put_new_value(make_hash_from_array(fields, persistable),
			 								create_random_place)

			fields.each do |f|
				duplicate_fields another_place, f
			end

			error_object = another_place.errors
			expect(error_object.full_messages.length).to be > 2

		end
	end

	RSpec.shared_examples "build valid object" do |object, fields|
		
		context "build valid #{object.to_s.classify}" do

			let(:obj) { FactoryGirl.build(:object) }
			
			it "default Location created with random name" do
				expect(obj).to_not be_nil
				expect(obj).to be_a_kind_of object.to_s.classify

				fields.each do |field|
					expect(obj).to have_field field.to_sym
					expect(obj).to respond_to field
					expect(obj).to respond_to "#{field}=".to_sym
				end
				
			end

			it "create #{object.to_s.classify} with non-nil #{fields.join(',')}" do
				fields.each do |field|
					subject { send_message obj, field }
					is_expected.to_not be_nil
					is_expected.to_not be_empty
					expect(subject.length).to be > 1
					is_expected.to include /[a-z]/i
				end
				
			end

		end
	end


	RSpec.shared_examples "build invalid object" do |object, fields|
		
		context "build invalid #{object.to_s.classify}" do

			let(:obj) { FactoryGirl.build(:object, make_hash_from_array(fields)) }
			
			it "fails to validate" do
				fields.each do |field|
					subject { send_message obj, field }

					is_expected.to be_nil
				end
				expect(obj).to_not be_valid
			end

			it "fails to save" do
				expect(obj.save).to be false
				expect(obj).to have_field :errors
				expect(obj).to_not be_valid
			end

			it "provides error message" do
				expect(obj).to respond_to :errors
				expect(obj.errors).to_not be_nil
				expect(obj.errors).to respond_to :messages
				fields.each do |field|
					expect(obj.errors.messages).to include(field.to_sym =>["can't be blank"])
				end
			end
		end
	end

	RSpec.shared_examples "Associations" do |object, association|

		let(:obj) { FactoryGirl.create(object, "with_#{association}".to_sym) }

		subject { send_message(obj, association.pluralize) }
		
		context "can walk through association" do
			
			it "can access categories information" do
				expect(obj).to respond_to association.pluralize.to_sym
				is_expected.to_not be_nil
				expect(obj).to have_field association.pluralize.to_sym
			end

			it "can have more than one #{association}" do
				expect(subject.count).to be >= 1
				expect(subject.to_a).to be >= 1
			end

		end

		context "can build association" do

			let(:associated_obj) { FactoryGirl.attributes_for(association.to_sym) }
			
			it "can build new category" do
				expect(subject.build(associated_obj)).to be true
			end

			it "can persist category" do
				expect(subject.build(associated_obj).save).to be true
			end

		end

		context "has foreign key field" do
			
			it "can walk back association" do
				subject.each do |subj|
					id = send_message(subj, "#{object}_id")
					expect(id).to_not raise_error
					expect(id).to_not be_nil
					expect(id).to eq obj.id
				end
			end
			
		end

	end

end