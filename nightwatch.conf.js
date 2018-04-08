
require('nightwatch-cucumber')({
    cucumberArgs: [
        '--require', 'features/step_definitions',
        '--format', 'json:cucumberReport/cucumber.json',
        'features'
    ]
});

module.exports = {
    custom_assertions_path: 'custom_asserts',
    globals_path: 'globals.js',
    output_folder: 'reports',
    page_objects_path: 'pages',
    live_output: false,
    disable_colors: false,
    selenium: {
        start_process: true,
        server_path: './bin/selenium-server-standalone-3.0.1.jar',
        log_path: '',
        host: '127.0.0.1',
        port: 4444,
        cli_args: {
            'webdriver.chrome.driver':'./bin/chromedriver',
            'webdriver.gecko.driver' : './bin/geckodriver'
        }
    },
    test_settings: {
        default: {
            launch_url: 'http://localhost:3000',
            selenium_port: 4444,
            selenium_host: 'localhost',
            screenshots: {
                enabled: false,
                path: "test/screenshots/selenium",
                on_failure: true,
                on_error: true},
            desiredCapabilities: {
            }
        },
        firefox: {
            desiredCapabilities: {
                browserName: "firefox",
                marionette: true,
                javascriptEnabled: true,
                acceptSslCerts: true
            }
        },
        chrome: {
            desiredCapabilities: {
                browserName: "chrome"
            }
        },
        ios: {
            selenium_start_process: false,
            selenium_port: 4723,
            selenium_host: '127.0.0.1',
            silent: true,
            desiredCapabilities: {
                browserName: 'Safari',
                platformName: 'iOS',
                platformVersion: '9.3',
                deviceName: 'iPhone 6s Plus'
            }
        }
    }
};



