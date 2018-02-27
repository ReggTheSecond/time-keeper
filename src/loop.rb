require_relative 'task_tracker.rb'
require_relative 'reminder_tracker.rb'
require_relative 'reminder.rb'
require_relative 'commands.rb'
require_relative 'strings.rb'
require 'date'
require 'colorize'

class RunTaskTracker < Strings
  attr_accessor :task_tracker
  attr_accessor :reminder_tracker
  attr_accessor :file_of_days_tasks
  attr_accessor :should_exit
  FILE_NAME = "data/Tasks #{DateTime.now().to_date()}"

  def initialize()
    @should_exit = ""
    if File.exist?(FILE_NAME)
      @file_of_days_tasks = File.open(FILE_NAME, 'a+')
    else
      @file_of_days_tasks = File.open(FILE_NAME, 'a+')
      @file_of_days_tasks << FIRST_LINE_OF_OUT_PUT
    end
    @task_tracker = TaskTracker.new()
    @reminder_tracker = ReminderTracker.new()
    run_loop()
  end

  def command_entered(text_entered)
    return text_entered == PAUSE || text_entered == FINISH || text_entered == EXIT || text_entered == TASK || text_entered == REMINDER || text_entered == EXIT_SHORT || text_entered == PAUSE_SHORT || text_entered == FINISH_SHORT || text_entered == TASK_SHORT|| text_entered == REMINDER_SHORT
  end

  def complete_command(command)
    if command == PAUSE || command == PAUSE_SHORT
      @task_tracker.pause_task()
    elsif command == FINISH || command == FINISH_SHORT
      @task_tracker.end_active_task()
    elsif command == EXIT || command == EXIT_SHORT
      shut_down()
    elsif command == TASK || command == TASK_SHORT
      create_task()
    elsif command == REMINDER || command == REMINDER_SHORT
      create_reminder()
    end
  end

  def run_loop()
    restart_unfunished_active_reminders()
    puts OPENING_MESSAGE
    begin
      puts MAKE_SELECTION
      puts "#{ACTIVE_TASK}#{@task_tracker.get_active_task_name()}"
      puts "#{PAUSED_TASKS}#{@task_tracker.list_paused_tasks()}\n"
      puts "#{ACTIVE_REMINDERS}#{@reminder_tracker.list_reminders()}\n"#{#{ACTIVE_REMINDERS}}
      puts COMMANDS
      text_entered = gets.chomp
      text_entered = text_entered.strip.downcase
      if command_entered(text_entered)
        complete_command(text_entered)
      end
    end while @should_exit != EXIT
  end

  def create_task()
    @task_tracker.list_paused_tasks()
    puts ENTER_TASK_NAME
    task_name = gets.chomp
    if task_name != ""
      @task_tracker.new_task(task_name)
    end
  end

  def create_reminder()
    reminder = Reminder.new()
    puts ENTER_REMINDER_NAME
    name = gets.chomp
    name = name.strip
    reminder.reminder_name =  name
    puts ENTER_REMINDER_TIME
    reminder_time = gets.chomp
    if reminder.match_HHMM_format(reminder_time) && reminder.valid_time_format(reminder_time)
      reminder.set_time_to_be_reminded_at(reminder_time)
      @reminder_tracker.add_new_reminder(reminder)
      Thread.new{start_reminder(reminder)}
    elsif reminder.match_MM_format(reminder_time)
      reminder.remind_in_number_of_minutes(reminder_time.to_i())
      @reminder_tracker.add_new_reminder(reminder)
      Thread.new{start_reminder(reminder)}
    else
      puts INVALID
    end
  end

  def restart_unfunished_active_reminders()
    @reminder_tracker.active_reminders.each do |reminder|
      Thread.new{start_reminder(reminder)}
    end
  end

  def start_reminder(reminder)
    reminder.wait_for_finish_time()
    @reminder_tracker.remove_complete_reminder(reminder)
  end

  def shut_down()
    @file_of_days_tasks << @task_tracker.shut_down()
    @reminder_tracker.shut_down()
    @should_exit = EXIT
  end
end

t1 = Thread.new{RunTaskTracker.new}
t1.join()
