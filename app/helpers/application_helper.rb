module ApplicationHelper

  def full_title(given='')
    base = "SaberNSavor"
    given.empty? ? base : [given, base].join(" | ")
  end
end
