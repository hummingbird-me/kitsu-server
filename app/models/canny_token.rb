class CannyToken
  ALGORITHM = 'AES-128-ECB'.freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def to_s
    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.encrypt
    cipher.key = Digest::MD5.digest(ENV['CANNY_SSO_KEY'])
    encrypted = cipher.update(JSON.generate(user_data)) + cipher.final
    encrypted.unpack('H*')
  end

  def user_data
    {
      avatarURL: (user.avatar.present? ? user.avatar.url(:large) : nil),
      name: user.name,
      id: user.id,
      email: user.email
    }.compact
  end
end
