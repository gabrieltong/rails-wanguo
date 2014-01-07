class Activity < ActiveRecord::Base
  define_statistic :play_audio_count, :count => :all,:conditions=>{:key=>'law.play_audio'}#,:filter_on =>{:trackable_type=>"trackable_type=?",:trackable_id=>"trackable_id=?" }
  define_statistic :open_blank_count, :count => :all,:conditions=>{:key=>'law.open_blank'}

  # filter_all_stats_on(:key,"key=?")
  filter_all_stats_on(:trackable_type, "trackable_type = ?")
  # filter_all_stats_on(:trackable_id,"trackable_id=?")
end