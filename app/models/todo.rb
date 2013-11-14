class Todo < ActiveRecord::Base
  def urgent?
    title.include? 'urgent'
  end
end
