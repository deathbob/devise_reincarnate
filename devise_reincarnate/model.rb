# this goes in lib/devise_reincarnate
require 'devise/models'
require 'devise_reincarnate/strategy'

module Devise
  module Models
    module Reincarnate
      
      def pickles?(past_pass)
        cow = self.previous_password == Base64.encode64(Digest::MD5.digest(past_pass)).chomp
        self.failed_logins << FailedLogin.new unless cow # keeping track of failed user logins for launch 2010-03-19
        cow
      end
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end
      
      module ClassMethods

        def reincarnate(attributes={})
          resource = find(:first, :conditions => attributes.slice(:email))
          resource if resource.try(:pickles?, attributes[:password])
        end # Reincarnate (method)
        
      end # ClassMethods
      
    end # Reincarnate (module)
  end # Models
end # Devise


