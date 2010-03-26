require File.dirname(__FILE__) + '/../test_helper'

class CustomAppearaceTest < ActiveSupport::TestCase
  fixtures :custom_appearances

  def setup
    # delete cached css
    CustomAppearance.clear_cached_css
  end

  def test_generate_css_and_clear_cache
    appearance = custom_appearances(:default_appearance)

    # update appearance
    appearance.parameters["box1_bg_color"] = "green"
    appearance.save!

    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)

    assert File.exists?(css_path), "CustomAppearance#themed_stylesheet_url should generate a new file"

    css_text = File.read(css_path)

    assert css_text.length > 0

    # clear the cache
    CustomAppearance.clear_cached_css
    # should be deleted
    assert !File.exists?(css_path), "clearing css cache should delete cached files"

    # should regerate
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    assert File.exists?(css_path), "CustomAppearance#themed_stylesheet_url should generate a new file"
  end

  def test_nonexisting_css
    assert_raise Errno::ENOENT do
      CustomAppearance.default.themed_stylesheet_url("does_not_exists.css", "ui_base");
    end
  end

  def test_generated_css_text
    appearance = custom_appearances(:default_appearance)

    # update appearance
    appearance.parameters["page_bg"] = "magenta"
    appearance.save!

    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    css_text = File.read(css_path)
    assert css_text =~ /body\s*\{\s*.*background:\s*magenta/, "generated text must use updated background-color value"
  end

  def test_always_regenerate_options
    # first try always regenerate
    Conf.always_renegerate_themed_stylesheet = true
    appearance = custom_appearances(:default_appearance)

    # generate once
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    # remember the tyle
    mtime1 = File.mtime(css_path)

    # generate again
    sleep 1
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    # remember the time
    mtime2 = File.mtime(css_path)

    assert mtime2 > mtime1, "themed_stylesheet_url should aways regenerate the css file when Conf.always_renegerate_themed_stylesheet is true"

    # mimick the production mode
    Conf.always_renegerate_themed_stylesheet = false

    # generate once
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    # remember the time
    mtime1 = File.mtime(css_path)

    # generate again
    sleep 1
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    # remember the time
    mtime2 = File.mtime(css_path)

    assert mtime2 == mtime1, "themed_stylesheet_url should not always regenerate the css file when Conf.always_renegerate_themed_stylesheet is false"

    # now save appearance. this should force regeneration
    appearance.save!

    # generate again
    stylesheet_url = appearance.themed_stylesheet_url("screen.css", "ui_base")
    css_path = File.join("./public/stylesheets", stylesheet_url)
    # remember the tyle
    mtime3 = File.mtime(css_path)

    assert mtime3 > mtime2, "themed_stylesheet_url should aways regenerate the css file when custom appearance is updated"

    # restore the test default
    Conf.always_renegerate_themed_stylesheet = true
  end

  def test_available_parameters
    assert (without_types = CustomAppearance.available_parameters).is_a?(Hash)

    # make sure that legacy behaviour still works
    assert without_types['outer_border'].kind_of?(String)
    # and that types are parsed as well
    assert (with_types = CustomAppearance.available_parameters(true)).is_a?(Hash)
    assert with_types['outer_border'][:type] == 'border'
    # this doesn't test the custom appearance, but that constants.sass has only correct types
    valid_types = CustomAppearance.valid_parameter_types
    with_types.each_pair do |key, value|
      assert valid_types.include?(value[:type]), "Type given for #{key} in constants.sass is invalid: #{value[:type]}" if value[:type]
    end
  end

  def test_smart_parameters
    appearance = custom_appearances(:default_appearance)
    smart_params = appearance.smart_parameters
    assert smart_params.kind_of?(CustomAppearance::Parameter::Parameters)
    CustomAppearance.available_parameters.each_pair do |key, value|
      assert smart_params[key], "Expected appearance smart params to contain #{key}. Well, but it doesn't."
    end
    # test border and size
    appearance.parameters['outer_border'] = "1px solid #999"
    smart_params = appearance.smart_parameters
    assert_equal smart_params['outer_border'], smart_params.outer_border, "Excpected method call to return the same thing as a hash lookup"
    outer_border = smart_params.outer_border
    assert outer_border.kind_of?(CustomAppearance::Parameter::Border)
    assert_equal 'solid', outer_border.style
    assert_equal '#999', outer_border.color
    assert outer_border.size.kind_of?(CustomAppearance::Parameter::Size)
    assert_equal '1', outer_border.size.value
    assert_equal 'px', outer_border.size.unit
    # test margin / padding (i.e. the same)
    appearance.parameters['menu_item_padding'] = '1em 2em 3em 4px'
    smart_params = appearance.smart_parameters
    menu_item_padding = smart_params.menu_item_padding
    assert_equal '1', menu_item_padding.top.value
    assert_equal 'em', menu_item_padding.top.unit
    assert_equal '4', menu_item_padding.left.value
    assert_equal 'px', menu_item_padding.left.unit
    appearance.parameters['menu_item_padding'] = '12em 3em'
    smart_params = appearance.smart_parameters
    menu_item_padding = smart_params.menu_item_padding
    assert_equal '12', menu_item_padding.top.value
    assert_equal '12', menu_item_padding.bottom.value
    assert_equal '3', menu_item_padding.left.value
    assert_equal '3', menu_item_padding.right.value
    appearance.parameters['menu_item_padding'] = '7em'
    smart_params = appearance.smart_parameters
    menu_item_padding = smart_params.menu_item_padding
    assert_equal '7', menu_item_padding.top.value
    assert_equal '7', menu_item_padding.right.value
    assert_equal '7', menu_item_padding.bottom.value
    assert_equal '7', menu_item_padding.left.value
  end
end
