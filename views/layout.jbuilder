json.response do 
  json.message @page_title
  json.status response.status
  json.results yield
end