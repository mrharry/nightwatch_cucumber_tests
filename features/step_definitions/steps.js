const { client }  = require('nightwatch-cucumber');
const { defineSupportCode } = require('cucumber');

defineSupportCode(({ Given, Then, When }) => {

    Given('I have opened the Sports page', function () {
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports
            .navigate()
            .waitForElementVisible('@body', 1000)
            .expect.element('@more_button').to.be.present;
    });

    When('I click on the More button', function () {
        const bbc_sports = client.page.bbc_sports();
        
        return bbc_sports.click('@more_button');
    });

    When('I select the {string}', function (string) {
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports
            .select_item('css selector', '.gs-o-list-ui button', string)
    });


    Then('I will see {int} sports', function (int) {
        const bbc_sports = client.page.bbc_sports();
        
        return bbc_sports.verify.countOfItemsOnList('css selector', '.gs-o-list-ui', 'button', 13);
    });

    Then('I will see these sports', function (dataTable) {
        const data_list = dataTable.raw();
        console.log(" the datatable item 1 looks like this " + JSON.stringify(data_list));
        const bbc_sports = client.page.bbc_sports();
        return bbc_sports
            .verify.textContentOfItemsOnList('css selector', '.gs-o-list-ui', 'button', data_list);
    });


    

});

