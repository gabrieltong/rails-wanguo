module WgCollectAdapter
  extend ActiveSupport::Concern
  module ClassMethods
    def setup
      include WgCollectAdapter::LocalInstanceMethods
      extend WgCollectAdapter::SingletonMethods
      before_save :update_keys

      state_machine :collectable_type do 
        state 'Law','Freelaw' do
          def update_keys
            collectable.path[0..2].each_with_index do |law,index|
              self.send("key#{index+1}_id=",law.id)
            end
          end
        end

        state 'Question' do
          def update_keys
            # collectable.eps.each 
          end
        end
      end
    end
  end

  # This module contains class methods
  module SingletonMethods
    def roots(user_id,type)
      user_id = user_id.id if user_id.is_a? User
      type = type.to_s
      collects = Collect.where(
        :collectable_type=>type.to_s,
        :user_id=>user_id
      ).select('distinct `key1_id` ')
      if type.to_s == 'Law' || type.to_s == 'Freelaw'
        roots = Law.roots.where(:id => collects.collect {|i|i.key1_id})  
      elsif type.to_s == 'Question'
        roots = Epmenu.roots.where(:id => collects.collect {|i|i.key1_id})  
      else
        roots = []
      end
      roots
    end

    def children(user_id,instance)
      user_id = user_id.id if user_id.is_a? User
      type = instance.class.to_s
      if type == 'Law' || type == 'Freelaw'
        parent_id_key = "key#{instance.depth + 1}_id"
        if instance.depth != 2
          law_id_key = "key#{instance.depth + 2}_id"
        else
          law_id_key = 'collectable_id'
        end
        collects = Collect.where(
          "#{parent_id_key}"=>instance.id,
          :collectable_type=>type,
          :user_id=>user_id
        ).select("distinct `#{law_id_key}` ")
        children =  Law.where(:id => collects.collect {|i|i.send("#{law_id_key}")})  
      end
      children        
    end
  end

  module LocalInstanceMethods
    # def update_keys
    #   update_keys_for_law if collectable_type == Law.to_s
    #   update_keys_for_freelaw if collectable_type == Freelaw.to_s
    #   update_keys_for_question if collectable_type == Question.to_s
    # end

    # def update_keys_for_law

    # end
  end
end

ActiveRecord::Base.send(:include, WgCollectAdapter)
