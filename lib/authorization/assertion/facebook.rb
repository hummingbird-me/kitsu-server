module Authorization
  module Assertion
    class Facebook
      def initialize(auth_code)
        @auth_code = auth_code
        @user_data = user_data
      end

      def user_data
        facebook = URI.parse("https://graph.facebook.com/v2.5/me?access_token=#{@auth_code}&fields=id,name,email,first_name,last_name,gender,friends")
        response = Net::HTTP.get_response(facebook)
        JSON.parse(response.body)
      end

      def image
        img = URI.parse("https://graph.facebook.com/v2.5/me/picture?access_token=#{@auth_code}&width=180&height=180&redirect=false")
        response = Net::HTTP.get_response(img)
        JSON.parse(response.body)
      end

      def get_user!
        if @user_data.present?
          User.where(facebook_id: @user_data['id']).first
        end
      end

      def friends
        if @user_data.present?
          user = get_user!
          @user_data['friends']['data'].each do |friend|
            follower = User.where(facebook_id: friend['id']).first
            if follower.present?
              user.friends << follower
              user.save
            end
          end
        end
      end
    end
  end
end
