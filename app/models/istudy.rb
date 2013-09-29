# encoding: UTF-8
class Istudy
  Map = [
    {:title=>'民法',:radio=>0.16,:law_radio=>0.2,:law_cost=>96,:question_cost=>18},
    {:title=>'刑法',:radio=>0.16,:law_radio=>0.2,:law_cost=>96,:question_cost=>15},
    {:title=>'行政法',:radio=>0.08,:law_radio=>0.2,:law_cost=>48,:question_cost=>8},
    {:title=>'法理学',:radio=>0.06,:law_radio=>0.5,:law_cost=>10000,:question_cost=>9},
    {:title=>'法制史',:radio=>0.02,:law_radio=>0.5,:law_cost=>10000,:question_cost=>4},
    {:title=>'宪法',:radio=>0.03,:law_radio=>0.5,:law_cost=>18,:question_cost=>9},
    {:title=>'司法制度',:radio=>0.02,:law_radio=>0.5,:law_cost=>12,:question_cost=>5},
    {:title=>'商法',:radio=>0.08,:law_radio=>0.5,:law_cost=>48,:question_cost=>13},
    {:title=>'经济法',:radio=>0.07,:law_radio=>0.5,:law_cost=>42,:question_cost=>12},
    {:title=>'刑诉',:radio=>0.12,:law_radio=>0.8,:law_cost=>72,:question_cost=>40},
    {:title=>'民诉',:radio=>0.12,:law_radio=>0.8,:law_cost=>72,:question_cost=>45},
    {:title=>'国际法',:radio=>0.02,:law_radio=>0.8,:law_cost=>12,:question_cost=>10},
    {:title=>'国际私法',:radio=>0.03,:law_radio=>0.8,:law_cost=>18,:question_cost=>13},
    {:title=>'国际经济法',:radio=>0.03,:law_radio=>0.8,:law_cost=>18,:question_cost=>15}
  ]

  # 取得用户部门法学习情况
  def self.summary(user,type)
    setting = self.setting(type)
    return nil unless setting
    return nil unless Law.find_by_title(type)
    
  end

  # 取得用户某部门法的法条学习情况
  def self.law_radio(user,type)
    setting = self.setting(type)
    heatbeats = Heartbeat.summary(user,Law.find_by_title(type)
    seconds =  heatbeats.inject(0) {|sum,i|sum+i[:duration]}
    law_radio = [(seconds/60/setting[:law_cost]).to_i/100.0,setting[:law_radio]].min
    law_radio
  end

  # 取得某部门法的设置
  def self.setting(type)
    Istudy::Map.detect {|i|i[:title]==type}
  end


end