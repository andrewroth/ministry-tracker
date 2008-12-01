require 'helper_me_test'

ActionView::TestCase.send :include, HelperMeTest::Assertions::TagAssertions
ActionView::TestCase.send :include, HelperMeTest::Assertions::SelectorAssertions
if defined? Hpricot
  ActionView::TestCase.send :include, HelperMeTest::Assertions::HpricotAssertions
end

