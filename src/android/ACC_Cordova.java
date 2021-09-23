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

 package com.konvergence.acc.cordova;

 import android.os.Bundle;
 import android.util.Log;
 import com.adobe.marketing.mobile.AdobeCallback;
 import com.adobe.marketing.mobile.Event;
 import com.adobe.marketing.mobile.LoggingMode;
 import com.adobe.marketing.mobile.MobileCore;
 import com.adobe.marketing.mobile.CampaignClassic;
 import com.adobe.marketing.mobile.Lifecycle;
 import org.apache.cordova.CallbackContext;
 import org.apache.cordova.CordovaInterface;
 import org.apache.cordova.CordovaPlugin;
 import org.apache.cordova.CordovaWebView;
 import org.json.JSONArray;
 import org.json.JSONException;
 import org.json.JSONObject;
 import java.util.HashMap;
 import java.util.Iterator;
 import java.util.Map;

 public class ACC_Cordova extends CordovaPlugin {
    final static String METHOD_ACC_EXTENSION_VERSION = "extensionVersion";
    final static String METHOD_ACC_REGISTER_DEVICE = "registerDevice";

    // ===============================================================
    // all calls filter through this method
    // ===============================================================
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (METHOD_ACC_EXTENSION_VERSION.equals(action)) {
           this.extensionVersion(callbackContext);
           return true;
       } else if (METHOD_ACC_REGISTER_DEVICE.equals(action)) {
           this.registerDevice(args, callbackContext);
           return true;
       }

       return false;
   }

    // ===============================================================
    // ACC Methods
    // ===============================================================
    private void extensionVersion(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                final String version = MobileCore.extensionVersion();
                callbackContext.success(version);
            }
        });
    }

    private void registerDevice(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    final String token = args.getString(0);
                    final String userKey = args.getString(0);

                    CampaignClassic.registerDevice(token, userKey, null,new AdobeCallback<Boolean>() {
                        @Override
                        public void call(final Boolean status) {
                            Log.d("TestApp", "Registration Status: " + status);
                            callbackContext.success();
                        }
                    });
                } catch (final Exception ex) {
                    final String errorMessage = String.format("Exception in call to setAdvertisingIdentifier: %s", ex.getLocalizedMessage());
                    MobileCore.log(LoggingMode.WARNING, "AEP SDK", errorMessage);
                    callbackContext.error(errorMessage);
                }
            }
        });
    }

    // ===============================================================
    // Helpers
    // ===============================================================
    private HashMap<String, String> getStringMapFromJSON(JSONObject data) {
        HashMap<String, String> map = new HashMap<String, String>();
        @SuppressWarnings("rawtypes")
        Iterator it = data.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                map.put(n, data.getString(n));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return map;
    }

    private HashMap<String, Object> getObjectMapFromJSON(JSONObject data) {
        HashMap<String, Object> map = new HashMap<String, Object>();
        @SuppressWarnings("rawtypes")
        Iterator it = data.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                map.put(n, data.getString(n));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return map;
    }

    private Event getEventFromMap(final HashMap<String, Object> event) throws Exception {
        return new Event.Builder(
            event.get("name").toString(),
            event.get("type").toString(),
            event.get("source").toString()
            ).setEventData(getObjectMapFromJSON(new JSONObject(event.get("data").toString()))).build();
    }

    private HashMap<String, Object> getMapFromEvent(final Event event) {
        final HashMap<String, Object> eventMap = new HashMap<>();
        eventMap.put("name", event.getName());
        eventMap.put("type", event.getType());
        eventMap.put("source", event.getSource());
        eventMap.put("data", event.getEventData());

        return eventMap;
    }

    // ===============================================================
    // Plugin lifecycle events
    // ===============================================================
    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        MobileCore.setApplication(this.cordova.getActivity().getApplication());
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
		Bundle extras = this.cordova.getActivity().getIntent().getExtras();
        if (extras != null) {
            String deliveryId = extras.getString("_dId");
            String messageId = extras.getString("_mId");
            if (deliveryId != null && messageId != null) {
                Map<String,String> trackInfo = new HashMap<>();
                trackInfo.put("_mId", messageId);
                trackInfo.put("_dId", deliveryId);

                // Send the tracking information for message opening
                CampaignClassic.trackNotificationClick(trackInfo);
            }
        }
    }
}