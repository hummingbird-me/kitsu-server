class CannyToken
  ALGORITHM = 'AES-128-ECB'.freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def to_s
    encrypt(JSON.generate(user_data))
  end

  def user_data
    {
      avatarURL: (user.avatar.present? ? user.avatar.url(:large) : nil),
      name: user.name,
      id: user.id,
      email: user.email
    }.compact
  end

  private

  def encrypt(str)
    encrypted = cipher.update(str) + cipher.final
    encrypted.unpack('H*').join
  end

  def cipher
    return @cipher if @cipher
    @cipher = OpenSSL::Cipher.new(ALGORITHM)
    @cipher.encrypt
    @cipher.key = cipher_key
    @cipher
  end

  def cipher_key
    Digest::MD5.digest(ENV['CANNY_SSO_KEY'])
  end
end
