require 'tempfile'
require 'mechanize'

class MyAnimeListFileUploadService
  attr_reader :file, :linked_account

  def initialize(file, linked_account_id)
    @file = create_temp_file(file)
    @linked_account = LinkedAccount.find(linked_account_id)
  end

  def upload_file
    agent = Mechanize.new do |a|
      a.user_agent_alias = 'Windows Chrome'
      # a.follow_meta_refresh = true
    end
    # go to login page
    # agent.get('https://myanimelist.net/login.php') do |login_page|
    #   my_page = login_page.form_with(name: 'loginForm') do |form|
    #     form.user_name = linked_account.external_user_id,
    #     form.password = linked_account.token
    #   end.submit
    agent.get('https://myanimelist.net/login.php?') do |login_page|
      login_page.form_with(name: 'loginForm') do |form|
        form['csrf_token'] = login_page.search('meta[name="csrf_token"]').first['content']
        form.user_name = 'username'
        form.password = 'password'
      end.submit
    end

    # is_logged_in=1 is the 3rd object in the array
    # it won't be added if login failed
    return unless agents.cookies.count == 3

    # agent.get('https://myanimelist.net/import.php') do |import_page|
    #   page = import_page.form_with(name: 'importForm') do |form|
    #     form['csrf_token'] = import_page.search('meta[name="csrf_token"]').first['content']
    #     form.field_with(name: 'importtype').value = 3
    #     upload = form.file_upload_with(name: 'mal')
    #     # upload.file_data = file
    #     upload.file_name = './_scraps/myanimelist.xml'
    #     upload.mime_type = 'application/xml'
    #   end.submit
    # end
    agent.get('https://myanimelist.net/import.php') do |import_page|
      form = import_page.form_with(name: 'importForm')
      form['csrf_token'] = import_page.search('meta[name="csrf_token"]').first['content']
      form.field_with(name: 'importtype').value = 3
      upload = form.file_upload_with(name: 'mal')
      # upload.file_data = file
      upload.file_name = './_scraps/myanimelist.xml'
      upload.mime_type = 'application/xml'
      page = form.submit

      puts page.body
    end
  end

  private

  def create_temp_file(file)
    tmp = Tempfile.new(['myanimelist-import', '.xml'])
    tmp << file
    tmp.close

    tmp
  end
end
