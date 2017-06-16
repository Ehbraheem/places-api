# json.extract! thing, :id, :name, :description, :created_at, :updated_at
# json.notes thing.notes unless restrict_notes? thing.user_roles
# json.url thing_url(thing, format: :json)
# json.user_roles thing.user_roles unless thing.user_roles.empty?
json.extract! data, :id, :name, :created_at, :updated_at
json.name data.name 
json.id data.id
json.url  request.base_url + create_route(data.name, :location)
