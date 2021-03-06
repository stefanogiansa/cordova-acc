package com.oasitigre.kwallet;

import android.os.Bundle;
import android.util.Log;
import org.apache.cordova.*;

import com.adobe.marketing.mobile.AdobeCallback;
import com.adobe.marketing.mobile.CampaignClassic;
import com.adobe.marketing.mobile.Identity;
import com.adobe.marketing.mobile.InvalidInitException;
import com.adobe.marketing.mobile.Lifecycle;
import com.adobe.marketing.mobile.LoggingMode;
import com.adobe.marketing.mobile.MobileCore;
import com.adobe.marketing.mobile.Signal;
import com.adobe.marketing.mobile.UserProfile;

public class MainActivity extends CordovaActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        // enable Cordova apps to be started in the background
        Bundle extras = getIntent().getExtras();
        if (extras != null && extras.getBoolean("cdvStartInBackground", false)) {
            moveTaskToBack(true);
        }

        MobileCore.setApplication(getApplication());
        MobileCore.setLogLevel(LoggingMode.DEBUG);

        try {
            CampaignClassic.registerExtension();
            UserProfile.registerExtension();
            Identity.registerExtension();
            Lifecycle.registerExtension();
            Signal.registerExtension();
            MobileCore.start(new AdobeCallback () {
                @Override
                public void call(Object o) {
					String accAppId = getResources().getString(R.string.acc_app_id);
					MobileCore.configureWithAppID(accAppId);
                }
            });
        } catch (Exception e) {
            Log.e("CampaignClassicTestApp", e.getMessage());
        }

        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
    }
}