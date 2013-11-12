class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  #for OmniAuth
  field :uid, :type => String
  field :provider, :type => String
  #for Padrino::Admin::AccessControl
  field :role, :type => String

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.role = "members"
    end
  end

  def self.find_by_provider_and_uid(provider,uid)
    find_by(:uid => uid, :provider => provider) rescue nil
  end

  def self.find_by_id(id)
    find(id) rescue nil
  end


  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
