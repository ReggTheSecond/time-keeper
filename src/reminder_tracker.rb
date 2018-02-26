

class ReminderTracker
  attr_accessor :active_reminders
  attr_accessor :completed_reminders
  attr_accessor :active_reminders_file
  ACTIVE_REMINDERS_FILE_PATH = "data/active_reminders.csv"

  def initialize()
    @active_reminders_file= File.open(ACTIVE_REMINDERS_FILE_PATH, 'a+')
    @active_reminders = Array.new()
    @completed_reminders = Array.new()
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

  def write_to_file
    @active_reminders_file << active_reminders_to_csv()
  end
end
