# encoding: utf-8
class String
  def titleize(options = {})
    exclusions = options[:exclude]

    return ActiveSupport::Inflector.titleize(self) unless exclusions.present?
    
    self.underscore.humanize.gsub(/\b(?<!['’`])(?!(#{exclusions.join('|')})\b)[a-z]/) { $&.capitalize }
    #self.gsub(/\b[a-z]{2}\b/) { $&.upcase }
  end
end