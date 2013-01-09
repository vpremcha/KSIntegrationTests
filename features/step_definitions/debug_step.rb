When /^I setup the debug object$/ do

  @population = make Population
  @population.name = "Xf7EEgfaS6"
  @population.description = "D3pgTLrGFG"
  @population.child_populations = ["Fraternity/Sorority","New Transfers"]
  @population.status = "active"
  @population.rule = nil
  @population.reference_population = nil
  @population.type = "union-based"
  @population.operation = "union"
  @population.create



end


When /^I cleanup AOs$/ do
  @course_offering = make CourseOffering
  @course_offering.manage

  ao_list = []

  on ManageCourseOfferings do |page|
    ao_list = page.codes_list
  end

  ao_list.each do |code|
    on ManageCourseOfferings do |page|
      page.delete(code)
    end
    on ActivityOfferingConfirmDelete do |page|
      page.delete_activity_offering
    end
  end

end

When /^I smoke test the manage registration groups page$/ do
#test script shell
  @course_offering = make CourseOffering, :course=>"CHEM317"
  @course_offering.manage

#  on ManageCourseOfferings do |page|
#    puts page.ao_db_id("I")
#   end

  on ManageCourseOfferings do |page|
    page.manage_registration_groups
  end

  on ManageRegistrationGroups do |page|
    puts page.subject_code.text()

    page.create_new_cluster
    page.private_name.set "test1pri"
    page.published_name.set "test1pub"
    page.create_cluster
    #puts page.ao_table.rows.count

    puts page.cluster_list_row_name_text("test1pri")
    #  # page.ao_cluster_select.select("test1")
    #  #page.cluster_list_row_generate_reg_groups("test1")
    puts page.target_ao_row("A").cells[1].text
    puts page.target_ao_row("A").cells[2].text
    page.select_ao_row("A")
    page.ao_cluster_select.select("test1pub")
    page.ao_cluster_assign_button
  end
end
