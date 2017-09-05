require_dependency 'zorro'
require_dependency 'zorro/wrapper/user'

module Zorro
  module Importer
    class Profile
      def self.run!
        Zorro::DB::User.find.each do |user|
          new(user).run!
          puts user['aozoraUsername']
        end
      end

      def initialize(user)
        @user = Zorro::Wrapper::User.new(user)
      end

      def run!(full: false)
        @user.initial_merge_onto(target_user)
        @user.full_merge_onto(target_user) if full || email_user.nil?
        target_user.save! && target_user
      end

      private

      def target_user
        @target_user ||= (email_user || ::User.new)
      end

      def email_user
        @email_user ||= ::User.by_email(@user.email).first
      end
    end
  end
end
