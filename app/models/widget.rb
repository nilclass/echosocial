class Widget < ActiveRecord::Base
  VERTICAL_CLASS = 'vbox'
  HORIZONTAL_CLASS = 'hbox'
  VERTICAL_CHILD_CLASS = 'vwidget'
  HORIZONTAL_CHILD_CLASS = 'hwidget'

  belongs_to :network
  acts_as_nested_set :scope => :network_id

  validates_presence_of :network_id

  def empty?
    cell_name.empty?
  end

  def direction=(value)
    # allow :vertical and :horizontal as direction values, even though it is a boolean
    write_attribute(:direction, [:vertical, :horizontal].include?(value.to_sym) ? (value == :vertical) : value)
  end

  def direction
    read_attribute(:direction) ? :vertical : :horizontal
  end

  def vertical?
    read_attribute(:direction)
  end

  def horizontal?
    ! read_attribute(:direction)
  end

  def validate
    if empty? && direction.nil?
      errors.add :direction, "must be set for empty widgets"
    elsif ! empty? && ! initial_state
      errors.add :initial_state, "must be specified in order to render the widget"
    end
  end

  def css_classes
    ((css_class || '').split(/\s+/) << box_class << cell_name).compact
  end

  def dom_id
    "widget_#{id}"
  end

  def box_class
    if empty?
      vertical? ? VERTICAL_CLASS : HORIZONTAL_CLASS
    elsif parent && parent.empty?
      parent.vertical? ? VERTICAL_CHILD_CLASS : HORIZONTAL_CHILD_CLASS
    end
  end
end
