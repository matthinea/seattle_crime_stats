module ApplicationHelper

  def compare(period, overall)
    return 0 if period == 0
    diff = overall - period
    diff / period * 100
  end

  def months_in_dataset
    72.0
  end

end
