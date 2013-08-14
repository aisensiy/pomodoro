class Finished < ActiveRecord::Base
  attr_accessible :content, :end_at, :started_at

  def started_at=(value)
    self[:started_at] = if value.class != Time then Time.at(value.to_f) else value end
  end

  def end_at=(value)
    self[:end_at] = if value.class != Time then Time.at(value.to_f) else value end
  end

end
