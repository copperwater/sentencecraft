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
 * Template class for downloading/sending information to and from a site
 * Has sendAdditionalData that a class can extend to send additional information
 * Can also extend parent class's onPostExecute to change what to do with the relieved data.
 */
public class DownloadInfoTask extends AsyncTask<String, String, String> {

    protected View rootView;
    protected Context context;
    protected String appName;
    protected int editId;
    private int responseCode;

    /** constructor. sets values appropriately */
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
        //always need at least two:form method and URL
        if(urls.length < 2){
            return "Sorry don't know url to connect to.";
        }
        try {
            return downloadUrl(urls[0],urls[1]);
        } catch (IOException e) {
            e.printStackTrace();
            return "Unable to retrieve web page. URL may be invalid.";
        }
    }

    private String downloadUrl(String method,String myUrl) throws IOException {
        String contentAsString = "";
        InputStream is = null;
        int len = 500; // Read in 500 characters at a time

        try {
            //set up URL request
            URL url = new URL(myUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(10000 /* milliseconds */);
            conn.setConnectTimeout(1000 /* milliseconds */);
            conn.setRequestMethod(method);
            conn.setDoInput(true);

            // Starts the query
            sendAdditionalData(conn);

            //deal with response code from server
            responseCode = conn.getResponseCode();
            Log.d(appName, "The response is: " + responseCode);
            if(responseCode == 200){
                is = conn.getInputStream();
            }else{
                is = conn.getErrorStream();
            }

            // Convert the InputStream into a string and store in contentAsString
            contentAsString += readIt(is, len);
            Log.d(appName, "received:length " + contentAsString.length() + " " +
                    contentAsString.substring(0,Math.min(len,contentAsString.length())));
        } finally {
            // Makes sure that the InputStream is closed after the app is finished using it.
            if (is != null) {
                is.close();
            }
        }
        return contentAsString;
    }

    /** Reads an InputStream and converts it to a String. */
    private String readIt(InputStream stream, int len) throws IOException {
        int numRead = 0;
        String toReturn = "";
        Reader reader = new InputStreamReader(stream, "UTF-8");
        char[] buffer = new char[len];
        while(numRead >= 0) {
            numRead = reader.read(buffer);
            if(numRead > 0){
                toReturn += new String(buffer,0,numRead);
            }
        }
        return toReturn;
    }

    /** can be overwritten to provide additional form data */
    protected void sendAdditionalData(HttpURLConnection conn) throws IOException{
        conn.connect();
    }

    /** others can call to see what the response from the server was */
    public int getResponseCode(){
        return responseCode;
    }
}
