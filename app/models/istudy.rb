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

  
  # 学霸指数
  def self.index(user)
    ranges = Heartbeat.ranges(user,Law)
    duration = Heartbeat.duration(ranges)
    # p duration
    days = Heartbeat.days(ranges)
    {
      # :duration=>(Time.parse('2000-1-1 00:00:00') + duration.seconds).strftime("%H:%M:%S"),
      :duration=>duration,
      :days=>days,
      :index=>(duration/60.0/3.0/days.size * 0.1).to_i
    }
  end

  # 每个部门法的整体学习进度（计算方法详见istudy中的表格）
  def self.epmenu_schedule(user,type)
    type = Map.collect{|i|i[:title]} if type == nil
    lr = law_radio(user,type)
    qr = question_radio(user,type)
    {
      :law_radio=>lr,
      :question_radio=>qr,
      :radio=>lr+qr
    }
  end

  def self.epmenu_schedules(user)
    Map.collect{|i|i[:title]}.collect do |type|
      [type,summary(user,type)]
    end
  end

  # 每个部门法的整体学习进度 法条部分
  def self.law_radio(user,type)
    setting = self.setting(type)
    heatbeats = Heartbeat.summary(user,Law.find_by_title(type))
    seconds =  heatbeats.inject(0){|sum,i|sum+i[:duration]}
    law_radio = [(seconds/60/setting[:law_cost]).to_i/100.0,setting[:law_radio]].min
    law_radio
  end

  # 每个部门法的整体学习进度 真题部分
  def self.question_radio(user,type)
    setting = self.setting(type)
    epmenu = Epmenu.find_by_title(type)
    right_count = History.right_count(user,epmenu)
    question_radio = [(right_count/setting[:question_cost]).to_i/100.0,(1-setting[:law_radio])].min
    question_radio
  end

  # 取得某部门法的设置
  def self.setting(type)
    Istudy::Map.detect {|i|i[:title]==type}
  end
end