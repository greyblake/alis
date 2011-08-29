Feature: alis
    In order to manage aliases
    As a user
    I want to use alis command

    Background:
        Given I have the next aliases
            | alias        | execute  | tail    |
            | hi           | echo hi  | man     |
            | bye          | echo bye | man     |
            | bye forever  | echo bye | forever |
            | bye amigo    | echo bye | amigo   |


    @list
    Scenario: list aliases
        When I run `alis list`
        Then the output should match /ALIAS\s+EXECUTE\s+TAIL/
        And the output should match /hi\s+echo hi\s+man/
        And the output should match /bye\s+echo bye\s+man/

    @set
    Scenario: set an alias
        Given I have no aliases
        When I run `alis list`
        Then the output should not contain "test_cmd"
        When I run `alis set --alias 'test_cmd' --tail 'some options'`
        # nothing in output
        And I run `alis list`
        Then the output should contain "test_cmd"

    @remove
    Scenario: remove an alias
        When I run `alis list`
        And the output from "alis list" should contain "bye amigo"
        And the output from "alis list" should contain "bye forever"
        When I run `alis remove --alias 'bye forever'`
        And I run `alis list`
        Then the output from "alis list" should not contain "bye forever"
        And the output from "alis list" should contain "bye amigo"
        And there should be command "bye" in alis binary directory
        When I run `alis remove --alias 'bye'`
        And I run `alis remove --alias 'bye amigo'`
        Then there should not be command "bye" in alis binary directory
    
    @alias
    Scenario: execute alias
        When I run `hi`
        Then the output should contain "hi man"
        #When shell exe "bye awesome"
        When I run `bye awesome`
        Then the output should contain "bye awesome man"
