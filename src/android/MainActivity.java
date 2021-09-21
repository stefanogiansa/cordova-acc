package <%PACKAGE_NAME%>;

import android.os.Bundle;
import android.webkit.WebView;
import org.apache.cordova.*;

public class MainActivity extends CordovaActivity
{
    private PopupBridge mPopupBridge;
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        // enable Cordova apps to be started in the background
        Bundle extras = getIntent().getExtras();
        if (extras != null && extras.getBoolean("cdvStartInBackground", false)) {
            moveTaskToBack(true);
        }

        MobileCore.setApplication(this);
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
                    MobileCore.configureWithAppID("36817ad82b35/ff9a58fd45ca/launch-b54585ec721d");
                }
            });
        } catch (Exception e) {
            Log.e("CampaignClassicTestApp", e.getMessage());
        }

        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
    }
}