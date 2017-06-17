module ApiHelper

	# def self.path_path(path)
	# 	define_method "#{path.to_s.pluralize}_path".to_sym do |param=nil|
	# 		yield(path, param)
	# 	end
	# end
	
	# def base_path 
	# 	"/api/v1/places"
	# end

	# paths_hash = {location: "/:location",  category: "/:category", place: "/:place" }

	# # byebug

	# path_path(:location)  do |path, param| 
	# 	base_path + paths_hash[path]
	# end 

	# path_path(:category ) do |path, param| 
	# 	locations_path + paths_hash[path]
	# end

	# path_path(:place)  do |path, param| 
	# 	categories_path + paths_hash[path]
	# end
	def make_path object, plural=true
		plural ? "#{object.to_s.pluralize}_path" : "#{object}_path"
	end

	%w( put post patch delete get head ).each do |http_method_path|
		define_method("j#{http_method_path}") do |path, params={}, headers={}|
			if %w( post put patch ).include? http_method_path
				headers = headers.merge('Content-Type' => 'application/json') if !params.empty?
				params = params.to_json
			end

			self.send(http_method_path,
						path,
						params,
						headers)
		end
	end

	def make_object object
		Object.const_get(object.to_s.classify)
	end

	def parsed_body
		JSON.parse last_response.body
	end

	def result_stripper
		JSON.parse parsed_body["response"]["results"]
	end


	RSpec.shared_examples "Check response" do
		it "returns valid JSON document" do
			payload = parsed_body
			expect(payload).to respond_to :has_key?
			expect(payload).to have_key "response"
			expect(payload["response"]).to respond_to :has_key?
			expect(payload["response"]).to have_key "message"
			expect(payload["response"]["message"]).to eq "your message"
			expect(payload["response"]).to have_key "status"
			expect(payload["response"]["status"]).to eq last_response.status
			expect(payload["response"]).to have_key "results"
		end
	end

	RSpec.shared_examples "Return type" do 

		it_should_behave_like "Check response"

		context "Content returns" do
				
			it "returns HTTP status OK" do
				expect(last_response).to be_ok
				expect(last_response).to respond_to :status
				expect(last_response).to respond_to :headers
				expect(last_response).to respond_to :errors
				expect(last_response.errors).to eq ""
				expect(last_response.errors).to be_empty
			end

			it "returns document with valid headers" do
				expect(last_response).to respond_to :headers
				expect(last_response.headers).to be_a_kind_of Hash
				expect(last_response.headers).to have_key "Content-Type"
				expect(last_response.headers).to have_key "Content-Length"
				expect(last_response.headers).to have_key "X-Content-Type-Options"
				expect(last_response.headers["Content-Type"]).to eq "application/json"
				expect(last_response.headers["Content-Length"].to_i).to be > 50
				expect(last_response.headers["X-Content-Type-Options"]).to eq "nosniff"
			end
		end

	end

	RSpec.shared_examples "Valid response" do 

		it_should_behave_like "Check response"
		
		context "response body" do
				
			it "HTTP status is 2xx" do
				expect(last_response.status).to be >= 200
				expect(last_response.status).to be < 300
				expect(last_response).to respond_to :errors
				expect(last_response.errors).to eq ""
				expect(last_response.errors).to be_empty
			end

			it "returns valid mime type" do
				expect(last_response.content_type).to eq "application/json"
				expect(last_response.headers).to have_key "Content-Type"
				expect(last_response.headers["Content-Type"]).to eq "application/json"
			end

			it "returns standard length" do
				expect(last_response).to respond_to :length
				expect(last_response.length.to_i).to be > 10
				expect(last_response.headers).to have_key "Content-Length"
				expect(last_response.headers["Content-Length"].to_i).to be > 10
				expect(last_response.headers["Content-Length"].to_i).to eq last_response.length.to_i
			end

		end

	end


	RSpec.shared_examples "Return all data currently availabe" do |object|

		context "Single data available" do
			it_should_behave_like "Check response"
			it_should_behave_like "verify data", object
		end

		context "Multiple data available" do
			it_should_behave_like "Check response"
			
			it_should_behave_like "verify data", object

		end

	end

	RSpec.shared_examples "verify JSON docuemnt returned" do |object, attribute, relation=nil, assos=nil, param=nil|


		if relation
			let(:connector) { FactoryGirl.create(assos) }

			let(:records) { FactoryGirl.create_list(relation, 67, assos=>connector) }
			let(:data) { FactoryGirl.create(relation, assos=>connector); connector.send(object.to_s.pluralize)}
			let(:datas) { connector.send(object.to_s.pluralize) }
			let(:record) { FactoryGirl.create(object) }
		else
			let(:datas) { FactoryGirl.create_list(object, 67) }
			let(:record) { FactoryGirl.create(object) }
		end

		
		
		context "verify document returned" do

			it_should_behave_like "Check response"

			it "validate if all field is present" do

				record
				attributes = record.attributes
				# byebug
				# url = send(make_path(object, false), record.send(attribute)) # location_path(record.name) 

				if !!(param && relation)
					records
					jget send(make_path(object), connector.send(param))
				else
					jget send(make_path(object))
				end # locations_path

				payload = result_stripper
				payload.each do |doc|
					expect(doc).to_not be_nil
					expect(doc).to_not be_empty
					# expect(doc["url"].gsub(/.+\/\/example.org/, "")).to eq url

					attributes.keys.each do |key|
						payload.each do |doc|
							expect(doc).to have_key key
							expect(doc[key]).to_not be_falsey
							expect(doc[key]).to_not be_nil
						end
					end
				end	
				
			end

			it_should_behave_like "Check response"

			it "validate against DB records" do
				datas
				recordss = make_object(object).all

				if !!(param && relation)
					records
					jget send(make_path(object), connector.send(param))
				else
					jget send(make_path(object))
				end

				payload = result_stripper

				recordss.each do |rec|
					payload.each do |doc|
						doc.delete(:url)
						doc.keys do |key|
							expect(rec).to respond_to key.to_sym
							expect(rec).to respond_to "#{key}=".to_sym
						end
						rec.attributes.keys do |key|
							expect(doc).to have_key key
						end
					end
				end
			end
		end
	end

	RSpec.shared_examples "relationship verify JSON document returned" do |object, attribute, relation, assos, param|
		it_should_behave_like "Check response"
		it_should_behave_like "verify JSON docuemnt returned", [object, attribute, relation, assos, param]
		it_should_behave_like "Check response"
	end

	RSpec.shared_examples "return accurate number of records" do |object, relation=nil, assos=nil, param=nil|

		it_should_behave_like "Check response"

		if relation
			let(:connector) { FactoryGirl.create(assos) }

			let(:records) { FactoryGirl.create_list(relation, 67, assos=>connector) }
			let(:data) { FactoryGirl.create(relation, assos=>connector); connector.send(object.to_s.pluralize)}
			let(:datas) { connector.send(object.to_s.pluralize) }
			let(:record) { FactoryGirl.create(object) }
		else
			let(:datas) { FactoryGirl.create_list(object, 67) }
		end

		it_should_behave_like "Check response"
		
		it "returns correct number of records" do
			datas

			if !!(param && relation)
				records
				jget send(make_path(object), connector.send(param))
			else
				jget send(make_path(object))
			end

			payload = result_stripper
			expect(payload).to_not be_empty
			expect(payload).to respond_to :length
			expect(payload.length).to be > 10
			expect(payload.length).to eq datas.count
		end

		it "returns exact document inserted into DB" do
			datas

			if !!(param && relation)
				records
				jget send(make_path(object), connector.send(param))
			else
				jget send(make_path(object))
			end

			payload = result_stripper
			expect(payload).to respond_to :each
			expect(payload.length).to be > 1
			payload.each do |doc|
				data = make_object(object).find(doc["id"])
				# expect(data.attributes).to eq doc
				data.attributes.each_pair do |key, val|  
					expect(doc).to have_key key
					# expect(doc[key].to_s).to match /#{val.to_s}/ #/#{Regexp.escape(val)}/
				end
			end
		end
	end

	RSpec.shared_examples "verify data" do |object|

		let(:datas) { FactoryGirl.create_list(object, 67) }
		let(:record) { FactoryGirl.create(object) }

		it_should_behave_like "Check response"

		it "is empty when data is not persisted" do
				payload = result_stripper
				expect(payload).to eq []
				expect(payload).to be_empty
				expect(payload).to_not be_nil
				expect(payload).to respond_to :each
		end

		it "is not empty when data is persisted" do
			datas

			jget send(make_path(object))

			payload = result_stripper
			expect(payload).to_not be_empty
			expect(payload).to_not be_nil
			payload.each do |json|
				expect(json).to be_a_kind_of Hash
				expect(json).to respond_to :keys
				expect(json).to respond_to :values
				expect(json).to have_key "url"
				record.attributes.keys.each do |key|
					expect(json).to have_key key
				end
			end
				
		end
	end

	shared_context "no data" do
		it "is empty when data is not persisted" do
			payload = result_stripper
			expect(payload).to eq []
			expect(payload).to be_empty
			expect(payload).to_not be_nil
			expect(payload).to respond_to :each
		end
	end

	RSpec.shared_examples "relationship returns accurate number of records" do |object, relation, assos, param|

		it_should_behave_like "Check response"

		it_should_behave_like "return accurate number of records", [object, relation, assos, param]

	end

	RSpec.shared_examples "relationship returns all data currently available" do |object, relation, assos, param|

		let(:connector) { FactoryGirl.create(assos) }

		let(:records) { FactoryGirl.create_list(relation, 67, assos=>connector) }
		let(:data) { FactoryGirl.create(relation, assos=>connector); connector.send(object.to_s.pluralize)}
		let(:datas) { connector.send(object.to_s.pluralize) }
		let(:record) { FactoryGirl.create(object) }

		context "all datas" do
			it_should_behave_like "Check response"
			include_context "no data"
		end
		
		context "Single data available" do
			it_should_behave_like "Check response"

			include_context "no data"

			it "is not empty when data is persisted" do
				data
				jget send(make_path(object), connector.send(param))

				payload = result_stripper
				expect(payload).to_not be_empty
				expect(payload).to_not be_nil
				payload.each do |json|
					expect(json).to be_a_kind_of Hash
					expect(json).to respond_to :keys
					expect(json).to respond_to :values
					# expect(json).to have_key "url"
					record.attributes.keys.each do |key|
						expect(json).to have_key key
					end
				end	
			end
		end

		context "Multiple data available" do
			include_context "no data"

			

			it "is not empty when data is persisted" do
				records
				datas
				jget send(make_path(object), connector.send(param))

				payload = result_stripper
				expect(payload).to_not be_empty
				expect(payload).to_not be_nil
				payload.each do |json|
					expect(json).to be_a_kind_of Hash
					expect(json).to respond_to :keys
					expect(json).to respond_to :values
					# expect(json).to have_key "url"
					record.attributes.keys.each do |key|
						expect(json).to have_key key
					end
				end	
			end
		end
	end

end