module ModelsHelper


	def put_new_value hash, newObject
		# byebug
		newObject.update_attributes(hash)
		newObject
	end

	def make_object object
		Object.const_get(object.to_s.classify)
	end

	def create_random_place
		# Place.new({id: rand(1..30000), 
		# 								formatted_address: "23, Foo street",
		# 								location: ["Lagos"],
		# 								types: ["Foo"],
		# 								name: "Foo #{rand(1..3000)}",
		# 								rating: 7.8,
		# 								icon: "foo.png",
		# 								place_id: "234 #{rand(1..3000)}",
		# 								references: "good",
		# 								geometry: Point.new([rand(1..3000),rand(1..3000)]).mongoize,
		# 								opening_hours: Availability.new({open_now: true, weekdays_text: []}).mongoize,
		# 								})

		FactoryGirl.build(:place)
	end

	def send_message obj, msg, param=nil
		param ? obj.send(msg.to_sym, param) : obj.send(msg.to_sym)
	end

	def create_association_param assos
		"with_#{assos.singularize}".to_sym
	end

	def make_hash_from_array arr, obj=nil

		arr.inject({}) do |hash, elem|
			hash[elem] = (!obj.nil?) ? obj[elem.to_sym] : obj 
			hash
		end
	end

	def build_foreign_key key
		"#{key}_id"
	end

	def duplicate_fields object, field

		expect(object.save).to be false

		error_object = object.errors
		expect(error_object).to respond_to :messages
		expect(error_object.messages).to have_key field
		expect(error_object.messages[field]).to_not be_empty
		expect(error_object.messages[field]).to include /already taken/

	end

	def sending(obj, msg)
		send_message obj, msg
	end


	RSpec.shared_examples "Custom DB type" do |object|

		describe "valid #{object.classify}" do

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

		describe "valid #{object.classify} instance" do
			# byebug

			let(:newObject) { make_object(object).new(nil) }

			it "respond to getter \##{methods.join(',')}" do
				methods.each do |method|
					expect(newObject).to respond_to method.to_sym
				end
			end

			it "does not respond to setter \##{methods.join(',')}" do
				methods.each do |method|
					expect(newObject).to_not respond_to "#{method}=".to_sym
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

			let(:obj) { FactoryGirl.build(object) }
			
			it "default #{object.to_s.classify} created with random name" do
				# byebug
				expect(obj).to_not be_nil
				expect(obj).to be_a_kind_of make_object object

				fields.each do |field|
					expect(obj).to respond_to field
					# byebug
					expect(obj).to respond_to "#{field}=".to_sym
				end
				
			end

			it "create #{object.to_s.classify} with non-nil #{fields.join(',')}" do
				fields.each do |field|
					data = send_message obj, field 
					expect(data).to_not be_nil
				end
				
			end

		end
	end


	RSpec.shared_examples "build invalid object" do |object, fields|
		
		context "build invalid #{object.to_s.classify}" do

			let(:obj) { FactoryGirl.build(object, :with_invalid_field) }
			
			it "fails to validate" do
				fields.each do |field|
					data = send_message obj, field

					expect { |data| (data.to match_array []) || (data.to be_nil) }
				end
				expect(obj).to_not be_valid
			end

			it "fails to save" do
				expect(obj.save).to be false
				expect(obj).to respond_to :errors
				expect(obj.errors).to_not be_nil
				expect(obj).to_not be_valid
			end

			it "provides error message" do
				obj.save
				expect(obj).to respond_to :errors
				expect(obj.errors).to_not be_nil
				expect(obj.errors).to respond_to :messages
				expect(obj.errors.messages).to include(fields[0].to_sym =>["can't be blank"])
			end
		end
	end

	RSpec.shared_examples "Associations" do |object, association|

		let(:obj) { FactoryGirl.create(object, create_association_param(association)) }
		let!(:assos_obj) { send_message(obj, "#{association.pluralize}=", FactoryGirl.build_list(association.to_sym, 4)) }
		# let(:obj) { FactoryGirl.create(association.to_sym)}
		let(:fk)  { build_foreign_key object }

		subject { send_message(obj, association.pluralize) }
		
		context "can walk through association" do
			
			it "can access #{association} information" do
				# byebug
				expect(obj).to respond_to association.pluralize.to_sym
				is_expected.to_not be_nil
				subject.each do |sub|
					expect(sub).to be_a_kind_of make_object association
				end
				is_expected.to respond_to :length && :count # Array Duck-Type
			end

			it "can have more than one #{association}" do
				# byebug
				expect(subject.count).to be >= 1
				expect(subject.length).to be >= 1
				expect(subject).to respond_to :<<
			end

		end

		context "can build association" do

			let(:associated_obj) { FactoryGirl.attributes_for(association.to_sym) }
			
			it "can build new #{association}" do
				data = subject.build(associated_obj)
				expect(data).to be_truthy
				expect(data).to_not be_persisted
				associated_obj.each_pair do |name, val|
					# byebug
					expect(data[name]).to eq val
				end
				subject.each do |sub|
					expect(send_message(sub, fk)).to eq obj.id
				end 
				expect(send_message(data, fk)).to eq obj.id
			end

			it "can persist #{association}" do
				expect(subject.build(associated_obj).save).to be true
			end

		end

		context "has foreign key field" do
			
			it "can walk back association" do
				subject.each do |subj|
					expect(subj).to respond_to fk.to_sym
					expect(subj).to have_attribute fk.to_sym
					id = send_message(subj, fk )
					# expect(id).to_not raise_error { }
					expect(id).to_not be_nil
					expect(id).to eq obj.id
				end
			end
			
		end

	end

	RSpec.shared_examples "Connect two different tables" do |object, owning_object, owned_object|
		
		let(:owning_obj) { FactoryGirl.create(owning_object) }
		let(:records)  { FactoryGirl.create_list(object, 10, owning_object=>owning_obj) }

		let(:owned_obj) { sending(owning_obj, owned_object.pluralize) }
		
		context "from #{owning_object.classify} to #{owned_object.classify}" do
			
			it "allow access to #{owned_object.classify} from #{owning_object.classify}" do
				# byebug
				records
				expect(owning_obj).to respond_to owned_object.pluralize.to_sym
				expect(owned_obj.to_a).to be_a_kind_of Array
				expect(owned_obj).to respond_to :length
				expect(owned_obj).to respond_to :count
				expect(owned_obj.count).to be > 1
				expect(owned_obj.length).to be > 1
			end

			it "list out all #{owned_object.pluralize.classify} for this #{owning_object.classify}" do
				owned_obj.each do |cat|
					expect(sending(cat, object)).to be_a_kind_of make_object object
					expect(sending(cat, owning_object)).to eq owning_obj
					expect(make_object(object).all).to include sending(cat, object)
				end
			end

			it "provides details of each #{owned_object.classify} for this #{owning_object.classify}" do
				owned_obj.each do |cat|
					expect(cat).to respond_to :attributes
					make_object(owned_object).attributes.each do |attr|
						expect(cat).to respond_to attr.to_sym
						expect(cat).to have_attribute attr.to_sym
						expect(cat).to respond_to "#{attr}=".to_sym
					end
				end
			end

			it "verify same the same #{owning_object.classify} for each #{owned_object.classify}" do
				owned_obj.each do |cat|
					make_object(owning_object).attributes.each do |attr|
						expect(sending(cat, owning_object)).to respond_to attr.to_sym
						expect(sending(cat, owning_object)).to respond_to "#{attr}=".to_sym
						expect(sending(owning_obj, attr)).to eq sending(sending(cat,owning_object), attr) 

					end
				end
			end

		end
	end


	RSpec.shared_examples "Ownership" do |object, owning_object, owned_object|

		context "belongs to  #{owning_object.classify}" do

			let(:fail_record) { FactoryGirl.build(object, owning_object.to_sym => nil) }
			let(:record) { FactoryGirl.build(object)}
			
			it "save fails when #{owning_object.classify} is nil" do

				expect(fail_record.save).to be false
				expect(fail_record).to respond_to :errors
				expect(fail_record.errors).to respond_to :messages
				expect(fail_record.errors).to respond_to :full_messages
				expect(fail_record.errors.messages).to include "#{owning_object}_id".to_sym => ["can't be blank"]
			end

			it "it allow multiple document to have same #{owning_object.classify}" do
				record.save
				another_record = FactoryGirl.create_list(object, 10, owning_object=>sending(record, owning_object))
				another_record.each do |land|
					expect(sending(land, owning_object)).to eq sending(record, owning_object)
					expect(sending(land, "#{owning_object}_id")).to eq sending(record, "#{owning_object}_id")
					expect(sending(land, owned_object)).to_not eq sending(record, owning_object)
					expect(sending(land, "#{owned_object}_id")).to_not eq sending(record, "#{owned_object}_id")
				end
			end

			# it "index #{owning_object}, #{owned_object}" do
			# 	byebug
			# 	expect(make_object(object)).should have_db_index "#{owning_object}_id"
			# 	expect(make_object(object)).to have_db_index "#{owned_object}_id"
			# end

		end
	end

	RSpec.shared_examples "Associations validations" do |object, owning_object, owned_object, owning_object_attr|

		let(:record) { FactoryGirl.build(object, owning_object=>FactoryGirl.build(owning_object.to_sym, owning_object_attr=> nil)) }

		context "save fails for invalid #{owning_object.classify}" do
			
			it "rollback save for invalid #{owning_object.classify}" do
				expect(record.save).to be false
				expect(sending(record,owning_object)).to be_invalid
				expect(sending(record, owned_object)).to_not be nil
				expect(record).to_not be nil
			end

			it "provide descriptive error messages" do
				expect(record.save).to be false
				expect(record).to respond_to :errors
				expect(record.errors).to_not be nil
				expect(record.errors.messages).to_not be nil
				expect(record.errors).to respond_to :full_messages
				expect(record.errors.messages).to include "#{owning_object}_id".to_sym =>["can't be blank"]
			end

			it "failed to save record with invalid #{owning_object.classify}" do
				expect(record.save).to be false
				expect(record.errors.messages).to include owning_object.to_sym=>["is invalid"]
			end
		end
	end

end