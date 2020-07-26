# Kitsu Server

![Kitsu Test Suite](https://github.com/hummingbird-me/kitsu-server/workflows/Kitsu%20Test%20Suite/badge.svg)
![Kitsu API Deployment](https://github.com/hummingbird-me/kitsu-server/workflows/Kitsu%20API%20Deployment/badge.svg)
[![Code Climate](https://codeclimate.com/github/hummingbird-me/kitsu-server/badges/gpa.svg)](https://codeclimate.com/github/hummingbird-me/kitsu-server) 
[![Test Coverage](https://codeclimate.com/github/hummingbird-me/kitsu-server/badges/coverage.svg)](https://codeclimate.com/github/hummingbird-me/kitsu-server/coverage)

---
**<p align="center">This is our server repository. It contains the rails application for Kitsu.<br />Check out the [tools], [web], [mobile] and [api docs] repositories.</p>**

[tools]:https://github.com/hummingbird-me/kitsu-tools
[web]:https://github.com/hummingbird-me/hummingbird-client
[mobile]:https://github.com/hummingbird-me/kitsu-mobile
[api docs]:https://github.com/hummingbird-me/api-docs

---

This README outlines the details of collaborating on this application.

## Styleguide

* [Ruby](https://github.com/bbatsov/ruby-style-guide)
* [Rails](https://github.com/bbatsov/rails-style-guide) - - [Amendments](https://github.com/hummingbird-me/kitsu-server/blob/the-future/README.md#rails)

## Styleguide Amendments

These amendments are listed below, though we may forget some. Rubocop will help
you, and we have a `.rubocop.yml` which we develop with.

### Rails
#### ActiveRecord Models
 * Group macro-style methods at the beginning of the class definition, in the
   following order:

   ```ruby
   class User < ActiveRecord::Base
     # put the default scope at the top
     default_scope { includes(:favorites) }

     # then the constants
     COLORS = %w[red green blue]

     # then named scopes
     scope(:banned) { where(banned: true) }

     # then any mixin-style "acts_as_*" and similar methods
     acts_as_sortable
     devise :database_authenticable, :registerable, :recoverable,
            :validatable, :confirmable

     # then field-type macros such as enum or has_attached_file
     enum rating_system: %i[smilies stars]
     has_attached_file :avatar

     # then associations
     has_many :library_entries

     # then validation
     validates :email, presence: true
     validates name, presence: true

     # and then callbacks
     before_save :do_the_thing

     # ... and finally the rest of the methods!
   end
   ```
   
## Contributors
   
[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/0)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/0)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/1)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/1)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/2)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/2)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/3)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/3)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/4)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/4)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/5)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/5)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/6)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/6)[![](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/images/7)](https://sourcerer.io/fame/wopian/hummingbird-me/kitsu-server/links/7)
