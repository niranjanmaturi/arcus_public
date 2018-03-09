require 'rails_helper'

RSpec.describe Ability do
  subject { described_class.new(admin_user) }
  let(:admin_user) { create(:admin_user) }
  let(:other_admin_user) { create(:admin_user) }
  let(:is_member) { true }
  let(:is_admin) { false }
  let(:connected_device_type) do
    device_type = create(:device_type)
    create(:template, device_type: device_type)
    device_type
  end
  let(:disconnected_device_type) { create(:device_type) }
  let(:dashboard_page) { ActiveAdmin::Page.new(:admin, 'Dashboard', {}) }


  before do
    allow(admin_user).to receive(:role?).with(:member).and_return(is_member)
    allow(admin_user).to receive(:role?).with(:admin).and_return(is_admin)
  end

  context 'as an administrator' do
    let(:is_admin) { true }
    let(:is_member) { true }

    it { expect(subject.can?(:manage, AdminUser)).to be_truthy }
    it { expect(subject.can?(:read, AdminUser)).to be_truthy }
    it { expect(subject.can?(:export_as_json, Template)).to be_truthy }
    it { expect(subject.can?(:export_as_csv, Template)).to be_truthy }
    it { expect(subject.can?(:manage, Device)).to be_truthy }
    it { expect(subject.can?(:manage, Template)).to be_truthy }
    it { expect(subject.can?(:manage, ServiceAccount)).to be_truthy }
    it { expect(subject.can?(:read, dashboard_page)).to be_truthy }

    it { expect(subject.can?(:destroy, admin_user)).to be_falsey }
    it { expect(subject.can?(:destroy, other_admin_user)).to be_truthy }

    it 'should not be able to destroy connected device types' do
      expect(subject.can?(:destroy, connected_device_type)).to be_falsey
    end
    it 'should be able to destroy disconnected device types' do
      expect(subject.can?(:destroy, disconnected_device_type)).to be_truthy
    end
  end
  context 'as a member' do
    let(:is_admin) { false }
    let(:is_member) { true }

    it { expect(subject.can?(:export_as_json, Template)).to be_truthy }
    it { expect(subject.can?(:export_as_csv, Template)).to be_truthy }
    it { expect(subject.can?(:manage, Device)).to be_truthy }
    it { expect(subject.can?(:manage, Template)).to be_truthy }
    it { expect(subject.can?(:read, AdminUser)).to be_truthy }
    it { expect(subject.can?(:read, dashboard_page)).to be_truthy }
    it { expect(subject.can?(:read, ServiceAccount)).to be_truthy }

    it { expect(subject.can?(:manage, ServiceAccount)).to be_falsey }
    it { expect(subject.can?(:manage, AdminUser)).to be_falsey }

    it 'should not be able to destroy connected device types' do
      expect(subject.can?(:destroy, connected_device_type)).to be_falsey
    end
    it 'should be able to destroy disconnected device types' do
      expect(subject.can?(:destroy, disconnected_device_type)).to be_truthy
    end
  end
  context 'as a non-member, non-administrator' do
    let(:is_admin) { false }
    let(:is_member) { false }

    it { expect(subject.can?(:read, dashboard_page)).to be_truthy }
    it { expect(subject.can?(:read, :all)).to be_truthy }

    it { expect(subject.can?(:export_as_json, Template)).to be_falsey }
    it { expect(subject.can?(:export_as_csv, Template)).to be_falsey }
    it { expect(subject.can?(:manage, Device)).to be_falsey }
    it { expect(subject.can?(:manage, Template)).to be_falsey }

    it 'should not be able to destroy connected device types' do
      expect(subject.can?(:destroy, connected_device_type)).to be_falsey
    end
    it 'should not be able to destroy disconnected device types' do
      expect(subject.can?(:destroy, disconnected_device_type)).to be_falsey
    end

  end
end
