class ActivityOfferingInquiry < BasePage

  def frm
    self.frame(class: "fancybox-iframe")
  end

  action(:close) { |b| b.frm.button(text: "Close").click; b.loading.wait_while_present }
  
  value(:course_offering_code) { |b| b.frm.span(id: "u14").text } # Persistent ID needed!
  value(:activity_code) { |b| b.frm.span(id: "u23").text } # Persistent ID needed!
  value(:course_offering_title) { |b| b.frm.span(id: "u32").text } # Persistent ID needed!
  value(:term) { |b| b.frm.span(id: "u41").text } # Persistent ID needed!
  value(:type) { |b| b.frm.span(id: "u50").text } # Persistent ID needed!
  value(:format_offering) { |b| b.frm.span(id: "u59").text } # Persistent ID needed!
  value(:total_maximum_enrollment) { |b| b.frm.span(id: "u68").text } # Persistent ID needed!
  value(:state) { |b| b.frm.span(id: "u77").text } # Persistent ID needed!
  value(:requires_evaluation) { |b| b.frm.span(id: "u86").text } # Persistent ID needed!
  value(:honors_offering) { |b| b.frm.span(id: "u95").text } # Persistent ID needed!
  value(:activity_offering_url) { |b| b.frm.span(id: "u104").text } # Persistent ID needed!
  value(:affiliated_personnel) { |b| b.frm.span(id: "u114").text } # Persistent ID needed!
  value(:maximum_enrollment) { |b| b.frm.span(id: "u123").text } # Persistent ID needed!

end