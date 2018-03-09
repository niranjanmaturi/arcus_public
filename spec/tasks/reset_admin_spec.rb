require_relative '../rails_helper'
require 'rake'
ArcusService::Application.load_tasks

describe 'Reset Admin', cli: true do
  let(:command) { 'reset_admin' }
  let(:rake_argv) { [] }

  context 'when an email is not provided' do
    it 'returns the help text' do
      expect(stdout).to include("Provide the email address you want to reset the password for:\n\n  Ex. - rake reset_admin {email to reset}\n")
    end

    it 'exits with the proper error code' do
      expect(exit_status).to eq(1)
    end
  end

  context 'when an email is provided' do
    let(:rake_argv) { [nil, email] }
    context 'when the email does not match a given user' do
      let(:email) { Faker::Lorem.words(3).join('-') }

      it 'returns an error message' do
        expect(stdout).to include('Invalid user.')
      end

      it 'exits with the proper error code' do
        expect(exit_status).to eq(1)
      end
    end

    context 'when the email matches a given user' do
      let(:email) { admin_user.email }
      let(:admin_user) { FactoryGirl.create(:admin_user) }
      let(:old_password) { admin_user.password }
      let(:password) { Faker::Internet.password + 'a1' }

      context 'when the passwords provided do not match' do
        let(:inputs) { "#{password}\nfoo_#{password}\n" }
        it 'does not change the password' do
          expect(admin_user.valid_password?(old_password)).to be_truthy
          subject
          expect(admin_user.reload.valid_password?(old_password)).to be_truthy
        end

        it 'returns a failure message' do
          expect(stdout).to include('Error: Passwords must be the same.')
        end

        it 'exits with the proper failure code' do
          expect(exit_status).to eq(1)
        end
      end

      context 'when the passwords provided match' do
        let(:inputs) { "#{password}\n#{password}\n" }
        context 'when the password is invalid' do
          let(:password) { Faker::Internet.password[0, 4] }

          it 'returns the list of failure messages' do
            expect(stdout).to include('Error: Password is too short')
          end
          it 'exits with the proper failure code' do
            expect(exit_status).to eq(1)
          end
        end

        context 'when the password is valid' do
          it 'successfully changes the password' do
            expect(admin_user.valid_password?(password)).to be_falsey
            subject
            admin_user.reload
            expect(admin_user.valid_password?(password)).to be_truthy
          end

          it 'prompts for the password in the appropriate points' do
            indices = cmd_order.each_index.select { |i| cmd_order[i] == [:gets] }
            expect(indices.size).to eq(2)

            expect(cmd_order[indices[0] - 1]).to eq([:puts, 'Please enter the new password'])
            expect(cmd_order[indices[1] - 1]).to eq([:puts, 'Please re-enter the new password'])
          end

          it 'returns a success message' do
            expect(stdout).to include("Password for #{email} changed.")
          end

          it 'exits with the proper success code' do
            expect(exit_status).to eq(0)
          end
        end
      end
    end
  end
end
