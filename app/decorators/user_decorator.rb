class UserDecorator < Draper::Decorator
  delegate_all

  def right_rate
  	if histories.count()>0
  		(histories.right.count()*1.0/histories.count()).round(3)
		else
			0
		end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
