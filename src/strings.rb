require_relative 'commands.rb'
require 'colorize'

class Strings < Commands
  OPENING_MESSAGE = "Welcome to my very own task manager!".colorize(:blue)
  COMMANDS = "Commands:\n#{TASK}\n#{REMINDER}\n#{PAUSE}\n#{FINISH}\n#{EXIT}".colorize(:green)
  MAKE_SELECTION = "Please choose one of the following commands:".colorize(:blue)
  FIRST_LINE_OF_OUT_PUT = "Task Name~ Start Time~ End Time~ Total Time\n"
  ENTER_TASK_NAME = "Enter new task name or enter the name of a paused task to continue it:".colorize(:blue)
  PAUSED_TASKS = "Paused:\n".colorize(:blue)
  ACTIVE_REMINDERS = "Active Reminders:\n".colorize(:blue)
  ENTER_REMINDER_NAME = "Enter reminder name:".colorize(:blue)
  ENTER_REMINDER_TIME = "Enter time to be reminded at or number of minutes to be reminded in:".colorize(:blue)
  INVALID = "Invalid".colorize(:red)
end
