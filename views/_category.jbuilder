json.extract! category, :id, :title#, :created_at, :updated_at
json.title category.title
json.id category.id
json.url  request.base_url + create_route(category.title, :category)
