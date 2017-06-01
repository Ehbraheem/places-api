module ModelsHelper


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

	
end