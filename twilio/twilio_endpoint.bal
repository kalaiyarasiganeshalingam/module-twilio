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

# Object for Twilio endpoint.
# + twilioConfig - Reference to TwilioBasicConfiguration type
# + twilioConnector - Reference to TwilioConnector type
public type Client object {

    public TwilioConfiguration twilioConfig;
    public TwilioConnector twilioConnector = new;

    # Initialize Twilio endpoint.
    # + config - Twilio configuraion
    public function init(TwilioConfiguration config);

    # Initialize Twilio endpoint.
    # + return - The Twilio Connector object
    public function getCallerActions() returns TwilioConnector;

};

# Twilio Configuration.
# + accountSId - Unique identifier of the account
# + authToken - The authentication token of the account
# + xAuthyKey - The authentication token for the Authy API
# + basicClientConfig - The HTTP client endpoint for basic configuration
# + authyClientConfig - The HTTP client endpoint for Authy configuration
public type TwilioConfiguration record {
    string accountSId;
    string authToken;
    string xAuthyKey;
    http:ClientEndpointConfig basicClientConfig;
    http:ClientEndpointConfig authyClientConfig;
};

function Client::init(TwilioConfiguration config) {
    self.twilioConnector.accountSId = config.accountSId;
    self.twilioConnector.xAuthyKey = config.xAuthyKey;

    config.basicClientConfig.url = TWILIO_API_BASE_URL;
    http:AuthConfig authConfig = { scheme: http:BASIC_AUTH, username: config.accountSId, password: config.authToken };
    config.basicClientConfig.auth = authConfig;
    self.twilioConnector.basicClient.init(config.basicClientConfig);

    config.authyClientConfig.url = AUTHY_API_BASE_URL;
    self.twilioConnector.authyClient.init(config.authyClientConfig);
}

function Client::getCallerActions() returns TwilioConnector {
    return self.twilioConnector;
}
