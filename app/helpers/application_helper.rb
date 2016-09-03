module ApplicationHelper

  def compare(period, overall)
    return 0 if period == 0
    diff = overall - period
    diff / period * 100
  end

  def months_in_dataset
    72.0
  end

  def arrow_image_tag(tick)
    if tick > 0
     image_tag("red_up_arrow.svg.png", size: "16x10")
    else
     image_tag("green_down_arrow.svg.png", size: "16x10")
   end
 end

end
