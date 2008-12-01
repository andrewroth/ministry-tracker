Helper Me Test
==============

Providing quick and easy ways to create and write tests for your Rails helpers.


Features
---------

### Assertions / Test Helper Methods

* __Tag Assertions:__
    * `assert_tag_in` and `assert_tag_not_in` mirror the `assert_tag` method built
      into Rails. They work with the same option, only that they need a target
      string as the first parameter.
* __Selector Assertion:__
    * `assert_select_in` works almost identically to `assert_select` does in Rails.
      It allows for a CSS selector to be matched against a HTML string target.
      It also accepts an equality expression and can be nested like `assert_select`.
* __Hpricot Assertion:__
    * `assert_hpricot_in`, and `assert_hpricot_not_in` test that a given CSS or XPath
      expression can be found in an HTML string. See Hpricot documentation for details.

### Generators

* __Helper Test Generator:__
    * Usage:
        * `script/generate helper_tests [SampleHelper Admin::AnotherHelper ...]`
    * Creates helper tests for each helper you currently have, creating one test for
      each public method in the module. If you instead pass it a space separated set
      of helper module names you'll only generate tests for those.
    * You can also pass it an option of `--skip-method-tests` and it won't create tests
      for each of the helper methods.
* __Helper Generator:__
    * Usage:
        * `script/generate helper HelperName [methods ...]`
    * Creates a helper based on a camelcased or underscored name, and a test file
      for it. It will also accept a list of method names and create methods for
      each of them and a test for each of the methods.

### Rake Tasks

I've also provided a rake task for running the generated helper tests, `rake test:helpers`
and changed the `rake test` task to run that test task in a addition to the other
test tasks.


Examples
---------

#### Using Tag Assertions:

    def test_some_html_string_with_assert_tag_in
      html = "<div><ul id="list"><li>one</li><li>two</li></ul><p id="content">hello world</p></div>"
      assert_tag_in html, :ul, :attributes => {:id => 'list'}, :child => {:tag => 'li'}
      assert_tag_in html, :p
    end
    

#### Using Selector Assertions:

    def test_some_html_string_with_assert_select_in
      html = "<div><ul id="list"><li>one</li><li>two</li></ul><p id="content">hello world</p></div>"
      assert_select_in html 'ul#list' do
        assert_select_in 'li'
      end
      assert_select_in html,'p#content', 'hello world'
    end
    

#### Using Hpricot Methods

    def test_some_html_string_with_assert_hpricot_in
      html = "<div><ul id="list"><li>one</li><li>two</li></ul><p id="content">hello world</p></div>"
      assert_hpricot_in html, 'ul[@id="list"][li="one"]'
      assert_hpricot_in html, 'p[@id="content"]'
    end
    



### Additional Documentation

* [assert_tag RDoc](http://api.rubyonrails.org/classes/ActionController/Assertions/TagAssertions.html "ActionController::Assertions::TagAssertions")
* [assert_select RDoc](http://api.rubyonrails.org/classes/ActionController/Assertions/SelectorAssertions.html "ActionController::Assertions::SelectorAssertions")
* [Hpricot Tutorial](https://code.whytheluckystiff.net/hpricot/wiki/AnHpricotShowcase)
* [Hpricot RDoc](http://code.whytheluckystiff.net/doc/hpricot/ "Hpricot Documentation")


### License

Copyright (c) 2008 Brian Landau of Viget Labs, released under the MIT license
