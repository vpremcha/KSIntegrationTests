class ViewPopulationDiag < PopulationsBase

  def frm
    self.frame(class: "fancybox-iframe")
  end

  include PopulationsSearch

  value(:name) { |b| b.frm.div(data_label: "Name").span(index: 2).text }
  value(:description) { |b| b.frm.div(data_label: "Description").span(index: 2).text }
  value(:state) { |b| b.frm.div(data_label: "State").span(index: 1).text }
  value(:rule) { |b| b.frm.div(data_label: "Rule").span(index: 2).text }
  action(:close) { |b| b.frm.button(text: "Close").click; b.loading.wait_while_present }

end