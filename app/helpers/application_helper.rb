module ApplicationHelper
  def full_title(page_title='')
    base_title = "Befed Food Delivery | สั่งอาหารเดลิเวอรี่ แจ้งวัฒนะ เมืองทองธานี"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end

  end
end
