ENV['GITHUB_SECRET'] = 'secret'

describe 'The Validator' do
  HMAC_DIGEST = OpenSSL::Digest::Digest.new('sha1')

  before do
    @payload = File.read('spec/test_data/repository_hook.json')
    @validator = Validator.new
    @sig = 'sha1='+OpenSSL::HMAC.hexdigest(HMAC_DIGEST, 'secret', @payload)
  end

  it 'should validate' do
    expect(@validator.validate_request(@sig, @payload)).to be_truthy
  end

  it 'should not validate' do
    expect(@validator.validate_request(@sig, "xyz")).to be_falsey
  end

end