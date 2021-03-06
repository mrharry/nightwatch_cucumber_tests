const { client }  = require('nightwatch-cucumber');
const { defineSupportCode } = require('cucumber');

defineSupportCode(({ Given, Then, When }) => {

    Given('I have opened the Sports page', function () {
        const bbc_sports = client.page.bbc_sports();
        console.log(" here's the boss " + client.globals.users.admin_guy);
        return bbc_sports
            .navigate()
            .waitForElementVisible('@body', 1000)
    });

    Given('I have opened the Weather page', function () {
        const bbc_weather = client.page.bbc_weather();
        return bbc_weather
            .navigate()
            .waitForElementVisible('@body', 1000)
    });

    Then('I will see the Weather Forecast', function () {
        const bbc_weather = client.page.bbc_weather();
        return bbc_weather.expect.element('@weather_forecast').to.be.present;
    });

    Then('I will see the More button', function () {
        const bbc_sports = client.page.bbc_sports();
        const filterSection = bbc_sports.section.filter;
        return filterSection.expect.element('@more_button').to.be.present;
    });

    When('I click on the More button', function () {
        const bbc_sports = client.page.bbc_sports();
        const filterSection = bbc_sports.section.filter;
        return filterSection.click('@more_button');
    });
    
    Then('I will see {int} sports', function (int) {
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports.verify.countOfItemsOnList('css selector', '.gs-o-list-ui', 'button', 18);
    });

    Then('I will see these sports', function (dataTable) {
        const data_list = dataTable.raw();
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports
            .verify.textContentOfItemsOnList('css selector', '.gs-o-list-ui', 'button', data_list);
    });

    Then('the {string} is displayed', function (string) {
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports
            .expect.element('button.sp-c-filter-nav__link.sp-c-filter-nav__link--selected').text.to.equal(string);

    });



});

