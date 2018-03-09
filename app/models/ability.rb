class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :read, :all

    if user.role? :member
      cannot :manage, AdminUser
      can :read, AdminUser
      can :manage, [Template, Device, DeviceType]
      can :export_as_json, Template
      can :export_as_csv, Template
    end

    if user.role? :admin
      can :manage, :all
      cannot :destroy, AdminUser, id: user.id
    end

    cannot :destroy, DeviceType, disconnected: false
  end
end
