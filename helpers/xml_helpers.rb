module XMLHelpers
  require 'nokogiri'

  PRODUCTS_XPATH = "//products"

  def parse_product_data(path_to_xml)
    products = Nokogiri::XML(File.open(path_to_xml)) { |config| config.noblanks }.at_xpath(PRODUCTS_XPATH)

    products.children.map do |product|
      product_data = {"SKU" => product["SKU"],
                      "Item Name" => product["Item_Name"]}

      product.children.each do |attribute|
        product_data[attribute.name] = attribute.child.to_s
      end

      product_data
    end
  end
end
