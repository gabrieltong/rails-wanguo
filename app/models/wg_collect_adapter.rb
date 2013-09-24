module WgCollectAdapter
  extend ActiveSupport::Concern
  module ClassMethods
    def setup
      include WgCollectAdapter::LocalInstanceMethods
      extend WgCollectAdapter::SingletonMethods
      
      #不需要before_save 和 after_save 都执行 ，但针对Law和Question两种情况
      # Law 需要执行 before_save , 而 Question 需要 after_save , 所以都写上了 ，
      # 在函数的开头根据需要选择执行还是不执行 。
      before_save :update_keys
      after_save :update_keys

      state_machine :collectable_type do 
        state 'Law','Freelaw' do
          def update_keys
            if self.new_record?
              collectable.path[0..2].each_with_index do |law,index|
                self.send("key#{index+1}_id=",law.id)
              end
            end
          end
        end

        state 'Question' do
          def update_keys
            unless self.new_record?
              collectable.eps.each do |ep|
                ep.epmenus.each do |epmenu|
                  Collect.find_or_create_by_user_id_and_collectable_type_and_collectable_id_and_key1_id_and_key2_id(
                    self.user_id,
                    collectable.class.to_s,
                    collectable.id,
                    epmenu.id,
                    ep.id
                  )
                end
              end
            end
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
      )

      roots = []

      if type.to_s == 'Law' || type.to_s == 'Freelaw'
        collects = collects.select('distinct `key1_id` ')
        roots = Law.roots.where(:id => collects.collect {|i|i.key1_id})  
      end

      if type.to_s == 'Question'
        collects = collects.select('distinct `key1_id` ')
        roots = Epmenu.roots.where(:id => collects.collect {|i|i.key1_id})  
      end
      
      if type.to_s == 'QuestionEp'  
        collects = Collect.where(
          :collectable_type=>'Question',
          :user_id=>user_id
        ).select('distinct `key2_id` ')
        roots = Exampoint.where(:id => collects.collect {|i|i.key2_id})  
      end
      # end
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

      if type == 'Epmenu'
        collects = Collect.where(
          :user_id=>user_id,
          :collectable_type=>'Question',
          :key1_id=>instance.id,
        ).select(%w(id,key2_id))
        children = Exampoint.where(:id=>collects.collect{|i|i.key2_id})
      end

      if type == 'Exampoint'
        collects = Collect.where(
          :user_id=>user_id,
          :collectable_type=>'Question',
          :key2_id=>instance.id,
        ).select(%w(id,collectable_id))
        children = Question.where(:id=>collects.collect{|i|i.collectable_id})
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
