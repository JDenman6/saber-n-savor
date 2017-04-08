module ApplicationHelper

  # Returns the full title for the given page title
  def full_title(given='')
    base = "SaberNSavor"
    given.empty? ? base : [given, base].join(" | ")
  end
end
