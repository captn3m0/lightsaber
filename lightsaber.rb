require 'public_suffix'
require 'json'
require 'base64'

class Lightsaber
    def self.encrypt(domain, status, redirect, root)
      status = status.to_s
      raise 'Either redirect or root must be provided' if redirect.nil? and root.nil?
      raise 'Invalid Status' if (status!='301' and status !='302')
      raise 'Invalid Domain' unless PublicSuffix.valid?(domain, ignore_private: true)

      str = prepare_private_hash(domain, status, redirect, root)

      public_key = Encryption::PublicKey.new('keys/public.pem')
      return Base64.encode64 public_key.encrypt str
    end

    def self.prepare_private_hash(domain, status, redirect, root)
      h = Hash.new
      if redirect.nil?
        h[domain] = {status: status, root: root, contact: '@captn3m0'}
      else
        h[domain] = {status: status, redirect: redirect, contact: '@captn3m0'}
      end
      str = h.to_json
    end
end