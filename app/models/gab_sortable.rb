module GabSortable
	module ClassMethods
		def build_position(laws=roots)
	    laws.order('id asc').each_with_index do |law,index|
	      law.build_position
	      self.build_position law.children
	    end
	  end
	  def ordered_roots
	    roots.order('position asc')
	  end  
  end

  # This module contains class methods
  module SingletonMethods
  	def move_up
	    node = position_scope.where('position < ?',self.position).last
	    if node
	      tmp = node.position
	      node.position = self.position
	      self.position = tmp
	      node.save :validate=>false
	      self.save :validate=>false
	    end
	  end

	  def move_down
	    node = position_scope.where('position > ?',self.position).first
	    if node
	      tmp = node.position
	      node.position = self.position
	      self.position = tmp
	      node.save :validate=>false
	      self.save :validate=>false
	    end
	  end

	  def move_upest
	    node = position_scope.where('position < ?',self.position).first
	    if node
	      tmp = node.position
	      node.position = self.position
	      self.position = tmp
	      node.save :validate=>false
	      self.save :validate=>false
	    end
	  end

	  def move_downest
	    node = position_scope.where('position > ?',self.position).last
	    if node
	      tmp = node.position
	      node.position = self.position
	      self.position = tmp
	      node.save :validate=>false
	      self.save :validate=>false
	    end
	  end

	  # 返回排序所在得列表
	  def position_scope
	    if self.root?
	      self.class.roots.order('position asc')
	    else
	      self.parent.children.order('position asc')
	    end
	  end

	  # 设置position
	  def build_position
	    relation = position_scope
	    self.position = relation.last.position.to_i + 1
	    self.save :validate=>false
	  end

	  def ordered_children
	    children.order('position asc')
	  end
  end

  module LocalInstanceMethods
    
  end
end