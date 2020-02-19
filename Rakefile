require 'require_all'
require 'dotenv/load'
require 'json'
require_all 'helpers/'
include FTPHelpers
include XMLHelpers
include ApiHelpers

task create_products: :fetch_data do
  parsed_data = parse_product_data("products.xml")
  response = create_products(JSON.generate(parsed_data))
  puts "Response: #{response.code}"
  puts response.body
end

task update_products: :fetch_data do
  parsed_data = parse_product_data("products.xml")
  response = bulk_update_products(JSON.generate(parsed_data))
  puts "Response: #{response.code}"
  puts response.body
end

task :delete_products do |t, args|
  product_ids = args.to_a
  response = bulk_delete_products(JSON.generate(product_ids))
  puts "Response: #{response.code}"
  puts response.body
end

task :get_products do |t, args|
  ids_to_fetch = args.to_a
  response = get_products(ids_to_fetch)
  puts JSON.pretty_generate(response.body)
end

task :fetch_data do
  download_product_data_from_ftp
end
