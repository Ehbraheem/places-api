json.response do 
  json.message "your message"
  json.status response.status
  json.results yield
end