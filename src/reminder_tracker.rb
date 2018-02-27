require_relative 'reminder.rb'

class ReminderTracker
  attr_accessor :active_reminders
  attr_accessor :completed_reminders
  attr_accessor :active_reminders_file
  ACTIVE_REMINDERS_FILE_PATH = "data/active_reminders.csv"

  def initialize()
    @active_reminders_file= File.open(ACTIVE_REMINDERS_FILE_PATH, 'r+')
    @active_reminders = Array.new()
    @completed_reminders = Array.new()
    open_active_reminders()
  end

  def add_new_reminder(reminder)
    @active_reminders << reminder
  end

  def remove_complete_reminder(complete_reminder)
    @active_reminders.each do |reminder|
      if reminder = complete_reminder
        @active_reminders.delete(reminder)
        @completed_reminders << reminder
      end
    end
  end

  def list_reminders()
    csv = ""
    @active_reminders.each do |reminder|
      csv << "#{reminder.to_csv()}\n"
    end
    return csv.colorize(:light_blue)
  end

  def active_reminders_to_csv()
    csv = ""
    @active_reminders_file.each do |reminder|
      csv << reminder.to_csv()
    end
    return csv
  end

  def shut_down()
    @active_reminders.each do |reminder|
      active_reminders_file << reminder.to_csv
    end
    write_to_file()
  end

  def write_to_file
    @active_reminders_file << active_reminders_to_csv()
  end

  def open_active_reminders()
    @active_reminders_file.each_line() do |reminder|
      new_reminder = to_reminder(reminder)  
      @active_reminders << new_reminder
    end
  end

  def to_reminder(reminder)
    new_reminder = Reminder.new()
    new_reminder.reminder_name = reminder.split("~").first()
    new_reminder.finish_time = reminder.split("~").last()
    return new_reminder
  end
end
