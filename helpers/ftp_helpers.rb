module FTPHelpers
  require 'net/ftp'

  FTP_OPTIONS = {username: ENV['FTPUSER'],
                 password: ENV['FTPPASS']}

  def download_product_data_from_ftp
    @ftp ||= Net::FTP.new('ftp.salsify.com', FTP_OPTIONS)
    @ftp.get('products.xml')
  end
end
