/**
 *  Light Level Alert
 *
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License. You may obtain a copy of the License at:
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 *  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License
 *  for the specific language governing permissions and limitations under the License.
 *
 */
definition(
    name: "Light Level Alert",
    namespace: "msharp58",
    author: "MARK SHARP",
    description: "This app is designed to trigger an alert whenever an ESP32 illuminance detector indicates light above a certain brightness.",
    category: "My Apps",
    iconUrl: "https://s3.amazonaws.com/smartapp-icons/Convenience/Cat-Convenience.png",
    iconX2Url: "https://s3.amazonaws.com/smartapp-icons/Convenience/Cat-Convenience@2x.png",
    iconX3Url: "https://s3.amazonaws.com/smartapp-icons/Convenience/Cat-Convenience@2x.png")


preferences {
	section("Notify when light is detected:") {
		input "LDR1", "capability.illuminanceMeasurement", required: true
    }
    section("Send Push Notification?") {
        input "sendPush", "bool", required: false,
              title: "Send Push Notification illuminated?"
    }
    section("Send a text message to this number (optional)") {
        input "phone", "phone", required: false
    }
}

def installed() {
	log.debug "Installed with settings: ${settings}"

	initialize()
}

def updated() {
	log.debug "Updated with settings: ${settings}"

	unsubscribe()
	initialize()
}

def initialize() {
	subscribe(LDR1, "illuminance", lightChangeHandler, [filterEvents: false])
}

def lightChangeHandler(evt) {
	log.debug "lightChangHandler called: $evt"
     def val = evt.value.toInteger()
     def message = "The ${LDR1.displayName} is done!"
     if (val>=4100) {
        if (sendPush){
        	sendPush(message)
        }
        if (phone) {
        sendSms(phone, message)
    	}
    }
}
