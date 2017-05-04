class OneSignalNotificationService
  attr_reader :params
  ##
  # Initialize services with GetStream webhook request
  def initialize(params)
    @params = params
  end

  def create
    # POST request to one signal server
  end
end