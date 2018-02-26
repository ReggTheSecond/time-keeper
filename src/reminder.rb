require 'date'
require_relative 'time_constants.rb'
require 'colorize'
class Reminder < TimeConstants
  attr_accessor :reminder_name
  attr_accessor :finish_time
  REMINDER_COMPLETE = "Reminder: "

  def set_time_to_be_reminded_at(reminder_time)
    @finish_time = DateTime.parse(DateTime.now().strftime("%Y-%m-%dT#{reminder_time}"))
  end

  def remind_in_number_of_minutes(number_of_minutes)
    @finish_time = Time.now() + (number_of_minutes * SECONDS_IN_A_MINUTE)
  end

  def wait_for_finish_time()
    if @finish_time.class == Time
      while @finish_time > Time.now()
      end
    else
      while @finish_time > DateTime.now()
      end
    end
    puts "#{REMINDER_COMPLETE}#{@reminder_name.colorize(:blue)}"
    system "aplay -q data/audio_files/Alesis-Fusion-Bass-C3.wav"
  end

  def match_HHMM_format(reminder_time)
    return reminder_time.match(/^\d\d:\d\d$/)
  end

  def valid_time_format(reminder_time)
    return reminder_time.split(":").last().to_i() < MINUTES_IN_A_HOUR
  end

  def match_MM_format(reminder_time)
    return reminder_time.match(/^s\d+$/)
  end

  def to_csv()
    return "#{@reminder_name}~#{@finish_time}"
  end
end
