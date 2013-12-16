class PushNotification
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  WAITING = 0
  REGISTERED = 1
  DELIVERED = 2

  field :message, :type => String
  field :status, :type => Integer #0 => 未配信,1 => SQS登録済み 2 => 配信済み
  field :token, :type => String  

  scope :waiting, where(:status => WAITING)
  scope :registered, where(:status => REGISTERED)
  scope :delivered, where(:status => DELIVERED)

  def self.find_by_id(id)
    find(id) rescue nil
  end

end
