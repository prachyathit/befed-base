module ApplicationHelper
  def full_title(page_title='')
    base_title = "Befed Bangkok Food Delivery"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end

  end
end
