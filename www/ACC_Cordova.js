/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
*/

var ACC_Cordova = (function() {
    var ACC_Cordova = (typeof exports !== 'undefined') && exports || {};
    var exec = cordova.require('cordova/exec'); // eslint-disable-line no-undef

    var PLUGIN_NAME = "ACC_Cordova";

    // ===========================================================================
    // public objects
    // ===========================================================================
    ACC_Cordova.createEvent = function(name, type, source, data) {
        return {
            name: name,
            type: type,
            source: source,
            data: data
        };
    };

    // ===========================================================================
    // public enums
    // ===========================================================================
    ACC_Cordova.ACPMobilePrivacyStatusOptIn = 0;
    ACC_Cordova.ACPMobilePrivacyStatusOptOut = 1;
    ACC_Cordova.ACPMobilePrivacyStatusUnknown = 2;

    ACC_Cordova.ACPMobileLogLevelError = 0;
    ACC_Cordova.ACPMobileLogLevelWarning = 1;
    ACC_Cordova.ACPMobileLogLevelDebug = 2;
    ACC_Cordova.ACPMobileLogLevelVerbose = 3;

    // ===========================================================================
    // public APIs
    // ===========================================================================
    ACC_Cordova.extensionVersion = function(success, fail) {
        var FUNCTION_NAME = "extensionVersion";

        if (success && !acpIsFunction(success)) {
            acpPrintNotAFunction("success", FUNCTION_NAME);
            return;
        }

        if (fail && !acpIsFunction(fail)) {
            acpPrintNotAFunction("fail", FUNCTION_NAME);
            return;
        }

        return exec(success, fail, PLUGIN_NAME, FUNCTION_NAME, []);
    };

    ACC_Cordova.registerDevice = function(action, contextData, success, fail) {
        var FUNCTION_NAME = "trackAction";

        if (!acpIsString(action)) {
            acpPrintNotAString("action", FUNCTION_NAME);
            return;
        }

        if (contextData && !acpIsObject(contextData)) {
            acpPrintNotAnObject("contextData", FUNCTION_NAME);
            return;
        }

        if (success && !acpIsFunction(success)) {
            acpPrintNotAFunction("success", FUNCTION_NAME);
            return;
        }

        if (fail && !acpIsFunction(fail)) {
            acpPrintNotAFunction("fail", FUNCTION_NAME);
            return;
        }

        return exec(success, fail, PLUGIN_NAME, FUNCTION_NAME, [action, contextData]);
    };

return ACC_Cordova;

}());

// ===========================================================================
// input sanitization
// ===========================================================================
window.acpIsString = function (value) {
    return typeof value === 'string' || value instanceof String;
};

window.acpPrintNotAString = function (paramName, functionName) {
    console.log("Ignoring call to '" + functionName + "'. The '" + paramName + "' parameter is required to be a String.");
};

window.acpIsNumber = function (value) {
    return typeof value === 'number' && isFinite(value);
};

window.acpPrintNotANumber = function (paramName, functionName) {
    if(functionName == 'syncIdentifiers') {
        console.log("Ignoring call to '" + functionName + "'. The '" + paramName + "' parameter is required to be a Number or Null.");
    } else {
        console.log("Ignoring call to '" + functionName + "'. The '" + paramName + "' parameter is required to be a Number.");
    }
};

window.acpIsObject = function (value) {
    return value && typeof value === 'object' && value.constructor === Object;
};

window.acpPrintNotAnObject = function (paramName, functionName) {
    console.log("Ignoring call to '" + functionName + "'. The '" + paramName + "' parameter is required to be an Object.");
};

window.acpIsFunction = function (value) {
    return typeof value === 'function';
};

window.acpPrintNotAFunction = function (paramName, functionName) {
    console.log("Ignoring call to '" + functionName + "'. The '" + paramName + "' parameter is required to be a function.");
};

window.acpIsValidEvent = function (event) {
    if (!acpIsString(event.name)) {
        console.log("Event.name must be of type String.");
        return false;
    }

    if (!acpIsString(event.type)) {
        console.log("Event.type must be of type String.");
        return false;
    }

    if (!acpIsString(event.source)) {
        console.log("Event.source must be of type String.");
        return false;
    }

    if (!acpIsObject(event.data)) {
        console.log("Event.data must be of type Object.");
        return false;
    }

    return true;
};

module.exports = ACC_Cordova;