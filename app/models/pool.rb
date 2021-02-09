class Pool < ApplicationRecord
  after_create :add_pool

  def url=(val)
    unless val.include?("stratum+tcp://")
      self[:url] = "stratum+tcp://#{val}"
    else
      self[:url] = val
    end
  end

  def pass=(val)
    self[:pass] = "x" if val.blank?
  end

  def add_pool
    add_pool = CgminerApi.call("addpool|#{self.url},#{self.user},#{self.pass}")
    save_config = CgminerApi.call("save|#{Rails.root.join('bin', 'cgminer.conf')}")
  end
end
