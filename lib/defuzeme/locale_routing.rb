require 'routing_filter/filter'

module RoutingFilter
  class Locale < Filter 
    def around_recognize(path, env, &block)
      locale = nil
      path.sub! %r(^/([a-zA-Z]{2})(?=/|$)) do locale = $1; '' end
      path.replace '/' if path.blank?
      yield.tap do |params|
        params[:locale] = locale
      end
    end
    
    def around_generate(*args, &block)
      locale = args.extract_options!.delete(:locale) || I18n.locale
      yield.tap do |result|
        if result.is_a? Array
          result.first.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        else
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end
      end
    end
  end
end
