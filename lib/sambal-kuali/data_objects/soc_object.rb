class ManageSoc

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :term_code

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term_code=>"20122"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def search
    go_to_manage_soc
    on ManageSocPage do |page|
      page.term_code.set @term_code
      page.go_action
    end
  end

  def check_valid_state(currentState)
    on ManageSocPage do |page|
      case(currentState)
        when 'Open'
          raise "SOC is not Open" unless page.lock_button.exists? and page.lock_button.enabled?
        when 'Lock'
          raise "SOC is not in final edit state" unless page.final_edit_button.exists? and page.final_edit_button.enabled?
        when 'FinalEdit'
          raise "SOC is not in final edit state" unless page.final_edit_button.exists? and page.final_edit_button.enabled?
        when 'Schedule'
          raise "Send to Scheduler action not available" unless page.send_to_scheduler_button.exists? and page.send_to_scheduler_button.enabled?
          raise "Final edit button not exists or disabled" unless page.final_edit_button.exists? and page.final_edit_button.disabled?
        else
          raise "Your Soc State value must be one of the following:\n'Open', 'FinalEdit'.\nPlease update your script"
      end
    end
  end

  def check_state_change_button_exists(currentState)
    on ManageSocPage do |page|
    case(currentState)
        when 'Lock'
          raise "SOC is not enabled for Lock" unless page.lock_button.enabled? and page.soc_status == 'Open'
        when 'FinalEdit'
          raise "SOC is not in final edit state" unless page.final_edit_button.enabled? and page.soc_status == 'Locked' and page.soc_scheduling_status == 'Completed'
        when 'Schedule'
          raise "Send to Scheduler action not available" unless page.send_to_scheduler_button.enabled?
          raise "Final edit button not exists or disabled" unless page.final_edit_button.disabled?
          raise "SOC is not in Lock state or scheduling state is not completed" unless page.soc_status == 'Locked'
        when 'Publish'
          raise "SOC is not in publish state" unless page.publish_button.enabled? and page.soc_status == 'Final Edits' and page.soc_scheduling_status == 'Completed'
        when 'Close'
          raise "SOC is not in close state" unless page.close_button.exists? and page.soc_status == 'Published' and page.soc_publishing_status == 'Published'
        else
          raise "Your Soc State value must be one of the following:\n'Open', \n'Lock', \n'FinalEdit', \n'Schedule', \n'Publish', 'Close'.\nPlease update your script"
        end
    end
  end

  def change_action(newState,confirmStateChange)
    validate_confirm_option(confirmStateChange)
    on ManageSocPage do |page|
      case(newState)
        when 'Lock'
          page.lock_action
          if confirmStateChange == 'Yes'
            page.lock_confirm_action
          else
            page.lock_cancel_action
          end
        when 'Schedule'
          schedule_soc page,confirmStateChange
        when 'FinalEdit'
          page.final_edit_action
          if confirmStateChange == 'Yes'
            page.final_edit_confirm_action
          else
            page.final_edit_cancel_action
          end
        when 'Publish'
          publish_soc page,confirmStateChange
        else
          raise "Your Soc State value must be one of the following:\n'Lock', 'FinalEdit'.\nPlease update your script"
      end
    end
  end


  def schedule_soc(page,confirmStateChange)
    page.send_to_scheduler_action
    if confirmStateChange == 'Yes'
      page.schedule_confirm_action
      tries = 0
      until page.final_edit_button.enabled? or tries == 6 do
        sleep 20
        tries += 1
        search
      end
    else
      page.schedule_cancel_action
    end
  end


  def publish_soc(page,confirmStateChange)
    page.publish_action
    if confirmStateChange == 'Yes'
      page.publish_confirm_action
      raise "SOC status doesnt change to Publishing In Progress" unless page.soc_status == 'Publishing In Progress'
      raise "Close button not displayed" unless page.close_button.exists?
      tries = 0
      until page.soc_status == 'Published' or tries == 6 do
        sleep 20
        tries += 1
        search
      end
    else
      page.publish_cancel_action
    end
  end

  def validate_confirm_option(confirmStateChange)
    case confirmStateChange
      when 'Yes'
      when 'No'
      else
        raise "Invalid confirm dialog option. It should be either 'Yes' or 'No'"
    end
  end

end