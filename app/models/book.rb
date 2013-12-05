class Book < ActiveRecord::Base
  attr_accessible :author, :details, :press, :price, :taobao, :title
end
