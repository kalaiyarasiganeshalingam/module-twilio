// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

# Check for HTTP response and if response is success parse HTTP response object into `json` and parse error otherwise.
# + response - HTTP response or HTTP Connector error with network related errors
# + return - `json` payload or `error` if anything wrong happen when HTTP client invocation or parsing response to `json`
function parseResponseToJson(http:Response|error response) returns json|error {
    json result = {};
    match response {
        http:Response httpResponse => {
            var jsonPayload = httpResponse.getJsonPayload();
            match jsonPayload {
                json payload => {
                    if (httpResponse.statusCode != http:OK_200 && httpResponse.statusCode != http:CREATED_201) {
                        string errMsg = payload.message.toString();
                        string errCode;
                        if (payload.error_code != ()) {
                            errCode = payload.error_code.toString();
                        } else if (payload.error != ()) {
                            errCode = payload.error.toString();
                        }
                        error twilioError = { message: httpResponse.statusCode + WHITE_SPACE
                            + httpResponse.reasonPhrase + DASH_WITH_WHITE_SPACES_SYMBOL + errCode
                            + COLON_WITH_WHITE_SPACES_SYMBOL + errMsg };
                        return twilioError;
                    }
                    return payload;
                }
                error err => {
                    return err;
                }
            }
        }
        error err => {
            return err;
        }
    }
}

# Create URL encoded request body with given key and value.
# + requestBody - Request body to be appended values
# + key - Key of the form value parameter
# + value - Value of the form value parameter
# + return - Created request body with encoded string or `error` if anything wrong happen when encoding the value
function createUrlEncodedRequestBody(string requestBody, string key, string value) returns string|error {
    var encodedVar = http:encode(value, CHARSET_UTF8);
    string encodedString;
    string body;
    match encodedVar {
        string encoded => encodedString = encoded;
        error err => {
            return err;
        }
    }
    if (requestBody != EMPTY_STRING) {
        body = requestBody + AMPERSAND_SYMBOL;
    }
    return body + key + EQUAL_SYMBOL + encodedString;
}
