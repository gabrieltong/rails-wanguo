# encoding: UTF-8
class Istudy
  Map = [
    {:title=>'民法',:ratio=>0.16,:law_ratio=>0.2,:law_cost=>96,:question_cost=>18},
    {:title=>'刑法',:ratio=>0.16,:law_ratio=>0.2,:law_cost=>96,:question_cost=>15},
    {:title=>'行政法',:ratio=>0.08,:law_ratio=>0.2,:law_cost=>48,:question_cost=>8},
    {:title=>'法理学',:ratio=>0.06,:law_ratio=>0.5,:law_cost=>10000,:question_cost=>9},
    {:title=>'法制史',:ratio=>0.02,:law_ratio=>0.5,:law_cost=>10000,:question_cost=>4},
    {:title=>'宪法',:ratio=>0.03,:law_ratio=>0.5,:law_cost=>18,:question_cost=>9},
    {:title=>'司法制度',:ratio=>0.02,:law_ratio=>0.5,:law_cost=>12,:question_cost=>5},
    {:title=>'商法',:ratio=>0.08,:law_ratio=>0.5,:law_cost=>48,:question_cost=>13},
    {:title=>'经济法',:ratio=>0.07,:law_ratio=>0.5,:law_cost=>42,:question_cost=>12},
    {:title=>'刑诉',:ratio=>0.12,:law_ratio=>0.8,:law_cost=>72,:question_cost=>40},
    {:title=>'民诉',:ratio=>0.12,:law_ratio=>0.8,:law_cost=>72,:question_cost=>45},
    {:title=>'国际法',:ratio=>0.02,:law_ratio=>0.8,:law_cost=>12,:question_cost=>10},
    {:title=>'国际私法',:ratio=>0.03,:law_ratio=>0.8,:law_cost=>18,:question_cost=>13},
    {:title=>'国际经济法',:ratio=>0.03,:law_ratio=>0.8,:law_cost=>18,:question_cost=>15}
  ]

  # 根据现在的能力预测考试通过率
  def self.evaluate(user)
    self.complex(user)
  end

  # 综合能力
  def self.complex(user)
    correct_rate_ratio = 0.5
    xueba_ratio = 0.3
    summary_ratio = 0.2

    xueba_full = 8

    [self.xueba(user),xueba_full].min*1.0/xueba_full*xueba_ratio
     +
    History.correct_rate(user)*correct_rate_ratio
     +
    self.epmenus_summaries(user)[:total]*summary_ratio
  end


  # 学霸指数
  def self.xueba(user)
    (Heartbeat.duration(Heartbeat.ranges(user,Law))*1.0/60/3).to_i*0.1
  end

  # 取得用户部门法学习情况
  def self.epmenu_summary(user,type)
    lr = law_ratio(user,type)
    qr = question_ratio(user,type)
    {
      :law_ratio=>lr,
      :question_ratio=>qr,
      :ratio=>lr+qr
    }
  end

  # 整体学习进度
  def self.epmenus_summaries(user)
    result = {
      :total=>0,
      :epmenus=>{}
    }
    Map.collect{|i|i[:title]}.each do |type|
      result[:epmenus][type] = self.epmenu_summary(user,type)
      result[:total] += result[:epmenus][type][:ratio]
    end
    
    result
  end

  # 取得用户某部门法的法条学习情况
  def self.law_ratio(user,type)
    setting = self.setting(type)
    law = Law.find_by_title(type)
    if law 
      heatbeats = Heartbeat.summary(user,law)
      seconds =  heatbeats.inject(0){|sum,i|sum+i[:duration]}
      law_ratio = [(seconds/60/setting[:law_cost]).to_i/100.0,setting[:law_ratio]].min
      law_ratio
    else
      0
    end      
  end

  # 得到某部门法的真题学习情况
  def self.question_ratio(user,type)
    setting = self.setting(type)
    epmenu = Epmenu.find_by_title(type)
    if epmenu
      right_count = History.by_epmenu(epmenu).by_user(user).right.count()
      question_ratio = [(right_count/setting[:question_cost]).to_i/100.0,(1-setting[:law_ratio])].min
      question_ratio
    else
      0
    end
  end

  # 取得某部门法的设置
  def self.setting(type)
    Istudy::Map.detect {|i|i[:title]==type}
  end
end