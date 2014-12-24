require 'rack'

class Validator
  def validate_request(input_sig, payload)
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GITHUB_SECRET'], payload)
    Rack::Utils.secure_compare signature.to_str, input_sig.to_str
  end
end
