package com.konvergence.acc.cordova.plugin;

import android.util.Log;
import java.util.Map;
import java.util.HashMap;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import com.adobe.marketing.mobile.CampaignClassic;

public class ACC_MessagingService extends FirebaseMessagingService {

    private static final String TAG = "ACC_MessagingService";

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Log.d(TAG, "New token: " + token);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d("ACC_MessagingService", "Receive message from: " + remoteMessage.getFrom());
        Map<String,String> payloadData = message.getData();

        // Check if message contains data payload.
        if (payloadData.size() > 0) {
            Map<String,String> trackInfo = new HashMap<>();
            trackInfo.put("_mId", payloadData.get("_mId"));
            trackInfo.put("_dId", payloadData.get("_dId"));

            // Send the tracking information for message received
            CampaignClassic.trackNotificationReceive(trackInfo);
        }
    }
}
