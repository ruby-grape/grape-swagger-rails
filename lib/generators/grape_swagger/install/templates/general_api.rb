require 'grape-swagger'
class GeneralAPI < Grape::API
  prefix 'api'

  rescue_from :all, :backtrace => true

  #mount DiscountObserverAPI::V1

  add_swagger_documentation api_version: 'v1'
end
