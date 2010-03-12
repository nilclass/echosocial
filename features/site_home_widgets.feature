Feature: Site Home Widgets

Background:
  Given the current site has a network
  And 1 users exist
  And I am logged in as the 1st user
  And the user is member of the current site

Scenario: Member avatars
  Given there are at least "10" active people in the current site
  And I go to "the homepage"
  Then I should see "Members"
  And I should see a list of member avatars

Scenario: Summary
  Given the current site network has a summary
  When I go to "the homepage"
  Then I should see the summary

Scenario: Editing the wiki
  When I go to "the homepage"
  And I click "Edit" in the "wiki-area"
  And I fill "body" with "new wiki text"
  And I press "Save"
  Then I should see "new wiki text"

Scenario: Welcome Box
  When I go to "the homepage"
  And I click "See Tips to get started"
  Then I should see "Crabgrass enables social change organizations to get things done"
