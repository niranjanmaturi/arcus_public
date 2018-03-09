RSpec.configure do |config|
  def login_user (user)
    visit new_admin_user_session_path

    fill_in :admin_user_email, with: user.email
    fill_in :admin_user_password, with: user.password

    click_button 'Login'
    expect(page).to have_text('Version')
  end
end
