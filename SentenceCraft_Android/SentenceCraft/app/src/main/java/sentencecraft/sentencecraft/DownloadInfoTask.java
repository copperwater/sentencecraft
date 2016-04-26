package sentencecraft.sentencecraft;

import android.content.Context;
import android.os.AsyncTask;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

/**
 * Created by zqiu on 4/24/16.
 * Used to make requests to the backend server
 */
public class DownloadInfoTask extends AsyncTask<String, String, String> {

    private View rootView;
    private String appName;
    private int editId;
    private String command;
    private Context context;

    public DownloadInfoTask (View rootView, Context context, String command, int editId){
        this.rootView=rootView;
        this.appName = context.getString(R.string.app_name);
        this.editId = editId;
        this.command = command;
        this.context = context;
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
    
    // onPostExecute displays the results of the AsyncTask.
    @Override
    protected void onPostExecute(String result) {
        if(command.equals("View")){
            ArrayList<String> data = interpretView(result);
            TableLayout tl=(TableLayout)rootView.findViewById(editId);
            //remove rows in existing table
            tl.removeAllViews();
            for(int i = 0; i < data.size(); ++i){
                TableRow row = new TableRow(context);
                TableRow.LayoutParams lp = new TableRow.LayoutParams(TableRow.LayoutParams.WRAP_CONTENT);
                row.setLayoutParams(lp);
                TextView text= new TextView(context);
                text.setText(context.getString(R.string.view_sentence_part,i,data.get(i)));
                text.setPadding(0, 0, 0, (int) rootView.getResources().getDimension(R.dimen.activity_vertical_margin));
                text.setTextColor((int) ContextCompat.getColor(context, R.color.colorBlack));
                row.addView(text);
                tl.addView(row,i);
            }
        }else{
            TextView textView = (TextView)rootView.findViewById(editId);
            textView.setText(result);
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
            conn.connect();
            int response = conn.getResponseCode();
            Log.d(appName, "The response is: " + response);
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
    private String readIt(InputStream stream, int len) throws IOException, UnsupportedEncodingException {
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

    //interprets what's read from view-sentences
    private ArrayList<String> interpretView(String data){
        ArrayList<String> toReturn = new ArrayList<>();
        String temp = "";
        try{
            JSONArray reader= new JSONArray(data);
            for(int i = 0; i < reader.length(); ++i){
                JSONObject firstSentence = reader.getJSONObject(i);
                JSONArray lexemes = firstSentence.getJSONArray("lexemes");
                temp = "";
                for(int j = 0; j < lexemes.length(); ++j){
                    temp  += lexemes.getString(j) + " ";
                }
                toReturn.add(temp);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if(toReturn.size() == 0){
            toReturn.add(data);
        }
        return toReturn;
    }
}
