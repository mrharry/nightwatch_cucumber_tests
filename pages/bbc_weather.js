const pageCommands = {

    select_item: function(selector, item_list, item) {

        const self = this.api;
        return this.api.elements('css selector', item_list, function(els) {

            els.value.forEach(function(element) {
                self.elementIdText(element.ELEMENT, function (result) {
                    if (result.value == item) {
                        self.elementIdClick(result.ELEMENT);
                    }
                });
            });
        });
    }

};


module.exports = {

    commands: [pageCommands],

    url: 'http://www.bbc.co.uk/weather/',

    sections: {
        filter: {
            selector: '.sp-c-filter-nav',
            elements: {
                more_button: '.sp-c-filter-nav__button.sp-c-filter-nav__link',
                menu: 'ul[role=menu]',
                dropdown: '[data-istats-container="competitionfilter-dropdown"]'
            }
        }
    },
// main page

    elements: {
        body: 'body',
        weather_forecast: '#forecast-carousel'
    }
};
