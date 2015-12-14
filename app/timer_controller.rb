class TimerController < UIViewController
  attr_reader :timer

  def viewDidLoad
    @status_hash = { initial: 0, stopped: 1, ended: 2, counting: 3}
    @time = 20
    @status = @status_hash[:initial]
    margin = 5
    p @status.to_s
    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(50)
    @state.text = @time.to_s
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.whiteColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 200], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@state)

    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Start', forState:UIControlStateNormal)
    @action.setTitle('Stop', forState:UIControlStateSelected)
    @action.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    @action.frame = [[margin, 400], [view.frame.size.width - margin * 2, 40]]
    @action.font = UIFont.systemFontOfSize(50)
    view.addSubview(@action)


  end

  # ボタンタップ時に走るメソッド
  def actionTapped
    if @timer
      # stopを押した時
      @timer.invalidate
      @timer = nil
      @saved_time = @duration
      @status = @status_hash[:stopped]
    else
      # startを押した時
      if @status == @status_hash[:stopped]
        @duration = @saved_time
      else
        @duration = @time
      end
      @timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
      @status = @status_hash[:counting]
    end
    # actionの状態を逆にする
    @action.selected = !@action.selected?
  end


  def timerFired
    @duration -= 1
    @state.text = @duration.to_s
    if @state.text == '0'
      @state.text = 'TimeUp'
      @timer.invalidate
      @action.selected = false
      @timer = nil
      @duration = nil
      @status = @status_hash[:ended]
    end
  end
end