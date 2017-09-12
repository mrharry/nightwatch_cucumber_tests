/**
* Checks if the element has the expected text for the child elements.
*
* ```
*    this.demoTest = function (client) {
*      browser.assert.textContentOfItemsOnList('css selector', '.class', 'button', 'some value');
*    };
* ```
*
* @method attributeEquals
* @param {string} selector The selector (CSS / Xpath) used to locate the element.
* @param {string} element The element selector (id, class).
* @param {string} attribute The attribute name (button, li)
* @param {string} expected The expected text values.
* @param {string} [message] Optional log message to display in the output. If missing, one is displayed by default.
* @api assertions
*/

var util = require('util');
exports.assertion = function(selector, element, attribute, expected, msg) {

    const element_with_attribute  = element + ' ' + attribute;

    const DEFAULT_MSG = 'Testing the element <%s> with the attribute "%s" contains these items "%s".';

    this.message = msg || util.format(DEFAULT_MSG, element, attribute, expected);

    this.expected = function() {
        return expected;
    };

    this.pass = function(value) {
        return value === expected;
    };

    this.value = function(result) {
        console.log("in this value with a result" + JSON.stringify(result))
        return result.value;
    };

    this.command = function(callback) {
        const self = this.api;

        this.api.elements('css selector', element_with_attribute, function(el) {
            el.value.forEach(function(element) {
                self.elementIdText(element.ELEMENT, callback, function (result) {
                    console.log("result is " + result.value)

                });
                return this
            });
        })

    };

};
