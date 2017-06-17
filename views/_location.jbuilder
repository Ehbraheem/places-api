json.extract! location, :id, :name, :created_at, :updated_at
json.name location.name 
json.id location.id
json.url  request.base_url + create_route(location.name, :location)
