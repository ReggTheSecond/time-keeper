require_relative 'task_tracker.rb'
require_relative 'reminder.rb'
require 'date'
require 'colorize'


def do_this_when_there_is_an_active_task()
  puts "Enter END when task complete; Enter EXIT when finished or PAUSE to pause the task.".colorize(:red)
  complete = gets.chomp
  return complete.strip.downcase
end

def create_task(task_tracker, file_of_days_tasks)
  task_tracker.list_paused_tasks()
  puts "Enter new task name or enter the name of a paused task to continue it or enter EXIT to shut down:".colorize(:green)
  task_name = gets.chomp
  if task_name == ""
  elsif task_name.strip.downcase == "exit"
    shut_down(task_tracker, file_of_days_tasks)
    return task_name.strip.downcase
  else
    task_tracker.new_task(task_name)
    return ""
  end
end

def shut_down(task_tracker, file_of_days_tasks)
  file_of_days_tasks << task_tracker.shut_down()
end

def shut_down?(task_tracker, file_of_days_tasks)
  puts "No task name entered, press ENTER to continue and enter a task name or enter EXIT to shut down"
  continue = gets.chomp
  continue = continue.strip.downcase
  if continue == "exit"
    shut_down(task_tracker, file_of_days_tasks)
  else
    do_this_when_there_is_no_active_task()
  end
end

def active_task?(task_tracker)
  return task_tracker.active_task.class == Task
end

def make_selection(task_tracker)
  puts "Would you like to set a Reminder (REMINDER), Start Tracking a Task (TASK) or Exit (EXIT)"
  selection = gets.chomp
  selection = selection.strip.downcase
  if selection == "task"
    complete = create_task(task_tracker, file_of_days_tasks)
  elsif selection == "reminder"
    complete = create_reminder()
  end
  return complete
end

def create_reminder()
  reminder = Reminder.new()
  puts "Enter reminder name:"
  name = gets.chomp
  name = name.strip
  reminder.reminder_name =  name
  puts "Enter time to be reminded at or number of minutes to be reminded in:"
  reminder_time = gets.chomp
  if reminder_time.match(/\d\d:\d\d/)
    reminder.set_time_to_be_reminded_at(reminder_time)
    Thread.new{reminder.wait_for_finish_time()}
  else
    puts "Invalid"
  end
end

def main()
  task_tracker = TaskTracker.new()
  file_of_days_tasks = File.open("data/Tasks #{DateTime.now().to_date()}-test", 'a+')
  file_of_days_tasks << "Task Name~ Start Time~ End Time~ Total Time\n"
  begin
    if active_task?(task_tracker)
      complete = do_this_when_there_is_an_active_task()
    else
      make_selection(task_tracker)
    end
    if complete == "pause"
      task_tracker.pause_task()
    elsif complete == "end"
      task_tracker.end_active_task()
    elsif complete == "exit"
      shut_down(task_tracker, file_of_days_tasks)
    end
  end while complete != "exit"
  file_of_days_tasks.close
end

t1 = Thread.new{main()}
t1.join()
