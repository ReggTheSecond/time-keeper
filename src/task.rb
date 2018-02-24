require 'date'
require_relative 'time_constants.rb'
require 'time_difference'

class Task < TimeConstants
  attr_accessor :task_name
  attr_accessor :start_time
  attr_accessor :pause_time
  attr_accessor :unpaused_time
  attr_accessor :end_time
  attr_accessor :total_time

  def name_task(name)
    @task_name = name
  end

  def start_task()
    @start_time = Time.now()
  end

  def pause_task()
    if first_pause?()
      @pause_time = Time.now()
      @total_time = TimeDifference.between(@start_time, @pause_time).in_seconds()
    else
      @latest_pause = Time.now()

      @total_time = @total_time + TimeDifference.between(@unpaused_time, @latest_pause).in_seconds()
      @pause_time = @latest_pause
    end
  end

  def unpause_task()
    @unpaused_time = Time.now()
  end

  def first_pause?()
    if @pause_time.class() == NilClass
      return true
    else
      return false
    end
  end

  def was_paused?()
    if @unpaused_time.class() == NilClass
      return false
    else
      return true
    end
  end

  def end_task()
    @end_time = Time.now()
    if was_paused?()
      @total_time = @total_time + TimeDifference.between(@unpaused_time, @end_time).in_seconds()
    else
      @total_time = TimeDifference.between(@start_time, @end_time).in_seconds()
    end
  end

  def get_end_time()
    if @end_time.class == NilClass
      return ""
    end
    return @end_time.strftime("%H:%M:%S")
  end

  def to_s()
    return "Task Name: #{@task_name}\nStarted: #{@start_time.strftime("%H:%M:%S")}\nFinished: #{get_end_time()}\nTotal Time: #{display_time_in_HMS(@total_time)}"
  end

  def to_csv
    return "#{@task_name}~ #{@start_time.strftime("%H:%M:%S")}\~ #{@end_time.strftime("%H:%M:%S")}~ Total Time: #{display_time_in_HMS(@total_time)}\n"
  end

  def display_time_in_HMS(time_diff)
    hours = (time_diff / SECONDS_IN_A_HOUR).to_i
    time_diff = time_diff - (SECONDS_IN_A_HOUR * hours).to_i
    minutes = (time_diff / SECONDS_IN_A_MINUTE).to_i
    seconds = (time_diff - SECONDS_IN_A_MINUTE * minutes).to_i
    hours = add_leading_zero_if_less_than_10(hours)
    minutes = add_leading_zero_if_less_than_10(minutes)
    seconds = add_leading_zero_if_less_than_10(seconds)
    return "#{hours}:#{minutes}:#{seconds}"
  end

  def add_leading_zero_if_less_than_10(number)
    if number < TEN
      return number.to_s.rjust(LEADING_ZEROS, "0")
    end
    return number
  end
end
