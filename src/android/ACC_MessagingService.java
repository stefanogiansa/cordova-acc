package com.konvergence.acc.cordova;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Map;
import java.util.HashMap;

import com.google.firebase.messaging.RemoteMessage;
import com.adobe.marketing.mobile.CampaignClassic;

import org.apache.cordova.firebase.FirebasePluginMessageReceiver;
import org.apache.cordova.firebase.FirebasePluginMessageReceiverManager;

public class ACC_MessagingService extends FirebasePluginMessageReceiver {

    private static final String TAG = "ACC_MessagingService";

	public ACC_MessagingService() {
		FirebasePluginMessageReceiverManager.register(this);
	}

    @Override
    public boolean onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        Log.d("ACC_MessagingService", "Receive message from: " + remoteMessage.getFrom());
        Map<String,String> payloadData = remoteMessage.getData();
        // Check if message contains data payload.
        if (payloadData.size() > 0) {
            Map<String,String> trackInfo = new HashMap<>();
            trackInfo.put("_mId", payloadData.get("_mId"));
            trackInfo.put("_dId", payloadData.get("_dId"));

            // Send the tracking information for message received
            CampaignClassic.trackNotificationReceive(trackInfo);
        }
		return false;
	}

	@Override
	public boolean sendMessage(Bundle bundle) {
		return false;
	}
}
