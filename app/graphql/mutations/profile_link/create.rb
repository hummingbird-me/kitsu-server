class Mutations::ProfileLink::Create < Mutations::Base

	argument :input,
		Types::Input::ProfileLink::Create,
		required: true,
		description: 'Add a profile link',
		as: :profile_link
	
	field :site_link, Types::SiteLink, null: true

	def load_profile_link(value)
		ProfileLink.new(value.to_model)
	end

	def authorized?(profile_link:)
		return true if ProfileLinkPolicy.new(context[:token], profile_link).create?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
	end

	def resolve(profile_link:)
		profile_link.save!

		{ site_link: profile_link }
	end
end