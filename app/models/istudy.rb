# encoding: UTF-8
class Istudy
  Map = [ 
    {
      :title=>'社会主义法治理念',
       :radio=>0.01,
       :law_ratio=>0.2, 
       # 没有法条进度 ， 设置一个较大值
       :law_cost=>10000 ,
       :question_cost=>5 
    },
    {
      :title=>'法理学',
      :radio=>0.06,
      :law_ratio=>0.5, 
      # 没有法条进度 ， 设置一个较大值
      :law_cost=>10000 ,
      :question_cost=>9 
    },
    {
      :title=>'法制史',
      :radio=>0.02,
      :law_ratio=>0.5, 
      # 没有法条进度 ， 设置一个较大值
      :law_cost=>10000 ,
      :question_cost=>4 
    },
    {
      :title=>'宪法',
      :radio=>0.03,
      :law_ratio=>0.5, 
      :law_cost=>18,
      :question_cost=>9 
    },
    {
      :title=>'经济法',
      :radio=>0.07,
      :law_ratio=>0.5, 
      :law_cost=>42,
      :question_cost=>12
    },
    {
      :title=>'国际法',
      :radio=>0.02,
      :law_ratio=>0.8, 
      :law_cost=>12,
      :question_cost=>10
    },
    {
      :title=>'国际私法',
      :radio=>0.03,
      :law_ratio=>0.8, 
      :law_cost=>18,
      :question_cost=>13
    },
    {
      :title=>'国际经济法',
      :radio=>0.03,
      :law_ratio=>0.8, 
      :law_cost=>18,
      :question_cost=>15
    },
    {
      :title=>'司法制度和法律职业道德',
      :radio=>0.01,
      :law_ratio=>0.5, 
      :law_cost=>12,
      :question_cost=>5 
    },
    {
      :title=>'刑法',
      :radio=>0.06,
      :law_ratio=>0.2, 
      :law_cost=>96,
      :question_cost=>15
    },
    {
      :title=>'刑事诉讼法',
      :radio=>0.02,
      :law_ratio=>0.8, 
      :law_cost=>72,
      :question_cost=>40
    },
    {
      :title=>'行政法与行政诉讼法',
      :radio=>0.08,
      :law_ratio=>0.2, 
      :law_cost=>48,
      :question_cost=>8 
    },
    {
      :title=>'民法',
      :radio=>0.06,
      :law_ratio=>0.2, 
      :law_cost=>96,
      :question_cost=>18
    },
    {
      :title=>'商法',
      :radio=>0.08,
      :law_ratio=>0.5, 
      :law_cost=>48,
      :question_cost=>13
    },
    {
      :title=>'民事诉讼法与仲裁制度',
      :radio=>0.12,
      :law_ratio=>0.8, 
      :law_cost=>72,
      :question_cost=>45
    },
    
  ]

  def self.cache_complex
    User.all.each do |user|
      user.complex = Istudy.complex(user)

      user.save :validate=>false
    end
  end

  # 根据现在的能力预测考试通过率
  def self.evaluate(user)
    self.complex(user)
  end

  # 综合实力排名
  def self.complex_rank(user)
    {:total=>User.count()+500, :rank=>User.where("complex > ?",user.complex).count()+1+500,:value=>user.complex}
  end

  # 综合能力数值
  def self.complex(user)
    correct_rate_ratio = 0.5
    xueba_ratio = 0.3
    summary_ratio = 0.2

    xueba_full = 8

    a = [self.xueba(user),xueba_full].min*1.0/xueba_full*xueba_ratio
    b = History.correct_rate(user)*correct_rate_ratio
    c = self.epmenus_summaries(user)[:total]*summary_ratio

    # [self.xueba(user),xueba_full].min*1.0/xueba_full*xueba_ratio
    #  +
    # History.correct_rate(user)*correct_rate_ratio
    #  +
    # self.epmenus_summaries(user)[:total]*summary_ratio
    (a + b + c).round(3)
  end

  # 学霸指数
  def self.xueba(user)
    seconds = user.heartbeats.statistics[:sum_time]
    days_size = user.heartbeats.collect{|h|h.created_at.to_date}.uniq.size
    avg = (days_size==0 ? 0 : seconds*1.0/days_size)
    [((avg*1.0/60/3).to_i*0.1).round(3),8].min
  end

  # 部门法子项的进度情况
  def self.sub_epmenus_summaries(user,id)
    Epmenu.find(id).children.collect do |epmenu|
      ss = History.mastered_status(epmenu,user)
      {
        :title=>epmenu.title,
        :radio=> ss[:total]==0 ? 0 : ss[:mastered].size*1.0/ss[:total]
      }
    end
  end

  # 取得用户部门法学习情况
  def self.epmenu_summary(user,type)
    lr = law_ratio(user,type)

    setting = self.setting(type)

    epmenu = Epmenu.find_by_title(type)

    mastered_status = History.mastered_status(epmenu,user)      

    question_ratio = [(mastered_status[:mastered].size/setting[:question_cost]).to_i/100.0,(1-setting[:law_ratio])].min

    mastered_status[:mastered] = mastered_status[:mastered].size
    mastered_status[:unmastered] = mastered_status[:unmastered].size
    {
      :id=>epmenu.try(:id) || 0,
      :title=>type,
      :law_ratio=>lr,
      :question_ratio=>question_ratio,
      :mastered_status=>mastered_status,
      :ratio=>lr+question_ratio
    }
  end

  # 整体学习进度
  def self.epmenus_summaries(user)
    result = {
      :total=>0,
      :epmenus=>[]
    }
    # 遍历部门法，得到每个部门法的信息，
    Map.collect{|i|i[:title]}.each do |type|
      # result[:epmenus][type] = self.epmenu_summary(user,type)
      # result[:total] += result[:epmenus][type][:ratio]
      # 得到
      data = self.epmenu_summary(user,type)
      result[:epmenus].push data
      # result[:epmenus][type] = self.epmenu_summary(user,type)
      # 计算总进度
      result[:total] += data[:ratio]
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

  # 学员的学习时间 ， 单位秒
  def self.time(user)
    
  end
  # # 得到某部门法的真题学习情况
  # def self.question_ratio(user,type)
    
  # end

  # 取得某部门法的设置
  def self.setting(type)
    Istudy::Map.detect {|i|i[:title]==type}
  end
end