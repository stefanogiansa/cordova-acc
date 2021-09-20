package com.konvergence.acc.cordova;

import android.app.Application;
import android.util.Log;
import com.adobe.marketing.mobile.CampaignClassic;
import com.adobe.marketing.mobile.Lifecycle;

public class ACC_Initialize extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        MobileCore.setApplication(this);
        MobileCore.setLogLevel(LoggingMode.VERBOSE);

        try {
            CampaignClassic.registerExtension();
            Lifecycle.registerExtension();
            MobileCore.start(null);
        } catch (Exception e) {
            Log.e("CampaignClassicTestApp", e.getMessage());
        }
    }
}