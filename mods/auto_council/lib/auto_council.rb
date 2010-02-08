module AutoCouncil
  def self.included(base)
    base.instance_eval do
      attr :create_council, true
      attr :council_name, true

      after_save :create_council_if_requested

      attr_accessible :create_council, :council_name
    end
  end

  def create_council_if_requested
    if @create_council && council == self
      c = Council.new(:name => (@council_name || 'council'))
      add_committee!(c)
    end
  end
end
