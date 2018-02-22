require_relative 'task.rb'
require 'date'
require 'colorize'

class TaskTracker
  attr_accessor :active_task
  attr_accessor :paused_tasks
  attr_accessor :complete_tasks

  def initialize()
    @paused_tasks = Array.new()
    @complete_tasks = Array.new()
  end

  def pause_task()
    @active_task.pause_task()
    @paused_tasks << @active_task
    @active_task = NilClass
  end

  def unpause_task(task_name)
    @paused_tasks.each do |paused_task|
      if task_paused?(task_name)
        @active_task = paused_task
        @active_task.unpause_task()
        @paused_tasks.delete(paused_task)
      end
    end
  end

  def new_task(task_name)
    if task_paused?(task_name)
      unpause_task(task_name)
    else
      @active_task = Task.new()
      @active_task.name_task(task_name)
      @active_task.start_task()
    end
  end

  def end_active_task()
    @active_task.end_task()
    puts @active_task.to_s().colorize(:blue)
    @complete_tasks << @active_task
    @active_task = NilClass
  end

  def task_paused?(task_name)
    @paused_tasks.each do |paused_task|
      if paused_task.task_name == task_name
        return true
      end
    end
    return false
  end

  def list_paused_tasks()
    @paused_tasks.each do |task|
      puts task.to_s.colorize(:light_blue)
    end
  end

  def end_paused_tasks()
    @paused_tasks.each do |task|
      task.end_task()
      @complete_tasks << task
    end
  end

  def get_csv_of_complete_tasks()
    csv = ""
    @complete_tasks.each do |task|
      csv << task.to_csv()
    end
    return csv
  end

  def shut_down()
    if @active_task != NilClass
      end_active_task()
    end
    end_paused_tasks()
    return get_csv_of_complete_tasks()
  end
end
