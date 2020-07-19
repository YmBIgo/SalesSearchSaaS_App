require 'net/http'
require 'json'
module ApplicationHelper

    def get_url_data(keyword)
        params = URI.encode_www_form({ keyword: keyword })
        uri = URI.parse("https://ec2-52-69-136-236.ap-northeast-1.compute.amazonaws.com:3000/qwant?#{params}")
        begin
            response = Net::HTTP.start(uri.host, uri.port) do |http|
                http.open_timeout = 10
                http.read_timeout = 10
                http.get(uri.request_uri)
            end
            case response
            when Net::HTTPSuccess
                json_result = JSON.parse(response.body)
            else
                json_result = {}
                logger.error("HTTP ERROR code=#{response.code} message=#{response.message}")
            end
        rescue IOError => e
            logger.error(e.message)
        rescue TimeoutError => e
            logger.error(e.message)
        rescue JSON::ParserError => e
            logger.error(e.message)
        rescue => e
            logger.error(e.message)
        end
        return json_result
    end

end
