# this goes in lib/devise_reincarnate
require 'devise/strategies/base'

module Devise
  module Strategies
    
    class Reincarnate < ::Devise::Strategies::Base
      def valid?
        # TODO be nice to find a way to check and see if the record has a previous_password
        # trying to figure that out but it's a deep stack
        mapping.to.respond_to?(:reincarnate) && valid_params?
      end
      
      def authenticate!
        if resource = mapping.to.reincarnate(params[scope])
          success!(resource, "Reincarnated User")
        else
          pass 
          #fail!(:invalid)
          # Fail will halt the authentication procedure, making it impossible to log in if this strategy fails.  
          # So just pass to the next strategy.  
        end
      end
      
      def valid_params?
        params[scope] && params[scope][:password].present?
      end
      
    end # Reincarnate
    
  end # Strategies
end # Devise

Warden::Strategies.add(:reincarnate, Devise::Strategies::Reincarnate)
