Feature:
  'http://www.bbc.co.uk/sport/'

  Scenario: The number of items in a list
    Given I have opened the Sports page
    Then I will see the More button

  Scenario: The number of items in a list
    Given I have opened the Sports page
    When I click on the More button
    Then I will see 9 sports

  Scenario: The content of a list
    Given I have opened the Sports page
    When I click on the More button
    Then I will see these sports
    | Premier League |
    | Scottish Prem  |
    | Championship   |

  Scenario: selecting an item on a list
    Given I have opened the Sports page
    And I click on the More button
    When I select the "Championship"
    Then the "Championship" is displayed
