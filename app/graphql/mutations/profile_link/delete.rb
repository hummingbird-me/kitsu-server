class Mutations::ProfileLink::Delete < Mutations::Base

	argument :input,
		Types::Input::GenericDelete,
		required: true,
		description: 'Remove a profile link',
		as: :profile_link
	
	field :site_link, Types::SiteLink, null: true

	def load_profile_link(value)
		ProfileLink.find(value.id)
	end

	def authorized?(profile_link:)
		return true if ProfileLinkPolicy.new(context[:token], profile_link).destroy?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
	end

	def resolve(profile_link:)
		profile_link.destroy!

		{ site_link: { id: profile_link.id } }
	end
end