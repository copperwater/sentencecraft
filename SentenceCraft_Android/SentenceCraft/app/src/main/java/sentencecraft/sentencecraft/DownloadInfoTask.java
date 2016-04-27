package sentencecraft.sentencecraft;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by zqiu on 4/24/16.
 * Used to make requests to the backend server
 */
public class DownloadInfoTask extends AsyncTask<String, String, String> {

    protected View rootView;
    protected String appName;
    protected int editId;
    protected Context context;
    private int responseCode;

    protected DownloadInfoTask (View rootView, Context context, int editId){
        this.rootView=rootView;
        this.appName = context.getString(R.string.app_name);
        this.editId = editId;
        this.context = context;
        this.responseCode = -1;
    }

    @Override
    protected String doInBackground(String... urls) {
        // params comes from the execute() call: params[0] is the url.
        if(urls.length < 2){
            return "Sorry don't know url to connect to.";
        }
        try {
            return downloadUrl(urls[0],urls[1]);
        } catch (IOException e) {
            return "Unable to retrieve web page. URL may be invalid.";
        }
    }

    private String downloadUrl(String method,String myurl) throws IOException {
        String contentAsString = "";
        InputStream is = null;
        // Read in 500 characters at a time
        int len = 500;

        try {
            URL url = new URL(myurl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(10000 /* milliseconds */);
            conn.setConnectTimeout(15000 /* milliseconds */);
            conn.setRequestMethod(method);
            conn.setDoInput(true);
            // Starts the query
            sendAdditionalData(conn);

            responseCode = conn.getResponseCode();
            Log.d(appName, "The response is: " + responseCode);
            is = conn.getInputStream();

            // Convert the InputStream into a string
            contentAsString += readIt(is, len);
            Log.d(appName, "recieved:length " + contentAsString.length() + " " + contentAsString.substring(0,len));

            // Makes sure that the InputStream is closed after the app is
            // finished using it.
        } finally {
            if (is != null) {
                is.close();
            }
        }
        return contentAsString;
    }

    // Reads an InputStream and converts it to a String.
    private String readIt(InputStream stream, int len) throws IOException {
        int numRead = 0;
        String toReturn = "";
        Reader reader = null;
        reader = new InputStreamReader(stream, "UTF-8");
        char[] buffer = new char[len];
        do {
            numRead = reader.read(buffer);
            toReturn += new String(buffer);
        }while(numRead != -1);
        return toReturn;
    }

    protected void sendAdditionalData(HttpURLConnection conn) throws IOException{
        conn.connect();
    }

    public int getResponseCode(){
        return responseCode;
    }
}
