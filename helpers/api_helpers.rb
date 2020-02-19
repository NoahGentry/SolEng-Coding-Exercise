module ApiHelpers
  require 'rest_client'

  ORG_ID = "s-3e8c4412-13ed-47f9-a727-5b9dc98b53fb"
  BASE_PRODUCTS_URL = "https://app.salsify.com/api/v1/orgs/#{ORG_ID}/products"

  def create_products(product_data)
    begin
      RestClient.post(BASE_PRODUCTS_URL, product_data, accept: "application/json", content_type: "application/json", Authorization: "Bearer #{ENV['SALSIFY_API_KEY']}")
    rescue RestClient::UnprocessableEntity => e
      puts "Encountered Errors:"
      JSON.parse(e.http_body)["errors"].each do |error|
        puts error
      end
    end
  end

  def bulk_update_products(product_data)
    begin
      RestClient.put(BASE_PRODUCTS_URL, product_data, accept: "application/json", content_type: "application/json", Authorization: "Bearer #{ENV['SALSIFY_API_KEY']}")
    rescue RestClient::UnprocessableEntity => e
      puts "Encountered Errors:"
      JSON.parse(e.http_body)["errors"].each do |error|
        puts error
      end
    end
  end

  def bulk_delete_products(ids_to_delete)
    begin
      RestClient::Request.execute(method: :delete, url: BASE_PRODUCTS_URL, payload: ids_to_delete, headers: {content_type: "application/json", Authorization: "Bearer #{ENV['SALSIFY_API_KEY']}"})
    rescue RestClient::UnprocessableEntity => e
      puts "Encountered Errors:"
      JSON.parse(e.http_body)["errors"].each do |error|
        puts error
      end
    end
  end

  def get_products(ids_to_fetch)
    begin
      RestClient::Request.execute(method: :get, url: BASE_PRODUCTS_URL, payload: ids_to_fetch, headers: {content_type: "application/json", Authorization: "Bearer #{ENV['SALSIFY_API_KEY']}"})
    rescue RestClient::UnprocessableEntity => e
      puts "Encountered Errors:"
      JSON.parse(e.http_body)["errors"].each do |error|
        puts error
      end
    end
  end
end
