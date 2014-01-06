class Activity < ActiveRecord::Base
  define_statistic :total_score, :count => :all

  filter_all_stats_on(:trackable_type,"trackable_type=?")
  filter_all_stats_on(:trackable_id,"trackable_id=?")
end