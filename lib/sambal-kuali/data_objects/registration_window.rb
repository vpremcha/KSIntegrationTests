class RegistrationWindow

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  require 'base_page_classes'

  attr_accessor :term_type, :year, :period_id, :period_key, :appointment_window_info_name, :assigned_population_name,
                :start_date, :start_time, :start_time_am_pm,
                :end_date, :end_time, :end_time_am_pm, :window_type_key, :slot_rule_enum_type


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :term_type => 'Spring Term',
        :year => '2012',
        :period_id => 'All Registration Periods for this Term',
        :period_key => 'Spring Registration Period 3',
        :appointment_window_info_name => random_string,
        :assigned_population_name => 'ENGL',
        :start_date => RegistrationWindowsConstants::DATE_WITHIN,
        :start_time => '09:00',
        :start_time_am_pm => 'am',
        :end_date => RegistrationWindowsConstants::DATE_WITHIN,
        :end_time => '10:00',
        :end_time_am_pm => 'am',
        :window_type_key => 'One Slot per Window',
        :slot_rule_enum_type => 'Undergrad Standard'
    }
    options = defaults.merge(opts)
    options[:start_date] = get_date_for(RegistrationWindowsConstants::DATE_BOUND_START, options[:start_date], options[:period_key])
    options[:end_date] = get_date_for(RegistrationWindowsConstants::DATE_BOUND_END, options[:end_date], options[:period_key])
    #puts "Options = #{options}"

    set_options(options)
  end

  def add
    puts "Adding Registration Window #{@appointment_window_info_name} for Period #{@period_key}. Start Date = #{@start_date} and End Date = #{@end_date}"
    on RegistrationWindowsCreate do |page|
      page.appointment_window_info_name.set @appointment_window_info_name
      if (page.period_key.exists?)
        page.period_key.select @period_key
      end
      page.assigned_population_name.set @assigned_population_name
      #page.start_date.set get_date_for(RegistrationWindowsConstants::DATE_BOUND_START, @start_date, @period_key)
      page.start_date.set @start_date
      page.start_time.set @start_time
      page.start_time_am_pm.select @start_time_am_pm
      #page.end_date.set get_date_for(RegistrationWindowsConstants::DATE_BOUND_END, @end_date, @period_key)
      page.end_date.set @end_date
      page.end_time.set @end_time
      page.end_time_am_pm.select @end_time_am_pm
      page.window_type_key.select @window_type_key
      page.loading.wait_while_present
      if (page.slot_rule_enum_type.exists?)
        page.slot_rule_enum_type.select @slot_rule_enum_type
      end
      page.add
      while true
        begin
          sleep 1
          wait_until { page.window_collection_table.exists? }
          break
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          puts "rescued StaleElementReferenceError"
        end
      end
    end

  end



  def edit_registration_window opts={}

    defaults = {
        :update_opts => false,
        :term_type => @term_type,
        :year => @year,
        :period_id => @period_id,
        :period_key => @period_key,
        :appointment_window_info_name => @appointment_window_info_name,
        :assigned_population_name => @assigned_population_name,
        :start_date => @start_date,
        :start_time => @start_time,
        :start_time_am_pm => @start_time_am_pm,
        :end_date => @end_date,
        :end_time => @end_time,
        :end_time_am_pm => @end_time_am_pm,
        :window_type_key => @window_type_key,
        :slot_rule_enum_type => @slot_rule_enum_type
    }

    options=defaults.merge(opts)

    options[:start_date] = get_date_for(RegistrationWindowsConstants::DATE_BOUND_START, options[:start_date], options[:period_key])
    options[:end_date] = get_date_for(RegistrationWindowsConstants::DATE_BOUND_END, options[:end_date], options[:period_key])
    puts "Editing Registration Window #{options[:appointment_window_info_name]} for Period #{options[:period_key]}. Start Date = #{@start_date} and End Date = #{@end_date}"

    on RegistrationWindowsCreate do |page|
      page.edit(options[:appointment_window_info_name], options[:period_key], options[:start_date], options[:start_time], options[:start_time_am_pm], options[:end_date], options[:end_time], options[:end_time_am_pm])
    end
    if (options[:update_opts])
      set_options(options)
    end

  end

  def assign_students
    on RegistrationWindowsCreate do |page|
      page.assign_students(@appointment_window_info_name, @period_key)
    end
  end

  def break_appointments
    on RegistrationWindowsCreate do |page|
      page.break_appointments(@appointment_window_info_name, @period_key)
      page.confirm_break_appointments
    end
  end

  def delete_window(confirm_delete=true)
    puts "Deleting Registration Window #{@appointment_window_info_name}"
    on RegistrationWindowsCreate do |page|
      page.remove(@appointment_window_info_name, @period_key)
      page.loading.wait_while_present
      while true
        begin
          sleep 1
          wait_until { page.window_collection_table.exists? }
          break
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          puts "rescued StaleElementReferenceError"
        end
      end
      if confirm_delete
        page.confirm_delete
      else
        page.cancel_delete
      end
    end
  end


  def get_before_date(date)
    new_date = Date.strptime(date, '%m/%d/%Y')
    return new_date.prev_day.strftime('%m/%d/%Y')
  end

  def get_after_date(date)
    new_date = Date.strptime(date, '%m/%d/%Y')
    return new_date.next_day.strftime('%m/%d/%Y')
  end

  def get_date_for(date, date_range, period)
    #puts "get_date_for( #{date}, #{date_range} , #{period})"
    date_range_maps = get_date_range_maps
    start_dates_map = date_range_maps[RegistrationWindowsConstants::START_DATES_MAP_NAME]
    end_dates_map = date_range_maps[RegistrationWindowsConstants::END_DATES_MAP_NAME]

    if (date_range.eql? RegistrationWindowsConstants::DATE_WITHIN)
      if (date.eql? RegistrationWindowsConstants::DATE_BOUND_START)
        return start_dates_map[period]
      else
        return end_dates_map[period]
      end
    elsif (date_range.eql? RegistrationWindowsConstants::DATE_WITHIN_REVERSE)
      if (date.eql? RegistrationWindowsConstants::DATE_BOUND_START)
        return end_dates_map[period]
      else
        return start_dates_map[period]
      end
    elsif (date_range.eql? RegistrationWindowsConstants::DATE_BEFORE)
      #return start_dates_map[period]
      return get_before_date(start_dates_map[period])
    elsif (date_range.eql? RegistrationWindowsConstants::DATE_AFTER)
      #return end_dates_map[period]
      return get_after_date(end_dates_map[period])
    else
      return date_range
    end

  end

  def get_date_range_maps
    start_dates_map = {}
    end_dates_map = {}

    returend_map = {}
    on RegistrationWindowsCreate do |page|
      if (page.date_ranges.exists?)
        page.date_ranges.text.split("\n").each do |range|
          split_token = "Start Date:"
          if (range.match("End Date:"))
            split_token = "End Date:"
          end
          date_spliter = range.split(split_token)
          period_name = date_spliter.first
          period_date = date_spliter.last
          if (split_token.eql?("Start Date:"))
            start_dates_map[period_name.strip] = period_date.strip
          else
            end_dates_map[period_name.strip] = period_date.strip
          end
        end
      end
    end
    returend_map[RegistrationWindowsConstants::START_DATES_MAP_NAME] = start_dates_map
    returend_map[RegistrationWindowsConstants::END_DATES_MAP_NAME] = end_dates_map

    return returend_map
  end

end