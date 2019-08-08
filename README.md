# KRYPTONITE :: An Automation Testing Framework for Sleekr

### Requirement
[Ruby](https://www.ruby-lang.org/en/) with version 2.3.0 or above. We recommend to use ruby version manager like [rvm](https://rvm.io/) to install the ruby.

### Setup
Clone the repository and install all gems depedency:
```shell
$ git clone git@bitbucket.org:mid-kelola-indonesia/kryptonite.git
$ cd kryptonite/
$ bundle install
$ cp .env.example .env
```

We start based on most used browser by our client, that is Google Chrome browser, Please make sure you have [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/) installed on your system.

for mac:
`$ brew install chromedriver`

for ubuntu:
`$ wget -O - https://gist.githubusercontent.com/ziadoz/3e8ab7e944d02fe872c3454d17af31a5/raw/ff10e54f562c83672f0b1958a144c4b72c070158/install.sh | bash`

### Running Features Test
Run all features: `$ cucumber`

Run spesific test only: `$ cucumber features/user/signup.feature`

Run by tags:  `$ cucumber --tags "@sanity"`

Run in rake task:
```bash
$ rake kryptonite:clear_report # delete old report directory
$ rake kryptonite:init_report
$ rake kryptonite:test t=@login CI=true  # run one tag in server CI
# or run in
$ rake kryptonite:parallel t=@smokeTest BROWSER=chrome_headless  # run by tag(s) in parallel by feature
```

This framework contains spesific directory functions:
```
- root directory    => contains configuration files
- features          => main directory, all test will inside this
- config            => store data in yml file that will be using in testing
- lib               => ruby helper files located
- pages             => page class, contains locator strategies for several pages
- scenarios         => cucumber features files
- step_definitions  => code implementation of cucumber feature files
- support           => setup of test framework
```

## Writing test
For example we are going to create automation for time off features in admin pages, so we're going to create files:
```
$ touch features/scenarios/admin/timeoff.feature
$ touch features/step_definitions/admin/timeoff_steps.rb
$ touch features/pages/admin/timeoff_page.rb
```

What are these 3 files?:

1. **Feature** file (.feature) is our automation test steps, written in `gherkin` format (given-when-then-and-or), this file also works as test documentation. the files which is located in the `features` folder with subdirectory admin or staff in order to maintain readability where this scenario performs in sleekr app (admin/staff app). There're several pattern to write features file, we'll learn more in next chapter below.

2. **Page**  file (*_pages.rb) is page object model DSL using SitePrism gem, we should store locator stragies inside class file, one file *_pages.rb can contains multiple class that represent sub

3. **Steps** file (.rb), which is located in the `step_definitions` folder. Step file's name should also be in the form of `featurename_steps.rb`, ex: `claim_feature_steps.rb` or `sign_up_steps.rb`. Steps file will contain an implementation (ruby) of the steps descibed in the `.feature` file.

# AVOID these anti patterns:

## Feature And Scenario
- If the Gherkin is hard to understand it's bad documentation
- Writing the scenario after you've wrote the code (scenario first)
- The scenario title contains too much information about what the lower level details in the scenario are doing
- Rambling long scenario with too many (10+ steps)
- Too many incidental details (e.g step `When I sign up as Matt, my password is password, my password confirmation is password, and I check my bank balance`)
- Not enough details (e.g Given the system is turned on When it is used Then it should work perfectly)
- A lot of Scenario Outlines in one feature
- Testing the same thing over and over again
- Not using the narrative section of a feature
- Adding pointless scenario descriptions
- Feature has a background with one scenario.
- Same tag appears on both Feature and Scenario
- Tag appears on all scenarios.
- Feature with too many scenarios.
- Commented step.
- Step that is only one word long.
- Scenario with too many steps.
- Given/When/Then used multiple times in the same scenario.
- Scenario Outline with no examples.
- Scenario Outline with only one example.
- Scenario Outline with too many examples.

## Step Definition
- Recursive nested step call.
- No code in Step Definition.
- Too many parameters in Step Definition.
- Lazy Debugging through puts, p, or print
- Pending step definition. Implement or remove.
- Nested step call.
- Commented code in Step Definition.
- Small sleeps used. Use a wait_until like method.
- Large sleeps used. Use a wait_until like method.
- Todo found. Resolve it.

### Creating the test
We're following tips from [great cucumber articel here ](https://saucelabs.com/blog/write-great-cucumber-tests), you need to read that articel too :D , TL;DR:
- Features file are grouped in subfolder `admin` and `staff` that represent the action and context that is covered within
- Every *.feature file consists in a single feature, focused on the business value.
- The background needs to be used wisely. If you use the same steps at the beginning of all scenarios of a feature, put them into the feature’s background scenario. The background steps are run before each scenario.
- Keep each scenario independent. The scenarios should run independently, without any dependencies on other scenarios.
- Write Declarative Scenarios, Not Imperative. Just avoid unnecessary details in your scenarios.
- `Given` is the pre-condition to put the system into a known state before the user starts interacting with the application
- `When` describes the key action the user performs
- `Then` is observing the expected outcome. Just remember the ‘then’ step is an acceptance criteria of the story.
- Since tags on features are inherited by scenarios, please don’t be redundant by including the same tags on scenarios.

Sample gherkin template:
```gherkin
Feature: Title (one line describing the story)

Narrative Description: As a [role], I want [feature], so that I [benefit]

Scenario: Title (acceptance criteria of user story)
Given [context]
And [some more context]...
When [event]
Then [outcome]
And [another outcome]...

Scenario: ...
```
If in one scenario we use 2 or more actor, we need to put `actor` as context also in front of steps, such as:
```gherkin
Scenario: Invite new staff to company
  Given admin is on invitation page
  And admin fill invitation form with staff data
  When admin submit the invitation
  Then staff should revceive invitation email
  And admin should see the staff in directory module
  And staff able to activate using token from email
```

## Writing features files
You shouldn't share state between scenarios. A scenario describes a piece of the intended behavior for the whole system, and it should be possible to run just one scenario. E.g. if you have run the entire test suite, and you find that a single scenario fails, you should be able to run just that one scenario in order to investigate what went wrong.


## Writing page object files
For example we going to automate the page URL `https://polaris.sleekr.id/admin/settings/job_levels` will create:
- file page will created inside directory `./features/pages/admin/`
- file name is `settings_job_levels_page.rb`
- class naming should in camel case and has module Admin, e.g:
    ```ruby
    module Admin
        class SettingsJobLevel < SitePrism::Page
        end
    end
    ```
- sub page like `https://polaris.sleekr.id/admin/settings/job_levels/new` should has naming `settings_new_job_levels_page.rb` or in edit menu `settings_edit_job_levels_page.rb` also in module `Admin`
- sample of page file:
```ruby
module Admin
    class Home < SitePrism::Page
        element :search_field, 'input[name="q"]'
        element :first_name, :xpath, '//div[@id="signup"]//input[@name="first-name"]'
    end
end
```
...then the following methods are available:
```
@home.search_field
@home.has_search_field?
@home.has_no_search_field?
@home.wait_for_search_field
@home.wait_for_no_search_field
@home.wait_until_search_field_visible
@home.wait_until_search_field_invisible
```
## Creating step definitions files
- As you know you shouldn't be hard coding parameters into your code. This applies to site URL’s as well to allow flexibility to globally change the value.
- A good programming practice is Don’t Repeat Yourself (or DRY) by creating reusable code.
- Avoid call other step definitions. Call step definitions from other step definitions by calling steps helper
- No sleep statements. It is better to use method or function with a built-in timeout. e.g `@home.wait_until_search_field_visible` or if you need for the search field to disappear use `@home.wait_for_no_search_field`
- Each steps should have minimum one expectation, e.g when navigating pages, make sure we include page display, to assert that we are in right page. its easy when we use the sitePrism built in method:
```ruby
Then /^the account page is displayed$/ do
  expect(@account_page).to be_displayed
  expect(@some_other_page).not_to be_displayed
  # or expecting spesific element
   expect(@account_page).to have_search_field
end
# or we can check that all elements that should be on the page are on the page.
Then /^the friends page contains all the expected elements$/ do
  expect(@friends_page).to be_all_there
end
```
Matchers:
```
- expect(list_page.rows.first.some_attribute).to have_text('some attribute')
@page.has_my_iframe? #=> true
- expect(@page).to have_my_iframe
- expect(@app.results_page).to be_displayed
- expect(@account_page.current_url).to end_with('/accounts/22?token=ca2786616a4285bc')
- expect(@account_page).to be_displayed(id: 22)
- expect(@some_other_page).not_to be_displayed
- expect(@home).to have_no_search_field
- expect(@friends_page.names.map { |name| name.text }).to eq(['Alice', 'Bob', 'Fred'])
- expect(@friends_page.names.size).to eq(3)
- expect(@friends_page).to have(3).names
- expect(@friends_page).to be_all_there
- expect(@home.menu.search['href']).to include('google.com')
- expect(@home).to have_login_and_registration
- expect(search_result.blurb.text).not_to be_nil
- expect(@results_page).to have_search_results(count: 25)
- expect(actual).to eq(expected)
- expect(actual).not_to eql(not_expected)
- expect(actual).to be(expected)
- expect(actual).to equal(expected)
- expect(actual).to be >  expected
- expect(actual).to be >= expected
- expect(actual).to be <= expected
- expect(actual).to be <  expected
- expect(actual).to be_within(delta).of(expected)
- expect(actual).to match(/expression/)
- expect(actual).to be_an_instance_of(expected)
- expect(actual).to be_a(expected)
- expect(actual).to be_an(expected)
- expect(actual).to be_a_kind_of(expected)
- expect(actual).to be false
- expect(actual).to be true
- expect(actual).to be_nil
- expect(actual).to_not be_nil
- expect { ... }.to raise_error
- expect { ... }.to raise_error("message")
- expect { ... }.to throw_symbol(:symbol, 'value')
- expect(actual).to include(expected)
- expect(actual).to have_xxx(:arg)
- expect(actual).to start_with(expected)
- expect(actual).to end_with(expected)
- expect(actual).to contain_exactly(individual, items)
- expect(actual).to match_array(expected_array)
- expect([1, 2, 3]).to include(1, 2)
- expect([1, 2, 3]).to start_with(1)
- expect(alphabet).to start_with("a").and end_with("z")
- expect(stoplight.color).to eq("red").or eq("green").or eq("yellow")
```


## Creating pages files
### Locator Strategies
There're many locators to interacting with web element, there're xpath, css, text, even with regex. We can use any locator that supported in sitePrism, usually the css locator is shorter, so use it when possible. but if we need complex query we can use xPath surely.

#### CSS vs XPATH
XPath | Css
--- | ---
//div/a | div > a
//div//a | div a
//div[@id='example'] | #example
//div[@class='example'] | .example
//input[@id='username']/following-sibling::input[1] | #username + input
//input[@name='username'] | input[name='username']
//input[@name='login'and @type='submit'] | input[name='login'][type='submit']
a[contains(text(), 'Log out')] | a:contains('Log Out')
-  | #recordlist li:nth-of-type(4)
- | #recordlist li:nth-child(4)
- | #recordlist *:nth-child(4)
- | a[id^='id_prefix_']
- | a[id$='_id_sufix']
- | a[id*='id_pattern']


### Notes
This test use capybara library to find an element, and doing expectation.

### Related topic
Capybara syntax [cheatsheet1](https://github.com/teamcapybara/capybara), [cheatsheet2](https://gist.github.com/zhengjia/428105), [cheatsheet3](https://gist.github.com/tomas-stefano/6652111)

More about [cucumber](https://github.com/cucumber/cucumber/wiki/A-Table-Of-Content)