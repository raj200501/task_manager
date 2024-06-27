require 'active_record'

class Task < ActiveRecord::Base
  validates :title, presence: true

  def to_s
    "Task #{id}: #{title} - #{description} [#{completed ? 'Completed' : 'Pending'}]"
  end
end
